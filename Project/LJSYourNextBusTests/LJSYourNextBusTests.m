//
//  LJSLiveDeparturesTests.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 02/02/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import <AGAsyncTestHelper/AGAsyncTestHelper.h>

#import "LJSYourNextBusClient.h"
#import "LJSScraper.h"
#import "LJSHTMLDownloader.h"
#import "LJSDepartureDateParser.h"

#import "LJSMockHTMLDownloader.h"

#import "LJSStop.h"
#import "LJSService.h"
#import "LJSDeparture.h"

@interface LJSYourNextBusClient (TestVisibility)
@property (nonatomic, strong) LJSHTMLDownloader *htmlDownloader;
@property (nonatomic, strong) LJSScraper *scraper;
@end

@interface LJSScraper (TestVisibility)
- (NSDate *)liveDateFromString:(NSString *)liveTimeString;
- (NSDate *)currentDate;
@end

@interface LJSYourNextBusTests : XCTestCase
@property (nonatomic, strong) LJSYourNextBusClient *yourNextBusClient;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSString *NaPTANCode;
@property (nonatomic, assign) BOOL done;
@end


@implementation LJSYourNextBusTests

#pragma mark - setUp / tearDown

- (void)setUp {
    [super setUp];
	self.calendar = [NSCalendar currentCalendar];
	
	self.yourNextBusClient = [[LJSYourNextBusClient alloc] init];
	NSString *HTML = [self loadHTMLFileNamed:@"37010071"];
	self.yourNextBusClient.htmlDownloader = [[LJSMockHTMLDownloader alloc] initWithHTML:HTML ID:@"37010071"];
	
	self.NaPTANCode = @"37010071";
	
	self.done = NO;
}

#pragma mark - Helpers

- (NSString *)loadHTMLFileNamed:(NSString *)fileName {
    NSString *path = [self pathInTestBundleForResource:fileName ofType:@"html"];
    return [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
}

- (NSString *)pathInTestBundleForResource:(NSString *)name ofType:(NSString *)extension {
    return [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:extension];
}

- (id)stubLiveDate:(NSDate *)liveDate ofScraper:(LJSScraper *)scraper {
	id scraperMock = [OCMockObject partialMockForObject:scraper];
	[[[scraperMock stub] andReturn:liveDate] liveDateFromString:[OCMArg any]];
	return scraperMock;
}

- (id)stubCurrentDate:(NSDate *)liveDate ofScraper:(LJSScraper *)scraper {
	id scraperMock = [OCMockObject partialMockForObject:scraper];
	[[[scraperMock stub] andReturn:liveDate] currentDate];
	return scraperMock;
}

- (NSArray *)sortedServicesForStop:(LJSStop *)stop {
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
	return [stop.services sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (NSArray *)sortedDeparturesForService:(LJSService *)service {
	NSArray *sortDescriptors = @[
								 [NSSortDescriptor sortDescriptorWithKey:@"expectedDepartureDate"
															   ascending:YES],
								 [NSSortDescriptor sortDescriptorWithKey:@"destination"
															   ascending:YES]];
	return [service.departures sortedArrayUsingDescriptors:sortDescriptors];
}


- (NSDate *)augmentDate:(NSDate *)date hours:(NSInteger)hours minutes:(NSInteger)minutes {
	NSDateComponents *dateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
														fromDate:date];
	dateComponents.hour = hours;
	dateComponents.minute = minutes;
	dateComponents.second = 0;
	return [self.calendar dateFromComponents:dateComponents];
}

- (NSDate *)date:(NSDate *)baseDate plusMinutes:(NSInteger)minutes {
	NSDateComponents *minutesComponent = [[NSDateComponents alloc] init];
	minutesComponent.minute = minutes;
	
	return [self.calendar dateByAddingComponents:minutesComponent
										  toDate:baseDate
										 options:0];;
}

#pragma mark - Tests

#pragma mark - Errors

- (void)testScrapeFailure {
    NSString *invalidHTML = [self loadHTMLFileNamed:@"invalid"];
	self.yourNextBusClient.htmlDownloader = [[LJSMockHTMLDownloader alloc] initWithHTML:invalidHTML ID:@"invalid"];
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSArray *messages, NSError *error) {
		self.done = YES;
		
		assertThat(stop, equalTo(nil));
		assertThat(error.domain, equalTo(LJSYourNextBusErrorDomain));
		assertThatInteger(error.code, equalToInteger(LJSYourNextBusErrorScrapeFailure));
		assertThat(error.userInfo[NSLocalizedDescriptionKey], equalTo(@"Scraping the YourNextBus HTML failed for the NaPTANCode 37010071."));
		assertThat(error.userInfo[NSLocalizedFailureReasonErrorKey], equalTo(@"The HTML did not contain any live data. This could be due to a problems with the YourNextBus service, or an invalid NaPTAN code was specified."));
		assertThat(error.userInfo[NSLocalizedRecoverySuggestionErrorKey], equalTo(@"Try again, making sure the NaPTAN code is valid; an 8 digit number starting with 450 for West Yorkshire or 370 for South Yorkshire."));
	}];
	
	AGWW_WAIT_WHILE(!self.done, 0.5);
}

