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
#import "LJSStop.h"
#import "LJSLiveDataResult.h"

NSString * const LJSYourNextBusErrorDomain = @"com.yournextbus.domain";

@interface LJSYourNextBusClient ()
@property (nonatomic, copy) NSString *NaPTANCode;
@property (nonatomic, strong) LJSScraper *scraper;
@property (nonatomic, strong) LJSHTMLDownloader *htmlDownloader;
@property (nonatomic, strong) NSOperationQueue *backgroundQueue;
@property (nonatomic, assign, readwrite, getter=isGettingLiveData) BOOL gettingLiveData;
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

- (BOOL)getLiveDataForNaPTANCode:(NSString *)NaPTANCode {
	// Prevent multiple requests
	if (self.backgroundQueue.operations.count > 0) {
		return NO;
	}
	
	self.gettingLiveData = YES;
	
	[self.backgroundQueue addOperationWithBlock:^{
		self.NaPTANCode = NaPTANCode;
		NSURL *url = [self urlForNaPTANCode:NaPTANCode];
		[self attemptScrapeWithURL:url];
	}];
	
	return YES;
}


- (void)attemptScrapeWithURL:(NSURL *)url {
    
    NSError *error = nil;
    NSString *html = [self.htmlDownloader downloadHTMLFromURL:url error:&error];
    
    if (!html) {
		[self handleFinishWithStop:nil error:error];
    }
	else if (![self.scraper htmlIsValid:html]) {
		[self handleFinishWithStop:nil error:[self invalidHTMLError]];
	}
	else {
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			if ([self.scrapeDelegate respondsToSelector:@selector(client:willScrapeHTML:NaPTANCode:)]) {
				[self.scrapeDelegate client:self willScrapeHTML:html NaPTANCode:self.NaPTANCode];
			}
		}];
		
		[self scrapeHTML:html];
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
        return [NSURL URLWithString:[NSString stringWithFormat:
                                     @"http://gettheresooner.travelsouthyorkshire.com/MobileNaptan.aspx?t=departure&sa=%@&dc&ac=99&vc&x=0&y=0&Mode=Mobile", stopNumber]];
    }
    return nil;
}

- (void)scrapeHTML:(NSString *)html {
    LJSStop *stop = [self.scraper scrapeStopDataFromHTML:html];
	[self handleFinishWithStop:stop error:nil];
}

- (void)handleFinishWithStop:(LJSStop *)stop error:(NSError *)error {
	LJSLiveDataResult *result = [[LJSLiveDataResult alloc] initWithNaPTANCode:self.NaPTANCode stop:stop messages:nil];
	
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		self.gettingLiveData = NO;
		
		if (error && [self.clientDelegate respondsToSelector:@selector(client:failedWithError:NaPTANCode:)]) {
			[self.clientDelegate client:self failedWithError:error NaPTANCode:self.NaPTANCode];
		}
		else if ([self.clientDelegate respondsToSelector:@selector(client:returnedLiveDataResult:)]) {
			[self.clientDelegate client:self returnedLiveDataResult:result];
		}
		
	}];
}
@end
