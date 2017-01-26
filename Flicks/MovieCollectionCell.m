//
//  MovieCollectionCell.m
//  Flicks
//
//  Created by  Michael Friedman on 1/25/17.
//  Copyright © 2017  Michael Friedman. All rights reserved.
//

#import "MovieCollectionCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ImageHelper.h"

@interface MovieCollectionCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *posterImage;

@end

@implementation MovieCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        self.posterImage = imageView;
    }
    return self;
}

- (void) reloadData {
    [ImageHelper loadImageWithPlaceholder:self.posterImage small:self.model.posterURL large:self.model.backgroundURL];
    [self setNeedsLayout]; // forces layoutSubviews to be called
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.posterImage.frame = self.contentView.bounds; // make ImageView same size as content area
}

@end
