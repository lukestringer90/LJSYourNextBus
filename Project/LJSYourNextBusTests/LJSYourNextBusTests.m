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

#import "LJSYourNextBusClient.h"
#import "LJSScraper.h"
#import "LJSHTMLDownloader.h"

#import "LJSStop.h"
#import "LJSService.h"
#import "LJSDeparture.h"

@interface LJSYourNextBusClient (TestVisibility)
@property (nonatomic, strong) LJSHTMLDownloader *htmlDownloader;
@end

@interface LJSYourNextBusTests : XCTestCase
@property (nonatomic, strong) LJSYourNextBusClient *yourNextBusClient;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSString *NaPTANCode;
@end


@implementation LJSYourNextBusTests

#pragma mark - setUp / tearDown

- (void)setUp {
    [super setUp];
	self.calendar = [NSCalendar currentCalendar];
	
	self.yourNextBusClient = [[LJSYourNextBusClient alloc] init];
	NSString *html = [self loadHTMLFileNamed:@"37010071"];
	self.yourNextBusClient.htmlDownloader = [self mockHTMLDownloadReturningHTML:html];
	
	// Irrelevant what this is as static HTML is loaded anyway
	self.NaPTANCode = @"37010071";
}

#pragma mark - Helpers

- (NSString *)loadHTMLFileNamed:(NSString *)fileName {
    NSString *path = [self pathInTestBundleForResource:fileName ofType:@"html"];
    return [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
}

- (NSString *)pathInTestBundleForResource:(NSString *)name ofType:(NSString *)extension {
    return [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:extension];
}

- (id)mockHTMLDownloadReturningHTML:(NSString *)htmlString {
    id htmlDownloaderMock = [OCMockObject niceMockForClass:[LJSHTMLDownloader class]];
    [[[htmlDownloaderMock stub] andReturn:htmlString] downloadHTMLFromURL:[OCMArg any] error:[OCMArg setTo:nil]];
    return htmlDownloaderMock;
}

- (NSArray *)sortedServicesForStop:(LJSStop *)stop {
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
	return [stop.services sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (NSArray *)DeparturesForStop:(LJSStop *)stop {
	return [[stop.services valueForKeyPath:@"Departures"] valueForKeyPath:@"@unionOfArrays.self"];
}

- (NSArray *)sortedDeparturesForService:(LJSService *)service {
	NSArray *sortDescriptors = @[
								 [NSSortDescriptor sortDescriptorWithKey:@"destination"
															   ascending:YES],
								 [NSSortDescriptor sortDescriptorWithKey:@"expectedDepartureDate"
															   ascending:YES]];
	return [service.Departures sortedArrayUsingDescriptors:sortDescriptors];
}

- (NSDate *)todayAtHours:(NSInteger)hours minutes:(NSInteger)minutes {
	NSDate *today = [NSDate date];
	NSDateComponents *dateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
														fromDate:today];
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

#pragma mark - Invalid

- (void)testInvalidHTML {
    NSString *invalidHTML = [self loadHTMLFileNamed:@"invalid"];
	self.yourNextBusClient.htmlDownloader = [self mockHTMLDownloadReturningHTML:invalidHTML];
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSURL *laterURL, NSURL *earlierURL, NSError *error) {
		assertThat(stop, equalTo(nil));
		assertThat(laterURL, equalTo(nil));
		assertThat(earlierURL, equalTo(nil));
		assertThat(error.domain, equalTo(LJSYourNextBusErrorDomain));
		assertThatInteger(error.code, equalToInteger(LJSYourNextBusErrorScrapeFailure));
		assertThat(error.userInfo[NSLocalizedDescriptionKey], equalTo(@"Scraping the YourNextBus HTML failed."));
		assertThat(error.userInfo[NSLocalizedFailureReasonErrorKey], equalTo(@"The HTML did not contain any live data. This could be due to a problems with the YourNextBus service, or an invalid NaPTAN code was supplied."));
		assertThat(error.userInfo[NSLocalizedRecoverySuggestionErrorKey], equalTo(@"Try again, making sure the NaPTAN code is valid; an 8 digit  number starting with 450 for West Yorkshire or 370 for South Yorkshire."));
	}];
	
	
}

#pragma mark - LJSStop

- (void)testStopDetails {
    [self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode
									   completion:^(LJSStop *stop, NSURL *laterURL, NSURL *earlierURL, NSError *error) {
										   assertThat(stop.NaPTANCode, equalTo(@"37010071"));
										   assertThat(stop.title, equalTo(@"Rotherham Intc"));
									   }];
	
}

- (void)testStopLiveDate {
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode
									   completion:^(LJSStop *stop, NSURL *laterURL, NSURL *earlierURL, NSError *error) {
										   NSDate *correctLiveDate = [self todayAtHours:10 minutes:46];
										   assertThatInteger([stop.liveDate timeIntervalSince1970], equalToInteger([correctLiveDate timeIntervalSince1970]));
									   }];
}

