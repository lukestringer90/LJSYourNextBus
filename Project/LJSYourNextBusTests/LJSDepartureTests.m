//
//  LJSDepartureTests.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 02/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LJSDeparture.h"
#import "LJSDeparture+LJSSetters.h"
#import "LJSService.h"
#import "LJSService+LJSSetters.h"

@interface LJSDepartureTests : XCTestCase
@property (nonatomic, strong) LJSDeparture *departureA;
@property (nonatomic, strong) LJSDeparture *departureB;
@property (nonatomic, strong) NSDate *departureDate;
@end

@implementation LJSDepartureTests

- (void)setUp {
    [super setUp];
	 
	self.departureDate = [NSDate date];
	
    self.departureA = [LJSDeparture new];
	self.departureA.expectedDepartureDate = self.departureDate;
	self.departureA.countdownString = @"11:12";
	self.departureA.destination = @"Sheffield";
	self.departureA.hasLowFloorAccess = YES;
	self.departureA.minutesUntilDeparture = 10;
	
	self.departureB = [LJSDeparture new];
}

- (void)testEquality {
	self.departureB.expectedDepartureDate = self.departureDate;
	self.departureB.countdownString = @"11:12";
	self.departureB.destination = @"Sheffield";
	self.departureB.hasLowFloorAccess = YES;
	self.departureB.minutesUntilDeparture = 10;

	XCTAssertEqualObjects(self.departureA,self.departureB, @"");
}

- (void)testInequalityForServices {
    LJSService *serviceA = [LJSService new];
	LJSService *serviceB = [LJSService new];
	
	serviceA.title = @"service-123";
	serviceB.title = @"service-456";
	
	self.departureA.service = serviceA;
	
	self.departureB.expectedDepartureDate = self.departureDate;
	self.departureB.countdownString = @"11:12";
	self.departureB.destination = @"Sheffield";
	self.departureB.hasLowFloorAccess = YES;
	self.departureB.minutesUntilDeparture = 10;
	self.departureB.service = serviceB;

	XCTAssertNotEqualObjects(self.departureA, self.departureB, @"");
}

- (void)testInequalityForDepartureDate {
	NSDate *departureDateA = [NSDate dateWithTimeIntervalSince1970:100000];
	NSDate *departureDateB = [NSDate dateWithTimeIntervalSince1970:100001];
	
	self.departureA.expectedDepartureDate = departureDateA;
	
	self.departureB.expectedDepartureDate = departureDateB;
	self.departureB.countdownString = @"11:12";
	self.departureB.destination = @"Sheffield";
	self.departureB.hasLowFloorAccess = YES;
	self.departureB.minutesUntilDeparture = 10;

	XCTAssertNotEqualObjects(self.departureA, self.departureB, @"");
}

- (void)testInequalityForDepartureDateString {
	self.departureB.expectedDepartureDate = self.departureDate;
	self.departureB.countdownString = @"22:22";
	self.departureB.destination = @"Sheffield";
	self.departureB.hasLowFloorAccess = YES;
	self.departureB.minutesUntilDeparture = 10;
	
	XCTAssertNotEqualObjects(self.departureA, self.departureB, @"");
}

- (void)testInequalityForDestination {
	self.departureB.expectedDepartureDate = self.departureDate;
	self.departureB.countdownString = @"11:12";
	self.departureB.destination = @"Rotherham";
	self.departureB.hasLowFloorAccess = YES;
	self.departureB.minutesUntilDeparture = 10;
	
	XCTAssertNotEqualObjects(self.departureA, self.departureB, @"");
}

- (void)testInequalityForLowFloorAccess {
	self.departureB.expectedDepartureDate = self.departureDate;
	self.departureB.countdownString = @"11:12";
	self.departureB.destination = @"Sheffield";
	self.departureB.hasLowFloorAccess = NO;
	self.departureB.minutesUntilDeparture = 10;
	
	XCTAssertNotEqualObjects(self.departureA, self.departureB, @"");
}

- (void)testInequalityForMinutesUntilDeparture {
	self.departureB.expectedDepartureDate = self.departureDate;
	self.departureB.countdownString = @"11:12";
	self.departureB.destination = @"Sheffield";
	self.departureB.hasLowFloorAccess = YES;
	self.departureB.minutesUntilDeparture = 20;
	
	XCTAssertNotEqualObjects(self.departureA, self.departureB, @"");
}

- (void)testCopies {
    LJSDeparture *copy = [self.departureA copy];
	
	XCTAssertEqualObjects(copy.service, self.departureA.service, @"");
	XCTAssertEqualObjects(copy.destination, self.departureA.destination, @"");
	XCTAssertEqualObjects(copy.expectedDepartureDate, self.departureA.expectedDepartureDate, @"");
	XCTAssertEqualObjects(copy.countdownString, self.departureA.countdownString, @"");
	XCTAssertEqual((NSInteger)copy.minutesUntilDeparture, (NSInteger)self.departureA.minutesUntilDeparture, @"");
	XCTAssertEqual(copy.hasLowFloorAccess, self.departureA.hasLowFloorAccess, @"");
}


@end
