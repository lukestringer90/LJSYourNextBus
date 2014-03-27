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
#import "LJSYourNextBusClient+LJSSaveToDisk.h"
#import "LJSStop.h"

NSString * const LJSYourNextBusErrorDomain = @"com.yournextbus.domain";

@interface LJSYourNextBusClient ()
@property (nonatomic, copy) LJSLiveDataCompletion completion;
@property (nonatomic, copy) NSString *NaPTANCode;
@property (nonatomic, strong) LJSScraper *scraper;
@property (nonatomic, strong) LJSHTMLDownloader *htmlDownloader;
@property (nonatomic, strong) NSOperationQueue *backgroundQueue;

@end

@implementation LJSYourNextBusClient

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scraper = [LJSScraper new];
        self.htmlDownloader = [LJSHTMLDownloader new];
		self.backgroundQueue = [NSOperationQueue new];
    }
    return self;
}

- (void)liveDataForNaPTANCode:(NSString *)NaPTANCode completion:(LJSLiveDataCompletion)completion {
	[self.backgroundQueue addOperationWithBlock:^{
		self.NaPTANCode = NaPTANCode;
		NSURL *url = [self urlForNaPTANCode:NaPTANCode];
		[self liveDataAtURL:url completion:completion];
	}];
}

- (void)refreshStop:(LJSStop *)stop completion:(LJSLiveDataCompletion)completion {
	[self liveDataForNaPTANCode:stop.NaPTANCode completion:completion];
}

- (void)liveDataAtURL:(NSURL *)url completion:(LJSLiveDataCompletion)completion {
    self.completion = completion;
    
    NSError *error = nil;
    NSString *html = [self.htmlDownloader downloadHTMLFromURL:url error:&error];
    
    if (error) {
		[self safeCallCompletionBlockWithStop:nil messages:nil error:error];
    }
	else if (![self.scraper htmlIsValid:html]) {
		[self safeCallCompletionBlockWithStop:nil messages:nil error:[self invalidHTMLError]];
	}
	else {
		NSArray *messages = [self.scraper scrapeMessagesFromHTML:html];
		[self scrapeHTML:html messages:messages];
	}
}

- (NSError *)invalidHTMLError {
	NSDictionary *userInfo = @{
							   NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedString(@"Scraping the YourNextBus HTML failed for the NaPTANCode %@.", nil), self.NaPTANCode],
							   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The HTML did not contain any live data. This could be due to a problems with the YourNextBus service, or an invalid NaPTAN code was specified.", nil),
							   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Try again, making sure the NaPTAN code is valid; an 8 digit number starting with 450 for West Yorkshire or 370 for South Yorkshire.", nil),
							   };
	return [NSError errorWithDomain:LJSYourNextBusErrorDomain
										 code:LJSYourNextBusErrorScrapeFailure
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
	
	if (self.saveDataToDisk) {
		[self saveToDisk:html stop:stop];
	}
	
}

- (void)safeCallCompletionBlockWithStop:(LJSStop *)stop messages:(NSArray *)messages error:(NSError *)error {
    if (self.completion) {
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			/**
			 *  Only nil out the completion block if it is the same block
			 *  as the one that was set before it was called.
			 *  If the completion block calls liveDataAtURL:completion:
			 *  the another completion block will be set before we have 
			 *  change to nil it out. If we nil out the completion block
			 *  in this case then the second liveDataAtURL:completion: call
			 *  will not get a completion block call back.
			 */
			LJSLiveDataCompletion thisCompletion = self.completion;
			self.completion(stop, messages, error);
			if (self.completion == thisCompletion) {
				self.completion = nil;
			}
		}];
    }
}
@end
