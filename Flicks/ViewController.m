//
//  ViewController.m
//  Flicks
//
//  Created by  Michael Friedman on 1/23/17.
//  Copyright © 2017  Michael Friedman. All rights reserved.
//

#import "ViewController.h"
#import "MovieCell.h"
#import "MovieModel.h"
#import "DetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MBProgressHUD.h>

@interface ViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *movieTableView;
@property (nonatomic, strong) NSArray<MovieModel *> *movies;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.movieTableView.dataSource = self;

    if ([self.restorationIdentifier isEqualToString:@"top_rated"]) {
        self.listType = @"top";
    } else {
        self.listType = @"now";
    }
    
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
                                                    [self.movieTableView reloadData]; // build the table again, now that we have data
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                            }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [task resume];

}

// segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"show_detail"])
    {
        // get selected movie model
        NSIndexPath *indexPath = [self.movieTableView indexPathForCell:sender];
        MovieModel *model = [self.movies objectAtIndex:indexPath.row];

        // Get reference to the destination view controller
        DetailViewController *vc = [segue destinationViewController];

        // tell destination about the selected movie
        [vc setMovie:model];
    }
}

// data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MovieCell* cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell"];

    MovieModel *model = [self.movies objectAtIndex:indexPath.row];

    [cell.titleLabel setText:model.movieTitle];
    [cell.overviewLabel setText:model.movieDescription];
    [cell.posterImage setImageWithURL:model.posterURL];

    return cell;
}

@end
