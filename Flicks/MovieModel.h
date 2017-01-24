//
//  MovieModel.h
//  Flicks
//
//  Created by  Michael Friedman on 1/23/17.
//  Copyright © 2017  Michael Friedman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong) NSString *movieTitle;
@property (nonatomic, strong) NSString *movieDescription;
@property (nonatomic, strong) NSURL *posterURL;
@property (nonatomic, strong) NSURL *backgroundURL;

@end
