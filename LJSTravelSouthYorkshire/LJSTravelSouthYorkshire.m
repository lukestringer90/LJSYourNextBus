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
@property (nonatomic, copy, readwrite) void (^completion)(NSDictionary *data, NSURL *laterDepaturesURL, NSError *error);
@property (nonatomic, strong) LJSScraper *scraper;
@property (nonatomic, strong) LJSWebContentDownloader *contentDownloader;
@end

@implementation LJSTravelSouthYorkshire

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scraper = [[LJSScraper alloc] init];
        self.contentDownloader = [[LJSWebContentDownloader alloc] init];
    }
    return self;
}

- (void)depatureDataForNaPTANCode:(NSString *)NaPTANCode completion:(void (^)(NSDictionary *data, NSURL *nextPageURL, NSError *error))completion {
    NSURL *url = [self urlForStopNumber:NaPTANCode];
    [self depatureDataAtURL:url completion:completion];
}

- (void)depatureDataAtURL:(NSURL *)url completion:(void (^)(id json, NSURL *nextPageURL, NSError *))completion {
    self.completion = completion;
    
    NSError *error = nil;
    NSString *htmlString = [self.contentDownloader downloadHTMLFromURL:url error:&error];
    
    if (error) {
        [self safeCallCompletionBlockWithDepatureData:nil laterDepaturesURL:nil error:error];
    }
    else {
        [self scrapeHTML:htmlString];
    }
}

- (NSURL *)urlForStopNumber:(NSString *)stopNumber {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://tsy.acislive.com/pip/stop.asp?naptan=%@&textonly=1&pda=1", stopNumber]];
}

- (void)scrapeHTML:(NSString *)htmlString {
    NSDictionary *depatureData = [self.scraper scrapeDepatureDataFromHTML:htmlString];
    NSURL *laterDepaturesURL = [self.scraper scrapeLaterDepaturesURL:htmlString];
    
    [self safeCallCompletionBlockWithDepatureData:depatureData laterDepaturesURL:laterDepaturesURL error:nil];
}

- (void)safeCallCompletionBlockWithDepatureData:(NSDictionary *)depatureData laterDepaturesURL:(NSURL *)laterDepaturesURL error:(NSError *)error {
    if (self.completion) {
        self.completion(depatureData, laterDepaturesURL, error);
        self.completion = nil;
    }
}

@end
