//
//  LJSServiceTests.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 02/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LJSService.h"
#import "LJSDeparture.h"
#import "LJSServiceBuilder.h"
#import "LJSDepartureBuilder.h"

@interface LJSServiceTests : XCTestCase
@property (nonatomic, strong) LJSServiceBuilder *serviceBuilder;
@property (nonatomic, strong) LJSService *serviceA;
@property (nonatomic, strong) LJSService *serviceB;
@end

@implementation LJSServiceTests

- (void)setUp {
	[super setUp];
	
	self.serviceBuilder = [LJSServiceBuilder new];
}

- (void)testEquality {
	self.serviceBuilder.title = @"service-123";
	self.serviceA = [self.serviceBuilder buildForWithStop:nil];
	self.serviceB = [self.serviceBuilder buildForWithStop:nil];

	
	XCTAssertEqualObjects(self.serviceA, self.serviceB, @"");
}

- (void)testInequalityForTitle {
	self.serviceBuilder.title = @"service-123";
	self.serviceA = [self.serviceBuilder buildForWithStop:nil];
	self.serviceBuilder.title = @"service-456";
	self.serviceB = [self.serviceBuilder buildForWithStop:nil];
	
	XCTAssertNotEqualObjects(self.serviceA, self.serviceB, @"");
}

- (void)testInequalityForDepartures {
	NSDate *departureDateA = [NSDate dateWithTimeIntervalSince1970:100000];
	NSDate *departureDateB = [NSDate dateWithTimeIntervalSince1970:100001];
	NSDate *departureDateC = [NSDate dateWithTimeIntervalSince1970:100002];
	
	LJSDepartureBuilder *departureBuilderA = [LJSDepartureBuilder new];
	departureBuilderA.expectedDepartureDate = departureDateA;
	departureBuilderA.destination = @"Sheffield";
	departureBuilderA.hasLowFloorAccess = YES;

	LJSDepartureBuilder *departureBuilderB = [LJSDepartureBuilder new];
	departureBuilderB.expectedDepartureDate = departureDateB;
	departureBuilderB.destination = @"Rotherham";
	departureBuilderB.hasLowFloorAccess = NO;

	LJSDepartureBuilder *departureBuilderC = [LJSDepartureBuilder new];
	departureBuilderC.expectedDepartureDate = departureDateC;
	departureBuilderC.destination = @"Barnsley";
	departureBuilderC.hasLowFloorAccess = YES;

	LJSServiceBuilder *serviceBuilderA = [LJSServiceBuilder new];
	serviceBuilderA.title = @"service-123";
	serviceBuilderA.departureBuilders = @[departureBuilderA, departureBuilderB];
	
	LJSServiceBuilder *serviceBuilderB = [LJSServiceBuilder new];
	serviceBuilderB.title = @"service-123";
	serviceBuilderB.departureBuilders = @[departureBuilderA, departureBuilderC];
	
	self.serviceA = [serviceBuilderA buildForWithStop:nil];
	self.serviceB = [serviceBuilderB buildForWithStop:nil];
	
	XCTAssertNotEqualObjects(self.serviceA, self.serviceB, @"");
}

- (void)testCopies {
	LJSDepartureBuilder *departureBuilder = [LJSDepartureBuilder new];
	departureBuilder.expectedDepartureDate = [NSDate date];
	departureBuilder.destination = @"Sheffield";
	departureBuilder.hasLowFloorAccess = YES;
	
	self.serviceBuilder.title = @"service-123";
	self.serviceBuilder.departureBuilders = @[departureBuilder];
	self.serviceA = [self.serviceBuilder buildForWithStop:nil];

    LJSService *copiedService = [self.serviceA copy];
	
	XCTAssertEqualObjects(copiedService.title, self.serviceA.title, @"");
	XCTAssertEqualObjects(copiedService.stop, self.serviceA.stop, @"");
	XCTAssertEqualObjects(copiedService.departures, self.serviceA.departures, @"");
}

- (void)testJSONRepresentation {
	NSDate *departureDateA = [NSDate dateWithTimeIntervalSince1970:100000];
	NSDate *departureDateB = [NSDate dateWithTimeIntervalSince1970:100001];
	NSDate *departureDateC = [NSDate dateWithTimeIntervalSince1970:100002];
	
	LJSDepartureBuilder *departureBuilderA = [LJSDepartureBuilder new];
	departureBuilderA.expectedDepartureDate = departureDateA;
	departureBuilderA.destination = @"Sheffield";
	departureBuilderA.hasLowFloorAccess = YES;
	departureBuilderA.countdownString = @"11:12";
	departureBuilderA.minutesUntilDeparture = 1;
	
	LJSDepartureBuilder *departureBuilderB = [LJSDepartureBuilder new];
	departureBuilderB.expectedDepartureDate = departureDateB;
	departureBuilderB.destination = @"Rotherham";
	departureBuilderB.hasLowFloorAccess = NO;
	departureBuilderB.countdownString = @"12:12";
	departureBuilderB.minutesUntilDeparture = 2;
	
	LJSDepartureBuilder *departureBuilderC = [LJSDepartureBuilder new];
	departureBuilderC.expectedDepartureDate = departureDateC;
	departureBuilderC.destination = @"Barnsley";
	departureBuilderC.hasLowFloorAccess = YES;
	departureBuilderC.countdownString = @"13:12";
	departureBuilderC.minutesUntilDeparture = 3;
	
	self.serviceBuilder.title = @"service-123";
	self.serviceBuilder.departureBuilders = @[departureBuilderA, departureBuilderB, departureBuilderC];
	
	self.serviceA = [self.serviceBuilder buildForWithStop:nil];
	LJSDeparture *departureA = self.serviceA.departures[0];
	LJSDeparture *departureB = self.serviceA.departures[1];
	LJSDeparture *departureC = self.serviceA.departures[2];
	
	NSDictionary *correctJSON = @{
								  @"title" : @"service-123",
								  @"departures" : @[
										  [departureA JSONRepresentation],
										  [departureB JSONRepresentation],
										  [departureC JSONRepresentation]
										  ]
								  };
	
	XCTAssertEqualObjects([self.serviceA JSONRepresentation], correctJSON, @"");
}

@end
