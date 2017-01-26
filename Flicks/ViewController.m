//
//  ViewController.m
//  Flicks
//
//  Created by  Michael Friedman on 1/23/17.
//  Copyright © 2017  Michael Friedman. All rights reserved.
//

#import "ViewController.h"
#import "MovieCell.h"
#import "MovieCollectionCell.h"
#import "MovieModel.h"
#import "DetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MBProgressHUD.h>

@interface ViewController () <UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *movieTableView;
@property (nonatomic, strong) NSArray<MovieModel *> *movies;
@property (weak, nonatomic) IBOutlet UIView *errorMessageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *chooseViewControl;

//@property (weak, nonatomic) IBOutlet UICollectionView *movieCollectionView;
@property (strong, nonatomic) UICollectionView *movieCollectionView;


@end

@implementation ViewController

UIRefreshControl *refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.movieTableView.dataSource = self;

    if ([self.restorationIdentifier isEqualToString:@"top_rated"]) {
        self.listType = @"top";
    } else {
        self.listType = @"now";
    }

    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.movieTableView addSubview:refreshControl];
    [self.movieCollectionView addSubview:refreshControl];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
    CGFloat itemWidth = screenWidth / 3; // 90
    CGFloat itemHeight = 136 * (itemWidth / 90); // 136

    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    UICollectionView *movieCollection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [movieCollection registerClass:[MovieCollectionCell class] forCellWithReuseIdentifier:@"movieCollCell"];

    [self.view addSubview:movieCollection];
    movieCollection.hidden = YES;
    movieCollection.dataSource = self;
    movieCollection.delegate = self;
    self.movieCollectionView = movieCollection;

    [self fetchMovies];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchMovies {

    NSString *apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    NSString *urlString =
    [@"https://api.themoviedb.org/3/movie/now_playing?api_key=" stringByAppendingString:apiKey];

    if ([self.listType isEqual: @"top"]) {
        urlString =
        [@"https://api.themoviedb.org/3/movie/top_rated?api_key=" stringByAppendingString:apiKey];
    }

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];

    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                [MBProgressHUD hideHUDForView:self.view animated:YES];

                                                if (!error) {
                                                    self.errorMessageView.hidden = YES;
                                                    [self.view sendSubviewToBack:self.errorMessageView];
                                                    
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    NSLog(@"Response: %@", responseDictionary);

                                                    NSArray *results = responseDictionary[@"results"];
                                                    NSMutableArray *models = [NSMutableArray array];
                                                    for (NSDictionary *result in results) {
                                                        MovieModel *model = [[MovieModel alloc] initWithDictionary:result];
                                                        [models addObject:model];
                                                    }
                                                    self.movies = models;
                                                    [self.movieTableView reloadData];
                                                    [self.movieCollectionView reloadData];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                    self.errorMessageView.hidden = NO;
                                                    [self.view bringSubviewToFront:self.errorMessageView];
                                                }
                                                [refreshControl endRefreshing];
                                            }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [task resume];

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.movieCollectionView.frame = self.view.bounds;
}

// make segment controller work
- (IBAction)choseNewView:(id)sender {
    NSInteger selectedSegment = self.chooseViewControl.selectedSegmentIndex;
    switch (selectedSegment ) {
        case 0:
            // list
            self.movieCollectionView.hidden = YES;
            self.movieTableView.hidden = NO;
            break;

        case 1:
            // grid
            self.movieCollectionView.hidden = NO;
            self.movieTableView.hidden = YES;
            break;

        default:
            break;
    }
}

// segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"show_detail"])
    {
        // get selected movie model
        NSIndexPath *indexPath;
        NSInteger selectedSegment = self.chooseViewControl.selectedSegmentIndex;
        switch (selectedSegment ) {
            case 0:
                // list
                indexPath = [self.movieTableView indexPathForCell:sender];
                break;

            case 1:
                // grid
                indexPath = [self.movieCollectionView indexPathForCell:sender];
                break;
                
            default:
                break;
        }

        MovieModel *model = [self.movies objectAtIndex:indexPath.row];

        // Get reference to the destination view controller
        DetailViewController *vc = [segue destinationViewController];

        // tell destination about the selected movie
        [vc setMovie:model];
    }
}

#pragma mark table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MovieCell* cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell"];

    MovieModel *model = [self.movies objectAtIndex:indexPath.row];

    [cell.titleLabel setText:model.movieTitle];
    [cell.overviewLabel setText:model.movieDescription];
    [cell.posterImage setImageWithURL:model.backgroundURL];

    return cell;
}

#pragma mark collection view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"movieCollCell" forIndexPath:indexPath];

    MovieModel *model = [self.movies objectAtIndex:indexPath.item];
    cell.model = model;
    [cell reloadData];
    
    return cell;
}

#pragma mark collection view delegate

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"show_detail" sender:[collectionView cellForItemAtIndexPath:indexPath]];
}

@end
