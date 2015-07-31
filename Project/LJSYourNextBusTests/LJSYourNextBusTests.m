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

#import "LJSSouthYorkshireClient.h"
#import "LJSScraper.h"
#import "LJSHTMLDownloader.h"
#import "LJSDepartureDateParser.h"

#import "LJSMockHTMLDownloader.h"
#import "LJSDelayedMockHTMLDownloader.h"

#import "LJSStop.h"
#import "LJSService.h"
#import "LJSDeparture.h"
#import "LJSLiveDataResult.h"

@interface LJSYourNextBusClient (TestVisibility)
@property (nonatomic, strong) LJSHTMLDownloader *htmlDownloader;
@property (nonatomic, strong) LJSScraper *scraper;
@end

@interface LJSScraper (TestVisibility)
- (NSDate *)liveDateFromString:(NSString *)liveTimeString;
- (NSDate *)currentDate;
@end

@interface LJSYourNextBusTests : XCTestCase <LJSYourNextBusClientDelegate, LJSYourNextBusScrapeDelegate>
@property (nonatomic, strong) LJSSouthYorkshireClient *yourNextBusClient;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSString *NaPTANCode;
@property (nonatomic, strong) NSString *stubbedHTML;

@property (nonatomic, assign) BOOL delegateCalledForWillScrape;
@property (nonatomic, assign) BOOL delegateCalledForReturnedStop;
@property (nonatomic, assign) BOOL delegateCalledForError;
@property (nonatomic, strong) LJSStop *returnedStop;
@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSString *returnedHTML;
@property (nonatomic, strong) NSString *returnedNaPTANCode;
@end


@implementation LJSYourNextBusTests

#pragma mark - LJSYourNextBusClientDelegate

- (void)client:(LJSYourNextBusClient *)client willScrapeHTML:(NSString *)HTML NaPTANCode:(NSString *)NaPTANCode {
	self.returnedHTML = HTML;
	self.returnedNaPTANCode = NaPTANCode;
	self.delegateCalledForWillScrape = YES;
}

- (void)client:(LJSYourNextBusClient *)client failedWithError:(NSError *)error NaPTANCode:(NSString *)NaPTANCode {
	self.error = error;
	self.delegateCalledForError = YES;
}

#pragma mark - LJSYourNextBusScrapeDelegate
- (void)client:(LJSYourNextBusClient *)client returnedLiveDataResult:(LJSLiveDataResult *)result {
	self.returnedStop = result.stop;
	self.messages = result.messages;
	self.delegateCalledForReturnedStop = YES;
}

#pragma mark - setUp / tearDown

