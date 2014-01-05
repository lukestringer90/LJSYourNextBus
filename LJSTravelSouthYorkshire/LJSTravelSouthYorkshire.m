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
    
    if (error) {
        [self safeCallCompletionBlock:completion depatureData:nil nextPageURL:nil error:error];
    }
    
    LJSScraper *scraper = [[LJSScraper alloc] initWithHTMLString:htmlString];
    NSDictionary *depatureData = [scraper scrapeDepatureData];
    NSURL *nextPageURL = [scraper scrapeNextPageURL];
    
    [self safeCallCompletionBlock:completion depatureData:depatureData nextPageURL:nextPageURL error:nil];
}

- (NSURL *)urlForStopNumber:(NSString *)stopNumber {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://tsy.acislive.com/pip/stop.asp?naptan=%@&textonly=1&pda=1", stopNumber]];
}

- (void)safeCallCompletionBlock:(void (^)(NSDictionary *data, NSURL *nextPageURL, NSError *error))completion depatureData:(NSDictionary *)depatureData nextPageURL:(NSURL *)nextPageURL error:(NSError *)error {
    if (completion) {
        completion(depatureData, nextPageURL, error);
    }
}

@end