- (void)testScrapeFailureWithStopSuggestionsHTML {
    NSString *invalidHTML = [self loadHTMLFileNamed:@"555"];
	self.yourNextBusClient.htmlDownloader = [[LJSMockHTMLDownloader alloc] initWithHTML:invalidHTML ID:@"555"];
	[self.yourNextBusClient liveDataForNaPTANCode:@"555" completion:^(LJSStop *stop, NSArray *messages, NSError *error) {
		self.done = YES;
		
		assertThat(stop, equalTo(nil));
		assertThat(error.domain, equalTo(LJSYourNextBusErrorDomain));
		assertThatInteger(error.code, equalToInteger(LJSYourNextBusErrorScrapeFailure));
		assertThat(error.userInfo[NSLocalizedDescriptionKey], equalTo(@"Scraping the YourNextBus HTML failed for the NaPTANCode 555."));
		assertThat(error.userInfo[NSLocalizedFailureReasonErrorKey], equalTo(@"The HTML did not contain any live data. This could be due to a problems with the YourNextBus service, or an invalid NaPTAN code was specified."));
		assertThat(error.userInfo[NSLocalizedRecoverySuggestionErrorKey], equalTo(@"Try again, making sure the NaPTAN code is valid; an 8 digit number starting with 450 for West Yorkshire or 370 for South Yorkshire."));
	}];
	
	AGWW_WAIT_WHILE(!self.done, 0.5);
}

- (void)testNoDataAvaiable {
    NSString *invalidHTML = [self loadHTMLFileNamed:@"no_depatures"];
	self.yourNextBusClient.htmlDownloader = [[LJSMockHTMLDownloader alloc] initWithHTML:invalidHTML ID:@"no_depatures"];
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSArray *messages, NSError *error) {
		self.done = YES;
		
		assertThat(error, equalTo(nil));
		assertThat(stop.services, equalTo(nil));
	}];
	
	AGWW_WAIT_WHILE(!self.done, 0.5);
}

#pragma mark - Messages

- (void)testMessages {
    NSString *invalidHTML = [self loadHTMLFileNamed:@"messages"];
	self.yourNextBusClient.htmlDownloader = [[LJSMockHTMLDownloader alloc] initWithHTML:invalidHTML ID:@"messages"];
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSArray *messages, NSError *error) {
		self.done = YES;
		
		assertThat(messages, hasCountOf(3));
		assertThat(messages[0], equalTo(@"Message 1"));
		assertThat(messages[1], equalTo(@"Message 2"));
		assertThat(messages[2], equalTo(@"Message 3"));
	}];
	
	AGWW_WAIT_WHILE(!self.done, 0.5);
}

- (void)testNoMessages {
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSArray *messages, NSError *error) {
		self.done = YES;
		
		assertThat(messages, equalTo(nil));
	}];
	
	AGWW_WAIT_WHILE(!self.done, 0.5);
}

#pragma mark - LJSStop

- (void)testStopDetails {
    [self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSArray *messages, NSError *error) {
		self.done = YES;
		
		assertThat(stop.NaPTANCode, equalTo(@"37010071"));
		assertThat(stop.title, equalTo(@"Rotherham Intc"));
	}];
	
	AGWW_WAIT_WHILE(!self.done, 0.5);
}

