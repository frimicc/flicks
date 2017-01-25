//
//  DetailViewController.m
//  Flicks
//
//  Created by  Michael Friedman on 1/24/17.
//  Copyright © 2017  Michael Friedman. All rights reserved.
//

#import "DetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollContents;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *movieDescription;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSLog(@"%@", self.movie);
    self.movieTitle.text = self.movie.movieTitle;
    self.movieDescription.text = self.movie.movieDescription;
    [self.backgroundImage setImageWithURL:self.movie.backgroundURL];

    self.movieTitle.textColor = [UIColor whiteColor];
    self.movieDescription.textColor = [UIColor whiteColor];
    [self.movieDescription sizeToFit];

    self.cardView.backgroundColor = [UIColor darkGrayColor];
    [self.cardView sizeToFit];

    CGFloat scrollerHeight = CGRectGetHeight(self.cardView.bounds);
    CGFloat scrollerYFromBottom = self.view.bounds.size.height - scrollerHeight - 10;
    self.scrollContents.contentInset = UIEdgeInsetsMake(scrollerHeight, 0, 0, 0);
    self.scrollContents.contentSize = CGSizeMake(self.scrollContents.bounds.size.width, scrollerHeight);
    self.scrollContents.frame = CGRectMake(24, scrollerYFromBottom, self.scrollContents.bounds.size.width, scrollerHeight);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
