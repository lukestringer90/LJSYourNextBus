//
//  LJSWebContentDownloader.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 05/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSWebContentDownloader.h"

static BOOL const LoadHTMLFromBundle = YES;

@implementation LJSWebContentDownloader


- (NSString *)downloadHTMLFromURL:(NSURL *)url error:(NSError **)error {
    if (LoadHTMLFromBundle) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"tram" ofType: @"html"];
        return [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    }
    
    return [[NSString alloc] initWithContentsOfURL:url
                                          encoding:NSStringEncodingConversionAllowLossy
                                             error:error];
}

                                  
@end
