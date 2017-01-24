//
//  DetailViewController.h
//  Flicks
//
//  Created by  Michael Friedman on 1/24/17.
//  Copyright © 2017  Michael Friedman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"

@interface DetailViewController : UIViewController

@property (nonatomic, strong) MovieModel *movie;

@end
