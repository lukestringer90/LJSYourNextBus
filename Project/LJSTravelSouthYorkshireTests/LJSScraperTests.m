//
//  LJSScraperTests.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 02/02/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "LJSScraper.h"
#import "LJSStop.h"
#import "LJSService.h"
#import "LJSDepature.h"

@interface LJSScraperTests : XCTestCase {
    LJSScraper *_sut;
    NSString *_html;
}
@end

@implementation LJSScraperTests

#pragma mark - setUp / tearDown

- (void)setUp {
    [super setUp];
    _sut = [[LJSScraper alloc] init];
    _html = [self loadHTMLFileNamed:@"37010071"];
}

#pragma mark - Helpers

- (NSDictionary *)loadJSONFileNamed:(NSString *)fileName {
    NSString *path = [self pathInTestBundleForResource:fileName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (NSString *)loadHTMLFileNamed:(NSString *)fileName {
    NSString *path = [self pathInTestBundleForResource:fileName ofType:@"html"];
    return [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
}

- (NSString *)pathInTestBundleForResource:(NSString *)name ofType:(NSString *)extension {
    return [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:extension];
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

#pragma mark - Tests

- (void)testStopDetails {
    LJSStop *stop = [_sut scrapeStopDataFromHTML:_html];
	
	assertThat(stop.NaPTANCode, equalTo(@"37010071"));
	assertThat(stop.title, equalTo(@"Rotherham Intc"));
}

- (void)testStopLiveDate {
	LJSStop *stop = [_sut scrapeStopDataFromHTML:_html];
	
	NSDate *today = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
														fromDate:today];
	dateComponents.hour = 10;
	dateComponents.minute = 46;
	dateComponents.second = 0;
	NSDate *liveDate = [calendar dateFromComponents:dateComponents];
	
	assertThatInteger([stop.liveDate timeIntervalSince1970], equalToInteger([liveDate timeIntervalSince1970]));
}

- (void)testServicesCount {
    LJSStop *stop = [_sut scrapeStopDataFromHTML:_html];
    NSArray *services = stop.services;
	
	assertThat(services, hasCountOf(4));
}

- (void)testServicesDetails {
	LJSStop *stop = [_sut scrapeStopDataFromHTML:_html];
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
}

- (void)testDepaturesCount {
	LJSStop *stop = [_sut scrapeStopDataFromHTML:_html];
	NSArray *allDepatures = [self depaturesForStop:stop];
	
	assertThat(allDepatures, hasCountOf(16));
}

- (void)testDepatureDetails {
    LJSStop *stop = [_sut scrapeStopDataFromHTML:_html];
    NSArray *services = [stop.services sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
	
	LJSService *firstService = services[0];
	NSArray *firstServiceDepatures = [self sortedDepaturesForService:firstService];
	
	LJSDepature *firstDepatureOfFirstService = firstServiceDepatures[0];
	assertThat(firstDepatureOfFirstService.destination, equalTo(@"Mexborough"));
	assertThat(firstDepatureOfFirstService.service, equalTo(firstService));
	// test depature date
	// test has low floor access
	
	LJSDepature *secondDepatureOfFirstService = firstServiceDepatures[1];
	assertThat(secondDepatureOfFirstService.service, equalTo(firstService));
	assertThat(secondDepatureOfFirstService.destination, equalTo(@"Thurnscoe"));
	// test depature date
	// test has low floor access
	
	
	LJSService *secondService = services[1];
	NSArray *secondServiceDepatures = [self sortedDepaturesForService:secondService];
	
	LJSDepature *firstDepatureOfSecondService = secondServiceDepatures[0];
	assertThat(firstDepatureOfSecondService.destination, equalTo(@"Barnsley"));
	assertThat(firstDepatureOfSecondService.service, equalTo(secondService));
	// test depature date
	// test has low floor access
	
	LJSDepature *secondDepatureOfSecondService = secondServiceDepatures[1];
	assertThat(secondDepatureOfSecondService.destination, equalTo(@"Barnsley"));
	assertThat(secondDepatureOfSecondService.service, equalTo(secondService));
	// test depature date
	// test has low floor access
	
	LJSDepature *thirdDepatureOfSecondService = secondServiceDepatures[2];
	assertThat(thirdDepatureOfSecondService.destination, equalTo(@"Barnsley"));
	assertThat(thirdDepatureOfSecondService.service, equalTo(secondService));
	// test depature date
	// test has low floor access
	
}



@end
