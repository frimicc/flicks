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
        NSString *backgroundUrl = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w342%@", dictionary[@"poster_path"] ];
        self.backgroundURL = [NSURL URLWithString:backgroundUrl];

        self.searchTitle = self.movieTitle;
        self.searchTitle = [self.searchTitle stringByReplacingOccurrencesOfString:@"The " withString:@""];
        self.searchTitle = [self.searchTitle stringByReplacingOccurrencesOfString:@"An " withString:@""];
        self.searchTitle = [self.searchTitle stringByReplacingOccurrencesOfString:@"A " withString:@""];

    }

    return self;
}

@end
