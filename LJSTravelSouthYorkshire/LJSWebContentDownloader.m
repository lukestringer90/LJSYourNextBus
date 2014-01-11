//
//  LJSWebContentDownloader.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 05/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSWebContentDownloader.h"
@implementation LJSWebContentDownloader

- (NSString *)downloadHTMLFromURL:(NSURL *)url error:(NSError **)error {
    return [[NSString alloc] initWithContentsOfURL:url
                                          encoding:NSStringEncodingConversionAllowLossy
                                             error:error];
}

                                  
@end
