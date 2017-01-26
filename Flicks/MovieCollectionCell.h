//
//  MovieCollectionCell.h
//  Flicks
//
//  Created by  Michael Friedman on 1/25/17.
//  Copyright © 2017  Michael Friedman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"

@interface MovieCollectionCell : UICollectionViewCell

@property (nonatomic, strong) MovieModel *model;

- (void) reloadData;

@end
