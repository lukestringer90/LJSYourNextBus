//
//  LJSServiceTests.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 02/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LJSService.h"
#import "LJSService+LJSSetters.h"
#import "LJSStop.h"
#import "LJSStop+LJSSetters.h"
#import "LJSDeparture.h"
#import "LJSDeparture+LJSSetters.h"

@interface LJSServiceTests : XCTestCase
@property (nonatomic, strong) LJSService *serviceA;
@property (nonatomic, strong) LJSService *serviceB;
@end

@implementation LJSServiceTests

- (void)setUp {
	[super setUp];
	self.serviceA = [LJSService new];
	self.serviceB = [LJSService new];
}

- (void)testEquality {
	self.serviceA.title = @"service-123";
	self.serviceB.title = @"service-123";
	
	XCTAssertEqualObjects(self.serviceA, self.serviceB, @"");
}

- (void)testInequalityForTitle {
	self.serviceA.title = @"service-123";
	self.serviceB.title = @"service-456";
	
	XCTAssertNotEqualObjects(self.serviceA, self.serviceB, @"");
}

- (void)testInequalityForStop {
	LJSStop *stopA = [LJSStop new];
	stopA.NaPTANCode = @"stop-123";
	LJSStop *stopB = [LJSStop new];
	stopB.NaPTANCode = @"stop-456";
	
	self.serviceA.title = @"service-123";
	self.serviceA.stop = stopA;
	self.serviceB.title = @"service-123";
	self.serviceB.stop = stopB;
	
	XCTAssertNotEqualObjects(self.serviceA, self.serviceB, @"");
}

- (void)testInequalityForDepartures {
	NSDate *departureDateA = [NSDate dateWithTimeIntervalSince1970:100000];
	NSDate *departureDateB = [NSDate dateWithTimeIntervalSince1970:100001];
	NSDate *departureDateC = [NSDate dateWithTimeIntervalSince1970:100002];
	
	LJSDeparture *departureA = [LJSDeparture new];
	departureA.expectedDepartureDate = departureDateA;
	departureA.destination = @"Sheffield";
	departureA.hasLowFloorAccess = YES;
	
	LJSDeparture *departureB = [LJSDeparture new];
	departureB.expectedDepartureDate = departureDateB;
	departureB.destination = @"Rotherham";
	departureB.hasLowFloorAccess = NO;
	
	LJSDeparture *departureC = [LJSDeparture new];
	departureC.expectedDepartureDate = departureDateC;
	departureC.destination = @"Barnsley";
	departureC.hasLowFloorAccess = YES;
	
	self.serviceA.title = @"service-123";
	self.serviceA.departures = @[departureA, departureB];
	self.serviceB.title = @"service-123";
	self.serviceB.departures = @[departureA, departureC];
	
	XCTAssertNotEqualObjects(self.serviceA, self.serviceB, @"");
}

- (void)testCopies {
	LJSDeparture *departure = [LJSDeparture new];
	departure.expectedDepartureDate = [NSDate date];
	departure.destination = @"Sheffield";
	departure.hasLowFloorAccess = YES;
	
	self.serviceA.title = @"service-123";
	self.serviceA.departures = @[departure];

    LJSService *copiedService = [self.serviceA copy];
	
	XCTAssertEqualObjects(copiedService.title, self.serviceA.title, @"");
	XCTAssertEqualObjects(copiedService.stop, self.serviceA.stop, @"");
	XCTAssertEqualObjects(copiedService.departures, self.serviceA.departures, @"");
}

@end
