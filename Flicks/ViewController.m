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
#import <AFNetworking/UIImageView+AFNetworking.h>


@interface ViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *movieTableView;
@property (nonatomic, strong) NSArray<MovieModel *> *movies;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.movieTableView.dataSource = self;
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
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                   // NSLog(@"Response: %@", responseDictionary);

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
    [task resume];

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
    [cell.posterImage setImage:[UIImage imageNamed:@"YahooIcon.png"]];

    return cell;
}

@end
