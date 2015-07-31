//
//  LJSStopTests.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 03/02/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LJSStop.h"
#import "LJSService.h"
#import "LJSStopBuilder.h"
#import "LJSServiceBuilder.h"
#import "LJSDepartureBuilder.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

@interface LJSStopTests : XCTestCase
@property (nonatomic, strong) LJSStopBuilder *stopBuilder;
@property (nonatomic, strong) LJSDepartureBuilder *departureBuilder;
@property (nonatomic, strong) LJSServiceBuilder *serviceBuilder;
@property (nonatomic, strong) LJSStop *stopA;
@property (nonatomic, strong) LJSStop *stopB;
@end

@implementation LJSStopTests

- (void)setUp {
    [super setUp];
	self.stopBuilder = [LJSStopBuilder new];
	self.serviceBuilder = [LJSServiceBuilder new];
	self.departureBuilder = [LJSDepartureBuilder new];
}

- (void)testEquality {
	self.stopBuilder.NaPTANCode = @"123";
	self.stopA = [self.stopBuilder build];
	self.stopB = [self.stopBuilder build];
    
    assertThat(self.stopA, equalTo(self.stopB));
}

- (void)testInequalityForTitles {
	self.stopBuilder.NaPTANCode = @"123";
	self.stopA = [self.stopBuilder build];
	self.stopBuilder.NaPTANCode = @"456";
	self.stopB = [self.stopBuilder build];
    
    assertThat(self.stopA, isNot(equalTo(self.stopB)));
}

- (void)testInequalityForServices {
	LJSServiceBuilder *serviceBuilderA = [LJSServiceBuilder new];
	LJSServiceBuilder *serviceBuilderB = [LJSServiceBuilder new];
	LJSServiceBuilder *serviceBuilderC = [LJSServiceBuilder new];
	
	serviceBuilderA.title = @"service-123";
	serviceBuilderB.title = @"service-456";
	serviceBuilderC.title = @"service-789";
	
	self.stopBuilder.NaPTANCode = @"123";
	self.stopBuilder.serviceBuilders = @[serviceBuilderA, serviceBuilderB];
	self.stopA = [self.stopBuilder build];
	
	self.stopBuilder.serviceBuilders = @[serviceBuilderA, serviceBuilderC];
	self.stopB = [self.stopBuilder build];
	
	assertThat(self.stopA, isNot(equalTo(self.stopB)));
}

- (void)testCopies {
	LJSServiceBuilder *serviceBuilderA = [LJSServiceBuilder new];
	serviceBuilderA.title = @"service-123";
	
	self.stopBuilder.NaPTANCode = @"123";
	self.stopBuilder.serviceBuilders = @[serviceBuilderA];
	self.stopBuilder.liveDate = [NSDate date];
	self.stopBuilder.laterURL = [NSURL URLWithString:@"www.foo.com"];
	self.stopBuilder.earlierURL = [NSURL URLWithString:@"www.bar.com"];
	
	self.stopA = [self.stopBuilder build];
    LJSStop *copy = [self.stopA copy];
	
	assertThat(copy.title, equalTo(self.stopA.title));
	assertThat(copy.NaPTANCode, equalTo(self.stopA.NaPTANCode));
	assertThat(copy.liveDate, equalTo(self.stopA.liveDate));
	assertThat(copy.services, equalTo(self.stopA.services));
	assertThat(copy.laterURL, equalTo(self.stopA.laterURL));
	assertThat(copy.earlierURL, equalTo(self.stopA.earlierURL));
}