- (void)testServicesCount {
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode
									   completion:^(LJSStop *stop, NSURL *laterURL, NSURL *earlierURL, NSError *error) {
										   NSArray *services = stop.services;
										   assertThat(services, hasCountOf(4));
									   }];
}

#pragma mark - LJSService

- (void)testServicesDetails {
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode
									   completion:^(LJSStop *stop, NSURL *laterURL, NSURL *earlierURL, NSError *error) {
										   NSArray *services = [self sortedServicesForStop:stop];
										   
										   LJSService *firstService = services[0];
										   assertThat(firstService.title, equalTo(@"217"));
										   assertThat(firstService.Departures, hasCountOf(2));
										   assertThat(firstService.stop, equalTo(stop));
										   
										   LJSService *secondService = services[1];
										   assertThat(secondService.title, equalTo(@"218"));
										   assertThat(secondService.Departures, hasCountOf(3));
										   assertThat(secondService.stop, equalTo(stop));
										   
										   LJSService *thirdService = services[2];
										   assertThat(thirdService.title, equalTo(@"22"));
										   assertThat(thirdService.Departures, hasCountOf(7));
										   assertThat(thirdService.stop, equalTo(stop));
										   
										   LJSService *fourthService = services[3];
										   assertThat(fourthService.title, equalTo(@"22X"));
										   assertThat(fourthService.Departures, hasCountOf(4));
										   assertThat(fourthService.stop, equalTo(stop));
									   }];
}

- (void)testDeparturesCount {
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode
									   completion:^(LJSStop *stop, NSURL *laterURL, NSURL *earlierURL, NSError *error) {
										   NSArray *allDepartures = [self DeparturesForStop:stop];
										   assertThat(allDepartures, hasCountOf(16));
									   }];
	
}

#pragma mark - LJSDeparture

- (void)testDepartureDetails {
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode
									   completion:^(LJSStop *stop, NSURL *laterURL, NSURL *earlierURL, NSError *error) {
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
										   assertThatInteger([firstDepartureOfFirstService.expectedDepartureDate timeIntervalSince1970],
															 equalToInteger([[self todayAtHours:11 minutes:11] timeIntervalSince1970]));
										   assertThatBool(firstDepartureOfFirstService.hasLowFloorAccess, equalToBool(NO));
										   
										   
										   /**
											*  217 	Thurnscoe 	11:41
											*/
										   LJSDeparture *secondDepartureOfFirstService = firstServiceDepartures[1];
										   assertThat(secondDepartureOfFirstService.service, equalTo(firstService));
										   assertThat(secondDepartureOfFirstService.destination, equalTo(@"Thurnscoe"));
										   assertThatInteger([secondDepartureOfFirstService.expectedDepartureDate timeIntervalSince1970],
															 equalToInteger([[self todayAtHours:11 minutes:41] timeIntervalSince1970]));
										   assertThatBool(secondDepartureOfFirstService.hasLowFloorAccess, equalToBool(NO));
										   
										   
										   /**
											*  218 	Barnsley 	10:56
											*/
										   LJSDeparture *firstDepartureOfSecondService = secondServiceDepartures[0];
										   assertThat(firstDepartureOfSecondService.destination, equalTo(@"Barnsley"));
										   assertThat(firstDepartureOfSecondService.service, equalTo(secondService));
										   assertThatInteger([firstDepartureOfSecondService.expectedDepartureDate timeIntervalSince1970],
															 equalToInteger([[self todayAtHours:10 minutes:56] timeIntervalSince1970]));
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
}

#pragma mark - Later URL

- (void)testLaterURL {
    [self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode
									   completion:^(LJSStop *stop, NSURL *laterURL, NSURL *earlierURL, NSError *error) {
										   assertThat(laterURL.absoluteString, equalTo(@"/pip/stop.asp?naptan=37010071&pscode=218&dest=&offset=1&textonly=1"));
									   }];
}

- (void)testEarlierURL {
	NSString *html = [self loadHTMLFileNamed:@"37010115"];
	self.yourNextBusClient.htmlDownloader = [self mockHTMLDownloadReturningHTML:html];
	
    [self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode
									   completion:^(LJSStop *stop, NSURL *laterURL, NSURL *earlierURL, NSError *error) {
										   assertThat(earlierURL.absoluteString, equalTo(@"/pip/stop.asp?naptan=37010115&pscode=120&dest=&offset=0&textonly=1"));
									   }];
}

- (void)testNilEarlierURL {
    [self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode
									   completion:^(LJSStop *stop, NSURL *laterURL, NSURL *earlierURL, NSError *error) {
										   assertThat(earlierURL, equalTo(nil));
									   }];
}

@end
