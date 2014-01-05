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

@interface LJSTravelSouthYorkshire ()
@property (nonatomic, copy, readwrite) void (^completion)(NSDictionary *data, NSURL *nextPageURL, NSError *error);
@end

@implementation LJSTravelSouthYorkshire

- (void)requestDepatureDataForStopNumber:(NSString *)stopNumber completion:(void (^)(NSDictionary *data, NSURL *nextPageURL, NSError *error))completion {
    NSURL *url = [self urlForStopNumber:stopNumber];
    [self requestDepatureDataAtURL:url completion:completion];
}

- (void)requestDepatureDataAtURL:(NSURL *)url completion:(void (^)(id json, NSURL *nextPageURL, NSError *))completion {
    self.completion = completion;
    
    LJSWebContentDownloader *contentDownloader = [[LJSWebContentDownloader alloc] initWithURL:url];
    NSError *error = nil;
    NSString *htmlString = [contentDownloader downloadHTML:&error];
    
    if (error) {
        [self safeCallCompletionBlockWithDepatureData:nil nextPageURL:nil error:error];
    }
    
    [self scrapeHTML:htmlString];
}

- (NSURL *)urlForStopNumber:(NSString *)stopNumber {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://tsy.acislive.com/pip/stop.asp?naptan=%@&textonly=1&pda=1", stopNumber]];
}

- (void)scrapeHTML:(NSString *)htmlString {
    LJSScraper *scraper = [[LJSScraper alloc] initWithHTMLString:htmlString];
    NSDictionary *depatureData = [scraper scrapeDepatureData];
    NSURL *nextPageURL = [scraper scrapeNextPageURL];
    
    [self safeCallCompletionBlockWithDepatureData:depatureData nextPageURL:nextPageURL error:nil];
}

- (void)safeCallCompletionBlockWithDepatureData:(NSDictionary *)depatureData nextPageURL:(NSURL *)nextPageURL error:(NSError *)error {
    if (self.completion) {
        self.completion(depatureData, nextPageURL, error);
    }
}

@end
