//
//  LJSLiveDepaturesTests.m
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
#import "LJSDepature.h"

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

- (NSArray *)depaturesForStop:(LJSStop *)stop {
	return [[stop.services valueForKeyPath:@"depatures"] valueForKeyPath:@"@unionOfArrays.self"];
}

- (NSArray *)sortedDepaturesForService:(LJSService *)service {
	NSArray *sortDescriptors = @[
								 [NSSortDescriptor sortDescriptorWithKey:@"destination"
															   ascending:YES],
								 [NSSortDescriptor sortDescriptorWithKey:@"expectedDepatureDate"
															   ascending:YES]];
	return [service.depatures sortedArrayUsingDescriptors:sortDescriptors];
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

#pragma mark - LJSStop

- (void)testStopDetails {
    [self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSURL *laterURL, NSURL *earlierURL, NSError *error) {
		assertThat(stop.NaPTANCode, equalTo(@"37010071"));
		assertThat(stop.title, equalTo(@"Rotherham Intc"));
	}];
	
}

- (void)testStopLiveDate {
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSURL *laterURL, NSURL *earlierURL, NSError *error) {
		NSDate *correctLiveDate = [self todayAtHours:10 minutes:46];
		assertThatInteger([stop.liveDate timeIntervalSince1970], equalToInteger([correctLiveDate timeIntervalSince1970]));
	}];
}

- (void)testServicesCount {
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSURL *laterURL, NSURL *earlierURL, NSError *error) {
		NSArray *services = stop.services;
		assertThat(services, hasCountOf(4));
	}];
}

#pragma mark - LJSService

- (void)testServicesDetails {
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSURL *laterURL, NSURL *earlierURL, NSError *error) {
		NSArray *services = [self sortedServicesForStop:stop];
		
		LJSService *firstService = services[0];
		assertThat(firstService.title, equalTo(@"217"));
		assertThat(firstService.depatures, hasCountOf(2));
		assertThat(firstService.stop, equalTo(stop));
		
		LJSService *secondService = services[1];
		assertThat(secondService.title, equalTo(@"218"));
		assertThat(secondService.depatures, hasCountOf(3));
		assertThat(secondService.stop, equalTo(stop));
		
		LJSService *thirdService = services[2];
		assertThat(thirdService.title, equalTo(@"22"));
		assertThat(thirdService.depatures, hasCountOf(7));
		assertThat(thirdService.stop, equalTo(stop));
		
		LJSService *fourthService = services[3];
		assertThat(fourthService.title, equalTo(@"22X"));
		assertThat(fourthService.depatures, hasCountOf(4));
		assertThat(fourthService.stop, equalTo(stop));
	}];
}

- (void)testDepaturesCount {
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSURL *laterURL, NSURL *earlierURL, NSError *error) {
		NSArray *allDepatures = [self depaturesForStop:stop];
		assertThat(allDepatures, hasCountOf(16));
	}];
	
}

#pragma mark - LJSDepature

- (void)testDepatureDetails {
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSURL *laterURL, NSURL *earlierURL, NSError *error) {
		NSArray *services = [self sortedServicesForStop:stop];
		
		LJSService *firstService = services[0];
		LJSService *secondService = services[1];
		NSArray *firstServiceDepatures = [self sortedDepaturesForService:firstService];
		NSArray *secondServiceDepatures = [self sortedDepaturesForService:secondService];
		
		/**
		 *  217 	Mexborough 	11:11
		 */
		LJSDepature *firstDepatureOfFirstService = firstServiceDepatures[0];
		assertThat(firstDepatureOfFirstService.destination, equalTo(@"Mexborough"));
		assertThat(firstDepatureOfFirstService.service, equalTo(firstService));
		assertThatInteger([firstDepatureOfFirstService.expectedDepatureDate timeIntervalSince1970],
						  equalToInteger([[self todayAtHours:11 minutes:11] timeIntervalSince1970]));
		assertThatBool(firstDepatureOfFirstService.hasLowFloorAccess, equalToBool(NO));
		
		
		/**
		 *  217 	Thurnscoe 	11:41
		 */
		LJSDepature *secondDepatureOfFirstService = firstServiceDepatures[1];
		assertThat(secondDepatureOfFirstService.service, equalTo(firstService));
		assertThat(secondDepatureOfFirstService.destination, equalTo(@"Thurnscoe"));
		assertThatInteger([secondDepatureOfFirstService.expectedDepatureDate timeIntervalSince1970],
						  equalToInteger([[self todayAtHours:11 minutes:41] timeIntervalSince1970]));
		assertThatBool(secondDepatureOfFirstService.hasLowFloorAccess, equalToBool(NO));
		
		
		/**
		 *  218 	Barnsley 	10:56
		 */
		LJSDepature *firstDepatureOfSecondService = secondServiceDepatures[0];
		assertThat(firstDepatureOfSecondService.destination, equalTo(@"Barnsley"));
		assertThat(firstDepatureOfSecondService.service, equalTo(secondService));
		assertThatInteger([firstDepatureOfSecondService.expectedDepatureDate timeIntervalSince1970],
						  equalToInteger([[self todayAtHours:10 minutes:56] timeIntervalSince1970]));
		assertThatBool(firstDepatureOfSecondService.hasLowFloorAccess, equalToBool(NO));
		
		
		/**
		 *  218 	Barnsley 	40 mins 	LF
		 */
		LJSDepature *secondDepatureOfSecondService = secondServiceDepatures[1];
		assertThat(secondDepatureOfSecondService.destination, equalTo(@"Barnsley"));
		assertThat(secondDepatureOfSecondService.service, equalTo(secondService));
		assertThatInteger([secondDepatureOfSecondService.expectedDepatureDate timeIntervalSince1970],
						  equalToInteger([[self date:stop.liveDate plusMinutes:40] timeIntervalSince1970]));
		assertThatBool(secondDepatureOfSecondService.hasLowFloorAccess, equalToBool(YES));
		
		
		/**
		 *  218 	Barnsley 	70 mins 	LF
		 */
		LJSDepature *thirdDepatureOfSecondService = secondServiceDepatures[2];
		assertThat(thirdDepatureOfSecondService.destination, equalTo(@"Barnsley"));
		assertThat(thirdDepatureOfSecondService.service, equalTo(secondService));
		assertThatInteger([thirdDepatureOfSecondService.expectedDepatureDate timeIntervalSince1970],
						  equalToInteger([[self date:stop.liveDate plusMinutes:70] timeIntervalSince1970]));
		assertThatBool(thirdDepatureOfSecondService.hasLowFloorAccess, equalToBool(YES));
	}];
}

@end
