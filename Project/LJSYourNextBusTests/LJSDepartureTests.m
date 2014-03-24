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
@end

@implementation LJSDepartureTests

- (void)setUp {
    [super setUp];
    self.departureA = [LJSDeparture new];
	self.departureB = [LJSDeparture new];
}

- (void)testEquality {
	NSDate *departureDate = [NSDate date];
	self.departureA.expectedDepartureDate = departureDate;
	self.departureA.destination = @"Sheffield";
	self.departureA.hasLowFloorAccess = YES;
	
	self.departureB.expectedDepartureDate = departureDate;
	self.departureB.destination = @"Sheffield";
	self.departureB.hasLowFloorAccess = YES;

	XCTAssertEqualObjects(self.departureA,self.departureB, @"");
}

- (void)testInequalityForServices {
    LJSService *serviceA = [LJSService new];
	LJSService *serviceB = [LJSService new];
	
	serviceA.title = @"service-123";
	serviceB.title = @"service-456";
	
	NSDate *departureDate = [NSDate date];
	self.departureA.expectedDepartureDate = departureDate;
	self.departureA.destination = @"Sheffield";
	self.departureA.hasLowFloorAccess = YES;
	self.departureA.service = serviceA;
	
	self.departureB.expectedDepartureDate = departureDate;
	self.departureB.destination = @"Sheffield";
	self.departureB.hasLowFloorAccess = YES;
	self.departureB.service = serviceB;

	XCTAssertNotEqualObjects(self.departureA, self.departureB, @"");
}

- (void)testInequalityFordepartureDate {
	NSDate *departureDateA = [NSDate dateWithTimeIntervalSince1970:100000];
	NSDate *departureDateB = [NSDate dateWithTimeIntervalSince1970:100001];
	
	self.departureA.expectedDepartureDate = departureDateA;
	self.departureA.destination = @"Sheffield";
	self.departureA.hasLowFloorAccess = YES;
	
	self.departureB.expectedDepartureDate = departureDateB;
	self.departureB.destination = @"Sheffield";
	self.departureB.hasLowFloorAccess = YES;

	XCTAssertNotEqualObjects(self.departureA, self.departureB, @"");
}

- (void)testInequalityForDestination {
	NSDate *departureDate = [NSDate date];
	self.departureA.expectedDepartureDate = departureDate;
	self.departureA.destination = @"Sheffield";
	self.departureA.hasLowFloorAccess = YES;
	
	self.departureB.expectedDepartureDate = departureDate;
	self.departureB.destination = @"Rotherham";
	self.departureB.hasLowFloorAccess = YES;
	
	XCTAssertNotEqualObjects(self.departureA, self.departureB, @"");
}

- (void)testInequalityForLowFloorAccess {
	NSDate *departureDate = [NSDate date];
	self.departureA.expectedDepartureDate = departureDate;
	self.departureA.destination = @"Sheffield";
	self.departureA.hasLowFloorAccess = YES;
	
	self.departureB.expectedDepartureDate = departureDate;
	self.departureB.destination = @"Sheffield";
	self.departureB.hasLowFloorAccess = NO;
	
	XCTAssertNotEqualObjects(self.departureA, self.departureB, @"");
}

- (void)testCopies {
	NSDate *departureDate = [NSDate date];
	self.departureA.expectedDepartureDate = departureDate;
	self.departureA.destination = @"Sheffield";
	self.departureA.hasLowFloorAccess = YES;

    LJSDeparture *copy = [self.departureA copy];
	
	XCTAssertEqualObjects(copy, self.departureA, @"");
	
	// TODO: Test equality for all properties
}


@end
