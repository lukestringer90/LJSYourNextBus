//
//  LJSTravelSouthYorkshire.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 04/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSTravelSouthYorkshire.h"
#import "LJSWebContentDownloader.h"
#import "LJSScraper.h"


@implementation LJSTravelSouthYorkshire

- (void)requestDepatureDataForStopNumber:(NSString *)stopNumber completion:(void (^)(NSDictionary *data, NSURL *nextPageURL, NSError *error))completion {
    NSURL *url = [self urlForStopNumber:stopNumber];
    [self requestDepatureDataAtURL:url completion:completion];
}

- (void)requestDepatureDataAtURL:(NSURL *)url completion:(void (^)(id json, NSURL *nextPageURL, NSError *))completion {
    LJSWebContentDownloader *contentDownloader = [[LJSWebContentDownloader alloc] initWithURL:url];
    NSError *error = nil;
    NSString *htmlString = [contentDownloader downloadHTML:&error];
    
    LJSScraper *scraper = [[LJSScraper alloc] initWithHTMLString:htmlString];
    NSDictionary *json = [scraper scrapeDepatureData];
    NSURL *nextPageURL = [scraper scrapeNextPageURL];
    
    if (completion) {
        completion(json, nextPageURL, nil);
    }
}

- (NSURL *)urlForStopNumber:(NSString *)stopNumber {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://tsy.acislive.com/pip/stop.asp?naptan=%@&textonly=1&pda=1", stopNumber]];
}

@end
