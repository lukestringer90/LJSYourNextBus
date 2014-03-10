//
//  LJSYourNextBusClient.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 04/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSYourNextBusClient.h"
#import "LJSHTMLDownloader.h"
#import "LJSScraper.h"

@interface LJSYourNextBusClient ()
@property (nonatomic, copy) LJSLiveDataCompletion completion;
@property (nonatomic, strong) LJSScraper *scraper;
@property (nonatomic, strong) LJSHTMLDownloader *htmlDownloader;
@end

@implementation LJSYourNextBusClient

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scraper = [[LJSScraper alloc] init];
        self.htmlDownloader = [[LJSHTMLDownloader alloc] init];
    }
    return self;
}

- (void)liveDataForNaPTANCode:(NSString *)NaPTANCode completion:(LJSLiveDataCompletion)completion {
    NSURL *url = [self urlForNaPTANCode:NaPTANCode];
    [self liveDataAtURL:url completion:completion];
}

- (void)liveDataAtURL:(NSURL *)url completion:(LJSLiveDataCompletion)completion {
    self.completion = completion;
    
    NSError *error = nil;
    NSString *htmlString = [self.htmlDownloader downloadHTMLFromURL:url error:&error];
    
    if (error || !htmlString) {
		[self safeCallCompletionBlockWithStop:nil laterURL:nil earilierURL:nil error:error];
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
    LJSStop *stop = [self.scraper scrapeStopDataFromHTML:html];
    NSURL *laterURL = [self.scraper scrapeLaterDepaturesURL:html];
    NSURL *earlierURL = [self.scraper scrapeEarlierDepaturesURL:html];
    
    [self safeCallCompletionBlockWithStop:stop laterURL:laterURL earilierURL:earlierURL error:nil];
}

- (void)safeCallCompletionBlockWithStop:(LJSStop *)stop laterURL:(NSURL *)laterURL earilierURL:(NSURL *)earilierURL error:(NSError *)error {
    if (self.completion) {
        self.completion(stop, laterURL, earilierURL, error);
        self.completion = nil;
    }
}


@end