- (void)testStopLiveDate {
	// Stub the current date to 24.03.2014 09:00:00
	NSDate *currentDateTime = [NSDate dateWithTimeIntervalSince1970:1395651600];
	self.yourNextBusClient.scraper = [self stubCurrentDate:currentDateTime ofScraper:self.yourNextBusClient.scraper];
	
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSArray *messages, NSError *error) {
		self.done = YES;
		
		NSDate *correctLiveDate = [self augmentDate:currentDateTime hours:10 minutes:46];
		assertThatInteger([stop.liveDate timeIntervalSince1970], equalToInteger([correctLiveDate timeIntervalSince1970]));
	}];
	
	AGWW_WAIT_WHILE(!self.done, 0.5);
}

- (void)testServicesCount {
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSArray *messages, NSError *error) {
		self.done = YES;
		
		NSArray *services = stop.services;
		assertThat(services, hasCountOf(4));
	}];
	
	AGWW_WAIT_WHILE(!self.done, 0.5);
}

#pragma mark - LJSService

- (void)testServicesDetails {
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSArray *messages, NSError *error) {
		self.done = YES;
		
		NSArray *services = [self sortedServicesForStop:stop];
		
		LJSService *firstService = services[0];
		assertThat(firstService.title, equalTo(@"217"));
		assertThat(firstService.departures, hasCountOf(2));
		assertThat(firstService.stop, equalTo(stop));
		
		LJSService *secondService = services[1];
		assertThat(secondService.title, equalTo(@"218"));
		assertThat(secondService.departures, hasCountOf(3));
		assertThat(secondService.stop, equalTo(stop));
		
		LJSService *thirdService = services[2];
		assertThat(thirdService.title, equalTo(@"22"));
		assertThat(thirdService.departures, hasCountOf(7));
		assertThat(thirdService.stop, equalTo(stop));
		
		LJSService *fourthService = services[3];
		assertThat(fourthService.title, equalTo(@"22X"));
		assertThat(fourthService.departures, hasCountOf(4));
		assertThat(fourthService.stop, equalTo(stop));
	}];
	
	AGWW_WAIT_WHILE(!self.done, 0.5);
}

- (void)testDeparturesCount {
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSArray *messages, NSError *error) {
		self.done = YES;
		
		NSArray *allDepartures = [stop sortedDepartures];
		assertThat(allDepartures, hasCountOf(16));
	}];
	
}

#pragma mark - LJSDeparture

