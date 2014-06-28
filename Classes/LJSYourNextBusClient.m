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

- (void)getLiveDataForNaPTANCode:(NSString *)NaPTANCode {
	[self.backgroundQueue addOperationWithBlock:^{
		self.NaPTANCode = NaPTANCode;
		NSURL *url = [self urlForNaPTANCode:NaPTANCode];
		[self liveDataAtURL:url];
	}];
}


- (void)liveDataAtURL:(NSURL *)url {
    
    NSError *error = nil;
    NSString *html = [self.htmlDownloader downloadHTMLFromURL:url error:&error];
    
    if (error) {
		[self handleFinishWithStop:nil messages:nil error:error];
    }
	else if (![self.scraper htmlIsValid:html]) {
		[self handleFinishWithStop:nil messages:nil error:[self invalidHTMLError]];
	}
	else {
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			if ([self.delegate respondsToSelector:@selector(client:willScrapeHTML:NaPTANCode:)]) {
				[self.delegate client:self willScrapeHTML:html NaPTANCode:self.NaPTANCode];
			}
		}];
		
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
        return [NSURL URLWithString:[NSString stringWithFormat:@"http://tsy.acislive.com/web/stop_reference.asp?areacode=&naptan=%@&textonly=1", stopNumber]];
    }
    return nil;
}

- (void)scrapeHTML:(NSString *)html messages:(NSArray *)messages{
    LJSStop *stop = [self.scraper scrapeStopDataFromHTML:html];
	[self handleFinishWithStop:stop messages:messages error:nil];
	
	if (self.saveDataToDisk) {
		[self saveToDisk:html stop:stop];
	}
}

- (void)handleFinishWithStop:(LJSStop *)stop messages:(NSArray *)messages error:(NSError *)error {
	
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		
		if (error && [self.delegate respondsToSelector:@selector(client:failedWithError:)]) {
			[self.delegate client:self failedWithError:error];
		}
		else if ([self.delegate respondsToSelector:@selector(client:returnedStop:messages:)]) {
			[self.delegate client:self returnedStop:stop messages:messages];
		}
		
	}];
}
@end