- (void)setUp {
    [super setUp];
	self.calendar = [NSCalendar currentCalendar];
	
	self.yourNextBusClient = [[LJSSouthYorkshireClient alloc] init];
	self.yourNextBusClient.clientDelegate = self;
	self.yourNextBusClient.scrapeDelegate = self;
	self.stubbedHTML = [self loadHTMLFileNamed:@"37010071"];
	self.yourNextBusClient.htmlDownloader = [[LJSMockHTMLDownloader alloc] initWithHTML:self.stubbedHTML ID:@"37010071"];
	
	self.NaPTANCode = @"37010071";
	
	self.returnedStop = nil;
	self.messages = nil;
	self.error = nil;
	self.delegateCalledForWillScrape = NO;
	self.delegateCalledForReturnedStop = NO;
	self.delegateCalledForError = NO;
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

- (void)testScrapeFailure1 {
    NSString *invalidHTML = [self loadHTMLFileNamed:@"invalid_1"];
	self.yourNextBusClient.htmlDownloader = [[LJSMockHTMLDownloader alloc] initWithHTML:invalidHTML ID:@"invalid"];
	[self.yourNextBusClient getLiveDataForNaPTANCode:self.NaPTANCode];
	
	AGWW_WAIT_WHILE(!self.delegateCalledForError, 0.5);
	
	assertThat(self.returnedStop, equalTo(nil));
	assertThat(self.error.domain, equalTo(LJSYourNextBusErrorDomain));
	assertThatInteger(self.error.code, equalToInteger(LJSYourNextBusErrorScrapeFailure));
	assertThat(self.error.userInfo[NSLocalizedDescriptionKey], equalTo(@"Scraping the YourNextBus HTML failed for the NaPTANCode 37010071."));
	assertThat(self.error.userInfo[NSLocalizedFailureReasonErrorKey], equalTo(@"The HTML did not contain any live data. This could be due to a problems with the YourNextBus service, or an invalid NaPTAN code was specified."));
	assertThat(self.error.userInfo[NSLocalizedRecoverySuggestionErrorKey], equalTo(@"Try again, making sure the NaPTAN code is valid; an 8 digit number starting with 450 for West Yorkshire or 370 for South Yorkshire."));

}

- (void)testScrapeFailure2 {
    NSString *invalidHTML = [self loadHTMLFileNamed:@"invalid_2"];
	self.yourNextBusClient.htmlDownloader = [[LJSMockHTMLDownloader alloc] initWithHTML:invalidHTML ID:@"invalid"];
	[self.yourNextBusClient getLiveDataForNaPTANCode:self.NaPTANCode];
	
	AGWW_WAIT_WHILE(!self.delegateCalledForError, 0.5);
	
	assertThat(self.returnedStop, equalTo(nil));
	assertThat(self.error.domain, equalTo(LJSYourNextBusErrorDomain));
	assertThatInteger(self.error.code, equalToInteger(LJSYourNextBusErrorScrapeFailure));
	assertThat(self.error.userInfo[NSLocalizedDescriptionKey], equalTo(@"Scraping the YourNextBus HTML failed for the NaPTANCode 37010071."));
	assertThat(self.error.userInfo[NSLocalizedFailureReasonErrorKey], equalTo(@"The HTML did not contain any live data. This could be due to a problems with the YourNextBus service, or an invalid NaPTAN code was specified."));
	assertThat(self.error.userInfo[NSLocalizedRecoverySuggestionErrorKey], equalTo(@"Try again, making sure the NaPTAN code is valid; an 8 digit number starting with 450 for West Yorkshire or 370 for South Yorkshire."));
	
}

- (void)testScrapeFailureWithStopSuggestionsHTML {
    NSString *invalidHTML = [self loadHTMLFileNamed:@"555"];
	self.yourNextBusClient.htmlDownloader = [[LJSMockHTMLDownloader alloc] initWithHTML:invalidHTML ID:@"555"];
	[self.yourNextBusClient getLiveDataForNaPTANCode:@"555"];
	
	AGWW_WAIT_WHILE(!self.delegateCalledForError, 0.5);
	
	assertThat(self.returnedStop, equalTo(nil));
	assertThat(self.error.domain, equalTo(LJSYourNextBusErrorDomain));
	assertThatInteger(self.error.code, equalToInteger(LJSYourNextBusErrorScrapeFailure));
	assertThat(self.error.userInfo[NSLocalizedDescriptionKey], equalTo(@"Scraping the YourNextBus HTML failed for the NaPTANCode 555."));
	assertThat(self.error.userInfo[NSLocalizedFailureReasonErrorKey], equalTo(@"The HTML did not contain any live data. This could be due to a problems with the YourNextBus service, or an invalid NaPTAN code was specified."));
	assertThat(self.error.userInfo[NSLocalizedRecoverySuggestionErrorKey], equalTo(@"Try again, making sure the NaPTAN code is valid; an 8 digit number starting with 450 for West Yorkshire or 370 for South Yorkshire."));

}

- (void)testNoDataAvaiable {
    NSString *invalidHTML = [self loadHTMLFileNamed:@"no_depatures"];
	self.yourNextBusClient.htmlDownloader = [[LJSMockHTMLDownloader alloc] initWithHTML:invalidHTML ID:@"no_depatures"];
	[self.yourNextBusClient getLiveDataForNaPTANCode:self.NaPTANCode];
	
	AGWW_WAIT_WHILE(!self.delegateCalledForReturnedStop, 0.5);
	
	assertThat(self.error, equalTo(nil));
	assertThat(self.returnedStop.services, equalTo(nil));
}

#pragma mark - Messages

- (void)testMessages {
    NSString *invalidHTML = [self loadHTMLFileNamed:@"messages"];
	self.yourNextBusClient.htmlDownloader = [[LJSMockHTMLDownloader alloc] initWithHTML:invalidHTML ID:@"messages"];
	[self.yourNextBusClient getLiveDataForNaPTANCode:self.NaPTANCode];
	
	AGWW_WAIT_WHILE(!self.delegateCalledForReturnedStop, 0.5);
	
	
	assertThat(self.messages, hasCountOf(3));
	assertThat(self.messages[0], equalTo(@"Message 1"));
	assertThat(self.messages[1], equalTo(@"Message 2"));
	assertThat(self.messages[2], equalTo(@"Message 3"));
}

- (void)testNoMessages {
	[self.yourNextBusClient getLiveDataForNaPTANCode:self.NaPTANCode];
	
	AGWW_WAIT_WHILE(!self.delegateCalledForReturnedStop, 0.5);
	
	assertThat(self.messages, equalTo(nil));
}

#pragma mark - Started scraping HTML delegate

- (void)testCallsDelegateWhenScrapingHasStarted {
	[self.yourNextBusClient getLiveDataForNaPTANCode:self.NaPTANCode];
	
	AGWW_WAIT_WHILE(!self.delegateCalledForWillScrape, 0.5);
	
	assertThat(self.returnedHTML, equalTo(self.stubbedHTML));
	assertThat(self.returnedNaPTANCode, equalTo(self.NaPTANCode));
}

#pragma mark - LJSStop

- (void)testStopDetails {
    [self.yourNextBusClient getLiveDataForNaPTANCode:self.NaPTANCode];
	
	AGWW_WAIT_WHILE(!self.delegateCalledForReturnedStop, 0.5);
	
	assertThat(self.returnedStop.NaPTANCode, equalTo(@"37010071"));
	assertThat(self.returnedStop.title, equalTo(@"Rotherham Intc"));
}

- (void)testStopLiveDate {
	// Stub the current date to 24.03.2014 09:00:00
	NSDate *currentDateTime = [NSDate dateWithTimeIntervalSince1970:1395651600];
	self.yourNextBusClient.scraper = [self stubCurrentDate:currentDateTime ofScraper:self.yourNextBusClient.scraper];
	
	[self.yourNextBusClient getLiveDataForNaPTANCode:self.NaPTANCode];
	
	AGWW_WAIT_WHILE(!self.delegateCalledForReturnedStop, 0.5);
	
	NSDate *correctLiveDate = [self augmentDate:currentDateTime hours:10 minutes:46];
	assertThatInteger([self.returnedStop.liveDate timeIntervalSince1970], equalToInteger([correctLiveDate timeIntervalSince1970]));
}

- (void)testServicesCount {
	[self.yourNextBusClient getLiveDataForNaPTANCode:self.NaPTANCode];
	
	AGWW_WAIT_WHILE(!self.delegateCalledForReturnedStop, 0.5);
	
	NSArray *services = self.returnedStop.services;
	assertThat(services, hasCountOf(4));
}

#pragma mark - LJSService

- (void)testServicesDetails {
	[self.yourNextBusClient getLiveDataForNaPTANCode:self.NaPTANCode];
	
	AGWW_WAIT_WHILE(!self.delegateCalledForReturnedStop, 0.5);
	
	NSArray *services = [self sortedServicesForStop:self.returnedStop];
	
	LJSService *firstService = services[0];
	assertThat(firstService.title, equalTo(@"217"));
	assertThat(firstService.departures, hasCountOf(2));
	assertThat(firstService.stop, equalTo(self.returnedStop));
	
	LJSService *secondService = services[1];
	assertThat(secondService.title, equalTo(@"218"));
	assertThat(secondService.departures, hasCountOf(3));
	assertThat(secondService.stop, equalTo(self.returnedStop));
	
	LJSService *thirdService = services[2];
	assertThat(thirdService.title, equalTo(@"22"));
	assertThat(thirdService.departures, hasCountOf(7));
	assertThat(thirdService.stop, equalTo(self.returnedStop));
	
	LJSService *fourthService = services[3];
	assertThat(fourthService.title, equalTo(@"22X"));
	assertThat(fourthService.departures, hasCountOf(4));
	assertThat(fourthService.stop, equalTo(self.returnedStop));
}

- (void)testDeparturesCount {
	[self.yourNextBusClient getLiveDataForNaPTANCode:self.NaPTANCode];
	
	AGWW_WAIT_WHILE(!self.delegateCalledForReturnedStop, 0.5);
	
	NSArray *allDepartures = [self.returnedStop sortedDepartures];
	assertThat(allDepartures, hasCountOf(16));
	
}

#pragma mark - LJSDeparture

- (void)testDepartureDetails {
	// Stub the current date to 24.03.2014 09:00:00
	NSDate *currentDateTime = [NSDate dateWithTimeIntervalSince1970:1395651600];
	self.yourNextBusClient.scraper = [self stubCurrentDate:currentDateTime ofScraper:self.yourNextBusClient.scraper];
	
	[self.yourNextBusClient getLiveDataForNaPTANCode:self.NaPTANCode];
	
	AGWW_WAIT_WHILE(!self.delegateCalledForReturnedStop, 0.5);
	
	NSArray *services = [self sortedServicesForStop:self.returnedStop];
	
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
					  equalToInteger([[self date:self.returnedStop.liveDate plusMinutes:40] timeIntervalSince1970]));
	assertThatBool(secondDepartureOfSecondService.hasLowFloorAccess, equalToBool(YES));
	
	
	/**
	 *  218 	Barnsley 	70 mins 	LF
	 */
	LJSDeparture *thirdDepartureOfSecondService = secondServiceDepartures[2];
	assertThat(thirdDepartureOfSecondService.destination, equalTo(@"Barnsley"));
	assertThat(thirdDepartureOfSecondService.service, equalTo(secondService));
	assertThatInteger([thirdDepartureOfSecondService.expectedDepartureDate timeIntervalSince1970],
					  equalToInteger([[self date:self.returnedStop.liveDate plusMinutes:70] timeIntervalSince1970]));
	assertThatBool(thirdDepartureOfSecondService.hasLowFloorAccess, equalToBool(YES));
}