- (void)testDepartureDetails {
	// Stub the current date to 24.03.2014 09:00:00
	NSDate *currentDateTime = [NSDate dateWithTimeIntervalSince1970:1395651600];
	self.yourNextBusClient.scraper = [self stubCurrentDate:currentDateTime ofScraper:self.yourNextBusClient.scraper];
	
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSArray *messages, NSError *error) {
		self.done = YES;
		
		NSArray *services = [self sortedServicesForStop:stop];
		
		LJSService *firstService = services[0];
		LJSService *secondService = services[1];
		NSArray *firstServiceDepartures = [self sortedDeparturesForService:firstService];
		NSArray *secondServiceDepartures = [self sortedDeparturesForService:secondService];
		
		/**
		 *  217 	Mexborough 	11:11
		 */
		LJSDeparture *firstDepartureOfFirstService = firstServiceDepartures[0];
		assertThat(firstDepartureOfFirstService.destination, equalTo(@"Mexborough"));
		assertThat(firstDepartureOfFirstService.service, equalTo(firstService));
		// TODO: Stub a date rather than using today.
		// If tests run at 23:59:59 it might fail
		assertThatInteger([firstDepartureOfFirstService.expectedDepartureDate timeIntervalSince1970],
						  equalToInteger([[self augmentDate:currentDateTime hours:11 minutes:11] timeIntervalSince1970]));
		assertThatBool(firstDepartureOfFirstService.hasLowFloorAccess, equalToBool(NO));
		
		
		/**
		 *  217 	Thurnscoe 	11:41
		 */
		LJSDeparture *secondDepartureOfFirstService = firstServiceDepartures[1];
		assertThat(secondDepartureOfFirstService.service, equalTo(firstService));
		assertThat(secondDepartureOfFirstService.destination, equalTo(@"Thurnscoe"));
		// TODO: Stub a date rather than using today.
		// If tests run at 23:59:59 it might fail
		assertThatInteger([secondDepartureOfFirstService.expectedDepartureDate timeIntervalSince1970],
						  equalToInteger([[self augmentDate:currentDateTime hours:11 minutes:41] timeIntervalSince1970]));
		assertThatBool(secondDepartureOfFirstService.hasLowFloorAccess, equalToBool(NO));
		
		
		/**
		 *  218 	Barnsley 	10:56
		 */
		LJSDeparture *firstDepartureOfSecondService = secondServiceDepartures[0];
		assertThat(firstDepartureOfSecondService.destination, equalTo(@"Barnsley"));
		assertThat(firstDepartureOfSecondService.service, equalTo(secondService));
		// TODO: Stub a date rather than using today.
		// If tests run at 23:59:59 it might fail
		assertThatInteger([firstDepartureOfSecondService.expectedDepartureDate timeIntervalSince1970],
						  equalToInteger([[self augmentDate:currentDateTime hours:10 minutes:56] timeIntervalSince1970]));
		assertThatBool(firstDepartureOfSecondService.hasLowFloorAccess, equalToBool(NO));
		
		
		/**
		 *  218 	Barnsley 	40 mins 	LF
		 */
		LJSDeparture *secondDepartureOfSecondService = secondServiceDepartures[1];
		assertThat(secondDepartureOfSecondService.destination, equalTo(@"Barnsley"));
		assertThat(secondDepartureOfSecondService.service, equalTo(secondService));
		assertThatInteger([secondDepartureOfSecondService.expectedDepartureDate timeIntervalSince1970],
						  equalToInteger([[self date:stop.liveDate plusMinutes:40] timeIntervalSince1970]));
		assertThatBool(secondDepartureOfSecondService.hasLowFloorAccess, equalToBool(YES));
		
		
		/**
		 *  218 	Barnsley 	70 mins 	LF
		 */
		LJSDeparture *thirdDepartureOfSecondService = secondServiceDepartures[2];
		assertThat(thirdDepartureOfSecondService.destination, equalTo(@"Barnsley"));
		assertThat(thirdDepartureOfSecondService.service, equalTo(secondService));
		assertThatInteger([thirdDepartureOfSecondService.expectedDepartureDate timeIntervalSince1970],
						  equalToInteger([[self date:stop.liveDate plusMinutes:70] timeIntervalSince1970]));
		assertThatBool(thirdDepartureOfSecondService.hasLowFloorAccess, equalToBool(YES));
	}];
	
	AGWW_WAIT_WHILE(!self.done, 0.5);
}

- (void)testDepartureCountdown {
	// Stub the live date to 24.03.2014 10:56:00
	NSDate *liveDate = [NSDate dateWithTimeIntervalSince1970:1395658560];
	self.yourNextBusClient.scraper = [self stubLiveDate:liveDate ofScraper:self.yourNextBusClient.scraper];
	
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSArray *messages, NSError *error) {
		self.done = YES;
		
		NSArray *services = [self sortedServicesForStop:stop];
		
		LJSService *firstService = services[0];
		LJSService *secondService = services[1];
		NSArray *firstServiceDepartures = [self sortedDeparturesForService:firstService];
		NSArray *secondServiceDepartures = [self sortedDeparturesForService:secondService];
		
		/**
		 *  217 	Mexborough 	11:11
		 */
		LJSDeparture *firstDepartureOfFirstService = firstServiceDepartures[0];
		assertThat(firstDepartureOfFirstService.countdownString, equalTo(@"15 Mins"));
		assertThatInteger(firstDepartureOfFirstService.minutesUntilDeparture, equalToInteger(15));
		
		
		/**
		 *  217 	Thurnscoe 	11:41
		 */
		LJSDeparture *secondDepartureOfFirstService = firstServiceDepartures[1];
		assertThat(secondDepartureOfFirstService.countdownString, equalTo(@"45 Mins"));
		assertThatInteger(secondDepartureOfFirstService.minutesUntilDeparture, equalToInteger(45));
		
		
		/**
		 *  218 	Barnsley 	10:56
		 */
		LJSDeparture *firstDepartureOfSecondService = secondServiceDepartures[0];
		assertThat(firstDepartureOfSecondService.destination, equalTo(@"Barnsley"));
		assertThat(firstDepartureOfSecondService.countdownString, equalTo(@"Due"));
		assertThatInteger(firstDepartureOfSecondService.minutesUntilDeparture, equalToInteger(0));
		
		
		/**
		 *  218 	Barnsley 	40 mins 	LF
		 */
		LJSDeparture *secondDepartureOfSecondService = secondServiceDepartures[1];
		assertThat(secondDepartureOfSecondService.countdownString, equalTo(@"40 Mins"));
		assertThatInteger(secondDepartureOfSecondService.minutesUntilDeparture, equalToInteger(40));
		
		
		/**
		 *  218 	Barnsley 	70 mins 	LF
		 */
		LJSDeparture *thirdDepartureOfSecondService = secondServiceDepartures[2];
		assertThat(thirdDepartureOfSecondService.countdownString, equalTo(@"70 Mins"));
		assertThatInteger(thirdDepartureOfSecondService.minutesUntilDeparture, equalToInteger(70));
	}];
	
	AGWW_WAIT_WHILE(!self.done, 0.5);
}

