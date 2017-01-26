//
//  MovieCell.h
//  Flicks
//
//  Created by  Michael Friedman on 1/23/17.
//  Copyright © 2017  Michael Friedman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"

@interface MovieCell : UITableViewCell

@property (nonatomic, strong) MovieModel *model;
- (void) reloadData;

@end