- (void)testDepartureCountdown {
	// Stub the live date to 24.03.2014 10:56:00
	NSDate *liveDate = [NSDate dateWithTimeIntervalSince1970:1395658560];
	self.yourNextBusClient.scraper = [self stubLiveDate:liveDate ofScraper:self.yourNextBusClient.scraper];
	
	[self.yourNextBusClient getLiveDataForNaPTANCode:self.NaPTANCode];
	
	AGWW_WAIT_WHILE(!self.delegateCalledForReturnedStop, 0.5);
	
	NSArray *services = [self sortedServicesForStop:self.returnedStop];
	
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
	assertThat(secondDepartureOfFirstService.countdownString, equalTo(@"11:41 AM"));
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
	assertThat(secondDepartureOfSecondService.countdownString, equalTo(@"11:36 AM"));
	assertThatInteger(secondDepartureOfSecondService.minutesUntilDeparture, equalToInteger(40));
	
	
	/**
	 *  218 	Barnsley 	70 mins 	LF
	 */
	LJSDeparture *thirdDepartureOfSecondService = secondServiceDepartures[2];
	assertThat(thirdDepartureOfSecondService.countdownString, equalTo(@"12:06 PM"));
	assertThatInteger(thirdDepartureOfSecondService.minutesUntilDeparture, equalToInteger(70));
}

