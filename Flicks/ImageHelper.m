//
//  ImageHelper.m
//  Flicks
//
//  Created by  Michael Friedman on 1/26/17.
//  Copyright © 2017  Michael Friedman. All rights reserved.
//

#import "ImageHelper.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation ImageHelper


+ (void) loadImageWithPlaceholder:(UIImageView*)view small:(NSURL*)smallURL large:(NSURL*)largeURL {
    NSURLRequest *smallImageRequest = [[NSURLRequest alloc] initWithURL:smallURL];
    NSURLRequest *largeImageRequest = [[NSURLRequest alloc] initWithURL:largeURL];
    __weak UIImageView *weakView = view;

    [weakView setImageWithURLRequest:smallImageRequest placeholderImage:nil
                             success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                 weakView.image = image;

                                 [weakView setImageWithURLRequest:largeImageRequest placeholderImage:image
                                                          success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {

                                                              if (response != nil) {
                                                                  weakView.alpha = 0.0;
                                                                  weakView.image = image;
                                                                  [UIView animateWithDuration:0.3 animations:^{
                                                                      weakView.alpha = 1;
                                                                  }];
                                                              } else {
                                                                  weakView.image = image;
                                                              }

                                                          }
                                                          failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                              //
                                                          }];

                             }
                             failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                 //
                             }];
}

@end
