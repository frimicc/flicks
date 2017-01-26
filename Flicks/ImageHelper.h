//
//  ImageHelper.h
//  Flicks
//
//  Created by  Michael Friedman on 1/26/17.
//  Copyright © 2017  Michael Friedman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageHelper : NSObject
+ (void) loadImageWithPlaceholder:(UIImageView*)view small:(NSURL*)smallURL large:(NSURL*)largeURL;

@end