#pragma mark - Later URL

- (void)testLaterURL {
    [self.yourNextBusClient getLiveDataForNaPTANCode:self.NaPTANCode];
	
	AGWW_WAIT_WHILE(!self.delegateCalledForReturnedStop, 0.5);
	
	assertThat(self.returnedStop.laterURL.absoluteString, equalTo(@"/pip/stop.asp?naptan=37010071&pscode=218&dest=&offset=1&textonly=1"));
}

- (void)testEarlierURL {
	NSString *HTML = [self loadHTMLFileNamed:@"37010115"];
	self.yourNextBusClient.htmlDownloader = [[LJSMockHTMLDownloader alloc] initWithHTML:HTML ID:@"37010115"];
	
    [self.yourNextBusClient getLiveDataForNaPTANCode:self.NaPTANCode];
	
	AGWW_WAIT_WHILE(!self.delegateCalledForReturnedStop, 0.5);
	
	assertThat(self.returnedStop.earlierURL.absoluteString, equalTo(@"/pip/stop.asp?naptan=37010115&pscode=120&dest=&offset=0&textonly=1"));
}

- (void)testNilEarlierURL {
    [self.yourNextBusClient getLiveDataForNaPTANCode:self.NaPTANCode];
	
	AGWW_WAIT_WHILE(!self.delegateCalledForReturnedStop, 0.5);
	
	assertThat(self.returnedStop.earlierURL, equalTo(nil));
}

#pragma mark - Multple Requests

- (void)testPreventsASecondRequestWhenFirstHasNotFiinshed
{
	NSString *HTML = [self loadHTMLFileNamed:@"37010115"];
	self.yourNextBusClient.htmlDownloader = [[LJSDelayedMockHTMLDownloader alloc] initWithHTML:HTML ID:@"37010115" delay:5.0];
	
	XCTAssertTrue([self.yourNextBusClient getLiveDataForNaPTANCode:self.NaPTANCode]);
	XCTAssertTrue(self.yourNextBusClient.isGettingLiveData);
	XCTAssertFalse([self.yourNextBusClient getLiveDataForNaPTANCode:self.NaPTANCode]);
}

- (void)testAllowsASecondRequestOnceTheFirstHasFiinshed
{
	NSString *HTML = [self loadHTMLFileNamed:@"37010115"];
	self.yourNextBusClient.htmlDownloader = [[LJSDelayedMockHTMLDownloader alloc] initWithHTML:HTML ID:@"37010115" delay:0.5];
	
	XCTAssertTrue([self.yourNextBusClient getLiveDataForNaPTANCode:self.NaPTANCode]);
	AGWW_WAIT_WHILE(!self.delegateCalledForReturnedStop, 1.0);
	XCTAssertFalse(self.yourNextBusClient.isGettingLiveData);
	
	XCTAssertTrue([self.yourNextBusClient getLiveDataForNaPTANCode:self.NaPTANCode]);
	XCTAssertTrue(self.yourNextBusClient.isGettingLiveData);
}

@end
