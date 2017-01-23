//
//  MovieModel.m
//  Flicks
//
//  Created by  Michael Friedman on 1/23/17.
//  Copyright © 2017  Michael Friedman. All rights reserved.
//

#import "MovieModel.h"

@implementation MovieModel 

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    if (self) {
        self.movieTitle = dictionary[@"original_title"];
        self.movieDescription = dictionary[@"overview"];
        NSString *posterUrl = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w45%@", dictionary[@"poster_path"] ];
        self.posterURL = [NSURL URLWithString:posterUrl];
    }

    return self;
}

@end
