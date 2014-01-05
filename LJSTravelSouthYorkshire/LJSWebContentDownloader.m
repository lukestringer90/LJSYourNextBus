//
//  LJSWebContentDownloader.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 05/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSWebContentDownloader.h"

static BOOL const LoadHTMLFromBundle = NO;

@interface LJSWebContentDownloader ()
@property (nonatomic, strong, readwrite) NSURL *url;
@end

@implementation LJSWebContentDownloader

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (NSString *)downloadHTML:(NSError **)error {
    if (LoadHTMLFromBundle) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"tram" ofType: @"html"];
        return [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    }
    
    return [[NSString alloc] initWithContentsOfURL:self.url
                                          encoding:NSStringEncodingConversionAllowLossy
                                             error:error];
}

                                  
@end