- (void)testJSONRepresentation {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateStyle = NSDateFormatterShortStyle;
	dateFormatter.timeStyle = NSDateFormatterShortStyle;
	
	LJSDepartureBuilder *departureA = [LJSDepartureBuilder new];
	departureA.expectedDepartureDate = [NSDate date];
	departureA.destination = @"Sheffield";
	departureA.hasLowFloorAccess = YES;
	departureA.countdownString = @"11:12";
	departureA.minutesUntilDeparture = 1;
	
	LJSDepartureBuilder *departureB = [LJSDepartureBuilder new];
	departureB.expectedDepartureDate = [NSDate date];
	departureB.destination = @"Rotherham";
	departureB.hasLowFloorAccess = NO;
	departureB.countdownString = @"12:12";
	departureB.minutesUntilDeparture = 2;

	LJSServiceBuilder *serviceBuilderA = [LJSServiceBuilder new];
	serviceBuilderA.title = @"service-123";
	serviceBuilderA.departureBuilders = @[departureA, departureB];
	
	NSDate *liveDate = [NSDate date];
	self.stopBuilder.NaPTANCode = @"123";
	self.stopBuilder.serviceBuilders = @[serviceBuilderA];
	self.stopBuilder.liveDate = liveDate;
	self.stopBuilder.laterURL = [NSURL URLWithString:@"www.foo.com"];
	self.stopBuilder.earlierURL = [NSURL URLWithString:@"www.bar.com"];
	
	self.stopA = [self.stopBuilder build];
	LJSService *serviceA = self.stopA.services[0];
	
	NSDictionary *correctJSON = @{
								  @"NaPTANCode" : @"123",
								  @"liveDate" : [dateFormatter stringFromDate:liveDate],
								  @"laterURL" : @"www.foo.com",
								  @"earlierURL" : @"www.bar.com",
								  @"services" : @[
										  [serviceA JSONRepresentation]
										  ]
								  };
	
	assertThat([self.stopA JSONRepresentation], equalTo(correctJSON));
}

- (void)testDepartures {
    LJSDepartureBuilder *departureBuilderA = [LJSDepartureBuilder new];
	departureBuilderA.expectedDepartureDate = [NSDate date];
	departureBuilderA.destination = @"Sheffield";
	departureBuilderA.hasLowFloorAccess = YES;
	departureBuilderA.countdownString = @"11:12";
	departureBuilderA.minutesUntilDeparture = 1;
	
	LJSDepartureBuilder *departureBuilderB = [LJSDepartureBuilder new];
	departureBuilderB.expectedDepartureDate = [NSDate date];
	departureBuilderB.destination = @"Rotherham";
	departureBuilderB.hasLowFloorAccess = NO;
	departureBuilderB.countdownString = @"12:12";
	departureBuilderB.minutesUntilDeparture = 2;
	
	LJSDepartureBuilder *departureBuilderC = [LJSDepartureBuilder new];
	departureBuilderC.expectedDepartureDate = [NSDate date];
	departureBuilderC.destination = @"Leeds";
	departureBuilderC.hasLowFloorAccess = NO;
	departureBuilderC.countdownString = @"13:12";
	departureBuilderC.minutesUntilDeparture = 3;
	
	LJSServiceBuilder *serviceBuilderA = [LJSServiceBuilder new];
	serviceBuilderA.title = @"serviceA";
	serviceBuilderA.departureBuilders = @[departureBuilderA, departureBuilderB];
	
	LJSServiceBuilder *serviceBuilderB = [LJSServiceBuilder new];
	serviceBuilderB.title = @"serviceB";
	serviceBuilderB.departureBuilders = @[departureBuilderC];
	
	NSDate *liveDate = [NSDate date];
	self.stopBuilder.NaPTANCode = @"123";
	self.stopBuilder.serviceBuilders = @[serviceBuilderA, serviceBuilderB];
	self.stopBuilder.liveDate = liveDate;
	self.stopBuilder.laterURL = [NSURL URLWithString:@"www.foo.com"];
	self.stopBuilder.earlierURL = [NSURL URLWithString:@"www.bar.com"];
	
	self.stopA = [self.stopBuilder build];
	LJSService *serviceA = self.stopA.services[0];
	LJSService *serviceB = self.stopA.services[1];
	LJSDeparture *departureA = serviceA.departures[0];
	LJSDeparture *departureB = serviceA.departures[1];
	LJSDeparture *departureC = serviceB.departures[0];
	
	NSArray *allDepartures = [self.stopA sortedDepartures];
	assertThat(allDepartures, hasCountOf(3));
	assertThat(allDepartures[0], equalTo(departureA));
	assertThat(allDepartures[1], equalTo(departureB));
	assertThat(allDepartures[2], equalTo(departureC));
}


@end
