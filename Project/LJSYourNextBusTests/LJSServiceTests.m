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
	NSDate *DepartureDateA = [NSDate dateWithTimeIntervalSince1970:100000];
	NSDate *DepartureDateB = [NSDate dateWithTimeIntervalSince1970:100001];
	NSDate *DepartureDateC = [NSDate dateWithTimeIntervalSince1970:100002];
	
	LJSDeparture *DepartureA = [LJSDeparture new];
	DepartureA.expectedDepartureDate = DepartureDateA;
	DepartureA.destination = @"Sheffield";
	DepartureA.hasLowFloorAccess = YES;
	
	LJSDeparture *DepartureB = [LJSDeparture new];
	DepartureB.expectedDepartureDate = DepartureDateB;
	DepartureB.destination = @"Rotherham";
	DepartureB.hasLowFloorAccess = NO;
	
	LJSDeparture *DepartureC = [LJSDeparture new];
	DepartureC.expectedDepartureDate = DepartureDateC;
	DepartureC.destination = @"Barnsley";
	DepartureC.hasLowFloorAccess = YES;
	
	self.serviceA.title = @"service-123";
	self.serviceA.Departures = @[DepartureA, DepartureB];
	self.serviceB.title = @"service-123";
	self.serviceB.Departures = @[DepartureA, DepartureC];
	
	XCTAssertNotEqualObjects(self.serviceA, self.serviceB, @"");
}

- (void)testCopies {
	LJSDeparture *Departure = [LJSDeparture new];
	Departure.expectedDepartureDate = [NSDate date];
	Departure.destination = @"Sheffield";
	Departure.hasLowFloorAccess = YES;
	
	self.serviceA.title = @"service-123";
	self.serviceA.Departures = @[Departure];

    LJSService *copiedService = [self.serviceA copy];
	XCTAssertEqualObjects(copiedService, self.serviceA, @"");
	
	// TODO: Test equality for all properties
	
}

@end
