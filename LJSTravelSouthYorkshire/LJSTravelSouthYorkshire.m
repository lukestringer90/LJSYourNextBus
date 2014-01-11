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
@property (nonatomic, copy) LJSDepatureDataCompletion completion;
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

- (void)depatureDataForNaPTANCode:(NSString *)NaPTANCode completion:(LJSDepatureDataCompletion)completion {
    NSURL *url = [self urlForStopNumber:NaPTANCode];
    [self depatureDataAtURL:url completion:completion];
}

- (void)depatureDataAtURL:(NSURL *)url completion:(LJSDepatureDataCompletion)completion {
    self.completion = completion;
    
    NSError *error = nil;
    NSString *htmlString = [self.contentDownloader downloadHTMLFromURL:url error:&error];
    
    if (error) {
        [self safeCallCompletionBlockWithDepatureData:nil laterURL:nil earilierURL:nil error:error];
    }
    else {
        [self scrapeHTML:htmlString];
    }
}

// TODO: Change name to NaPTAN code and write tests
- (NSURL *)urlForStopNumber:(NSString *)stopNumber {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://tsy.acislive.com/pip/stop.asp?naptan=%@&textonly=1&pda=1", stopNumber]];
}

- (void)scrapeHTML:(NSString *)htmlString {
    NSDictionary *depatureData = [self.scraper scrapeDepatureDataFromHTML:htmlString];
    NSURL *laterURL = [self.scraper scrapeLaterDepaturesURL:htmlString];
    
    // TODO: Scrape earlier URL
    NSURL *earlierURL = nil;
    
    [self safeCallCompletionBlockWithDepatureData:depatureData laterURL:laterURL earilierURL:earlierURL error:nil];
}

- (void)safeCallCompletionBlockWithDepatureData:(NSDictionary *)depatureData laterURL:(NSURL *)laterURL earilierURL:(NSURL *)earilierURL error:(NSError *)error {
    if (self.completion) {
        self.completion(depatureData, laterURL, earilierURL, error);
        self.completion = nil;
    }
}


@end