#pragma mark - Later URL

- (void)testLaterURL {
    [self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSArray *messages, NSError *error) {
		self.done = YES;
		
		assertThat(stop.laterURL.absoluteString, equalTo(@"/pip/stop.asp?naptan=37010071&pscode=218&dest=&offset=1&textonly=1"));
	}];
	
	AGWW_WAIT_WHILE(!self.done, 0.5);
}

- (void)testEarlierURL {
	NSString *HTML = [self loadHTMLFileNamed:@"37010115"];
	self.yourNextBusClient.htmlDownloader = [[LJSMockHTMLDownloader alloc] initWithHTML:HTML ID:@"37010115"];
	
    [self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSArray *messages, NSError *error) {
		self.done = YES;
		
		assertThat(stop.earlierURL.absoluteString, equalTo(@"/pip/stop.asp?naptan=37010115&pscode=120&dest=&offset=0&textonly=1"));
	}];
	
	AGWW_WAIT_WHILE(!self.done, 0.5);
}

- (void)testNilEarlierURL {
    [self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSArray *messages, NSError *error) {
		self.done = YES;
		
		assertThat(stop.earlierURL, equalTo(nil));
	}];
	
	AGWW_WAIT_WHILE(!self.done, 0.5);
}

#pragma mark - Refreshing

- (void)testRefreshStopNoChanges {
	NSString *HTML = [self loadHTMLFileNamed:@"37010200-original"];
	self.yourNextBusClient.htmlDownloader = [[LJSMockHTMLDownloader alloc] initWithHTML:HTML ID:@"37010200-original"];
	
	// Stub the current date to 24.03.2014 09:00:00
	NSDate *currentDateTime = [NSDate dateWithTimeIntervalSince1970:1395651600];
	self.yourNextBusClient.scraper = [self stubCurrentDate:currentDateTime ofScraper:self.yourNextBusClient.scraper];
	
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *originalStop, NSArray *messages, NSError *error) {
		
		[self.yourNextBusClient refreshStop:originalStop completion:^(LJSStop *refreshedStop, NSArray *messages, NSError *error) {
			self.done = YES;
			
			assertThat(refreshedStop, notNilValue());
			
			assertThat(originalStop.title, equalTo(refreshedStop.title));
			assertThat(originalStop.services, equalTo(refreshedStop.services));
		}];
		
	}];

	
	AGWW_WAIT_WHILE(!self.done, 0.5);
}

