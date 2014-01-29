//
//  LJSTravelSouthYorkshire.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 04/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSLiveDepatures.h"
#import "LJSHTMLDownloader.h"
#import "LJSScraper.h"

@interface LJSLiveDepatures ()
@property (nonatomic, copy) LJSDepatureDataCompletion completion;
@property (nonatomic, strong) LJSScraper *scraper;
@property (nonatomic, strong) LJSHTMLDownloader *contentDownloader;
@end

@implementation LJSLiveDepatures

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scraper = [[LJSScraper alloc] init];
        self.contentDownloader = [[LJSHTMLDownloader alloc] init];
    }
    return self;
}

- (void)depatureDataForNaPTANCode:(NSString *)NaPTANCode completion:(LJSDepatureDataCompletion)completion {
    NSURL *url = [self urlForNaPTANCode:NaPTANCode];
    [self depatureDataAtURL:url completion:completion];
}

- (void)depatureDataAtURL:(NSURL *)url completion:(LJSDepatureDataCompletion)completion {
    self.completion = completion;
    
    NSError *error = nil;
    NSString *htmlString = [self.contentDownloader downloadHTMLFromURL:url error:&error];
    
    if (error || !htmlString) {
        [self safeCallCompletionBlockWithDepatureData:nil laterURL:nil earilierURL:nil error:error];
    }
    else {
        [self scrapeHTML:htmlString];
    }
}

- (NSURL *)urlForNaPTANCode:(NSString *)stopNumber {
    if (stopNumber) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"http://tsy.acislive.com/pip/stop.asp?naptan=%@&textonly=1&pda=1", stopNumber]];
    }
    return nil;
}

- (void)scrapeHTML:(NSString *)html {
    NSDictionary *depatureData = [self.scraper scrapeDepatureDataFromHTML:html];
    NSURL *laterURL = [self.scraper scrapeLaterDepaturesURL:html];
    NSURL *earlierURL = [self.scraper scrapeEarlierDepaturesURL:html];
    
    [self safeCallCompletionBlockWithDepatureData:depatureData laterURL:laterURL earilierURL:earlierURL error:nil];
}

- (void)safeCallCompletionBlockWithDepatureData:(NSDictionary *)depatureData laterURL:(NSURL *)laterURL earilierURL:(NSURL *)earilierURL error:(NSError *)error {
    if (self.completion) {
        self.completion(depatureData, laterURL, earilierURL, error);
        self.completion = nil;
    }
}


@end
