//
//  MovieCell.m
//  Flicks
//
//  Created by  Michael Friedman on 1/23/17.
//  Copyright © 2017  Michael Friedman. All rights reserved.
//

#import "MovieCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ImageHelper.h"

@interface MovieCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;

@end


@implementation MovieCell

- (void) reloadData {
    [self.titleLabel setText:self.model.movieTitle];
    [self.overviewLabel setText:self.model.movieDescription];
    [ImageHelper loadImageWithPlaceholder:self.posterImage small:self.model.posterURL large:self.model.backgroundURL];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
