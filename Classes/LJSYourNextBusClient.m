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

NSString * const LJSYourNextBusErrorDomain = @"com.yournextbus.domain";

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
    NSString *html = [self.htmlDownloader downloadHTMLFromURL:url error:&error];
    
    if (error || !html) {
		[self safeCallCompletionBlockWithStop:nil messages:nil error:error];
    }
	else if (![self.scraper htmlIsValid:html]) {
		[self safeCallCompletionBlockWithStop:nil messages:nil error:[self invalidHTMLError]];
	}
	else {
		// The present of a message is not dependent on there being any live data.
		// So scrape it and use it in both cases.
		NSArray *messages = [self.scraper scrapeMessagesFromHTML:html];
		if (![self.scraper htmlContainsLiveData:html]) {
			[self safeCallCompletionBlockWithStop:nil messages:messages error:[self dataUnavailableError]];
		}
		else {
			[self scrapeHTML:html messages:messages];
		}
	}
}

- (NSError *)invalidHTMLError {
	NSDictionary *userInfo = @{
							   NSLocalizedDescriptionKey: NSLocalizedString(@"Scraping the YourNextBus HTML failed.", nil),
							   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The HTML did not contain any live data. This could be due to a problems with the YourNextBus service, or an invalid NaPTAN code was specified.", nil),
							   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Try again, making sure the NaPTAN code is valid; an 8 digit number starting with 450 for West Yorkshire or 370 for South Yorkshire.", nil),
							   };
	return [NSError errorWithDomain:LJSYourNextBusErrorDomain
										 code:LJSYourNextBusErrorScrapeFailure
									 userInfo:userInfo];
}

- (NSError *)dataUnavailableError {
	NSDictionary *userInfo = @{
							   NSLocalizedDescriptionKey: NSLocalizedString(@"No YourNextBus data avaiable for the next hour with the specified NaPTAN code.", nil),
							   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"There are no depatures at the stop with the specified NaPTAN code in the next hour, or an invalid NaPTAN code was specified.", nil),
							   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Try again, making sure the NaPTAN code is valid; an 8 digit number starting with 450 for West Yorkshire or 370 for South Yorkshire.", nil),
							   };
	return [NSError errorWithDomain:LJSYourNextBusErrorDomain
							   code:LJSYourNextBusErrorDataUnavaiable
						   userInfo:userInfo];
}

- (NSURL *)urlForNaPTANCode:(NSString *)stopNumber {
    if (stopNumber) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"http://tsy.acislive.com/pip/stop.asp?naptan=%@&textonly=1&pda=1", stopNumber]];
    }
    return nil;
}

- (void)scrapeHTML:(NSString *)html messages:(NSArray *)messages{
    LJSStop *stop = [self.scraper scrapeStopDataFromHTML:html];
    
    [self safeCallCompletionBlockWithStop:stop messages:messages error:nil];
}

- (void)safeCallCompletionBlockWithStop:(LJSStop *)stop messages:(NSArray *)messages error:(NSError *)error {
    if (self.completion) {
        self.completion(stop, messages, error);
        self.completion = nil;
    }
}


@end