- (void)testRefreshStopWithTimeChanges {
	
	NSString *originalHTML = [self loadHTMLFileNamed:@"37010200-original"];
	self.yourNextBusClient.htmlDownloader = [[LJSMockHTMLDownloader alloc] initWithHTML:originalHTML ID:@"37010200-original"];
	
	// Stub the current date to 24.03.2014 09:00:00
	NSDate *currentDateTime = [NSDate dateWithTimeIntervalSince1970:1395651600];
	self.yourNextBusClient.scraper = [self stubCurrentDate:currentDateTime ofScraper:self.yourNextBusClient.scraper];
	
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *originalStop, NSArray *messages, NSError *error) {
		
		assertThat(originalStop, notNilValue());
		
		NSString *refreshedHtml = [self loadHTMLFileNamed:@"37010200-time-changes"];
		self.yourNextBusClient.htmlDownloader = [[LJSMockHTMLDownloader alloc] initWithHTML:refreshedHtml ID:@"37010200-time-changes"];

		[self.yourNextBusClient refreshStop:originalStop completion:^(LJSStop *refreshedStop, NSArray *messages, NSError *error) {
			self.done = YES;
			
			assertThat(refreshedStop, notNilValue());
			
			assertThat(originalStop.liveDate, isNot(equalTo(refreshedStop.liveDate)));
			assertThat(originalStop.title, equalTo(refreshedStop.title));
			assertThat(originalStop.services, isNot(equalTo(refreshedStop.services))); // different services
			assertThat(refreshedStop.liveDate, equalTo([self augmentDate:currentDateTime hours:14 minutes:23]));
			
			NSArray *allDepartures = [refreshedStop sortedDepartures];
			assertThat(allDepartures, hasCountOf(21)); // same number of departures
			
			/**
			 *  Original:	X78		Sheffield Intc 	4 mins 	LF
			 *	Refreshed:  X78 	Sheffield Intc 	2 mins 	LF
			 */
			LJSDeparture *firstDeparture = allDepartures[0];
			assertThat(firstDeparture.service.title, equalTo(@"X78"));
			assertThat(firstDeparture.destination, equalTo(@"Sheffield Intc"));
			assertThat(firstDeparture.countdownString, equalTo(@"2 Mins"));
			assertThatInteger(firstDeparture.minutesUntilDeparture, equalToInteger(2));
			assertThatInteger([firstDeparture.expectedDepartureDate timeIntervalSince1970],
							  equalToInteger([[self date:refreshedStop.liveDate plusMinutes:2] timeIntervalSince1970]));
			
		}];
		
	}];
	
	
	AGWW_WAIT_WHILE(!self.done, 60.0);
}

- (void)testRefreshStopWithDepartureChanges {
	
	NSString *originalHTML = [self loadHTMLFileNamed:@"37010200-original"];
	self.yourNextBusClient.htmlDownloader = [[LJSMockHTMLDownloader alloc] initWithHTML:originalHTML ID:@"37010200-original"];
	
	// Stub the current date to 24.03.2014 09:00:00
	NSDate *currentDateTime = [NSDate dateWithTimeIntervalSince1970:1395651600];
	self.yourNextBusClient.scraper = [self stubCurrentDate:currentDateTime ofScraper:self.yourNextBusClient.scraper];
	
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *originalStop, NSArray *messages, NSError *error) {
		
		assertThat(originalStop, notNilValue());
		
		NSString *refreshedHtml = [self loadHTMLFileNamed:@"37010200-departure-changes"];
		self.yourNextBusClient.htmlDownloader = [[LJSMockHTMLDownloader alloc] initWithHTML:refreshedHtml ID:@"37010200-time-changes"];
		
		[self.yourNextBusClient refreshStop:originalStop completion:^(LJSStop *refreshedStop, NSArray *messages, NSError *error) {
			self.done = YES;
			
			assertThat(refreshedStop, notNilValue());
			
			assertThat(originalStop.liveDate, isNot(equalTo(refreshedStop.liveDate)));
			assertThat(originalStop.title, equalTo(refreshedStop.title));
			assertThat(originalStop.services, isNot(equalTo(refreshedStop.services))); // different services
			assertThat(refreshedStop.liveDate, equalTo([self augmentDate:currentDateTime hours:14 minutes:25]));
			
			NSArray *allDepartures = [refreshedStop sortedDepartures];
			assertThat(allDepartures, hasCountOf(18)); // different number of departures
			
			/**
			 *  Original:	X78		Sheffield Intc 	4 mins 	LF
			 *	Refreshed:  76		Low Edges 	Due 	LF
			 */
			LJSDeparture *firstDeparture = allDepartures[0];
			assertThat(firstDeparture.service.title, equalTo(@"76"));
			assertThat(firstDeparture.destination, equalTo(@"Low Edges"));
			assertThat(firstDeparture.countdownString, equalTo(@"Due"));
			assertThatInteger(firstDeparture.minutesUntilDeparture, equalToInteger(0));
			assertThatInteger([firstDeparture.expectedDepartureDate timeIntervalSince1970],
							  equalToInteger([[self date:refreshedStop.liveDate plusMinutes:0] timeIntervalSince1970]));
			
		}];
		
	}];
	
	AGWW_WAIT_WHILE(!self.done, 60.0);
}

@end
