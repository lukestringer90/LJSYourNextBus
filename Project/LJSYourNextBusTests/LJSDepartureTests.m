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
@property (nonatomic, strong) LJSDeparture *DepartureA;
@property (nonatomic, strong) LJSDeparture *DepartureB;
@end

@implementation LJSDepartureTests

- (void)setUp {
    [super setUp];
    self.DepartureA = [LJSDeparture new];
	self.DepartureB = [LJSDeparture new];
}

- (void)testEquality {
	NSDate *DepartureDate = [NSDate date];
	self.DepartureA.expectedDepartureDate = DepartureDate;
	self.DepartureA.destination = @"Sheffield";
	self.DepartureA.hasLowFloorAccess = YES;
	
	self.DepartureB.expectedDepartureDate = DepartureDate;
	self.DepartureB.destination = @"Sheffield";
	self.DepartureB.hasLowFloorAccess = YES;

	XCTAssertEqualObjects(self.DepartureA,self.DepartureB, @"");
}

- (void)testInequalityForServices {
    LJSService *serviceA = [LJSService new];
	LJSService *serviceB = [LJSService new];
	
	serviceA.title = @"service-123";
	serviceB.title = @"service-456";
	
	NSDate *DepartureDate = [NSDate date];
	self.DepartureA.expectedDepartureDate = DepartureDate;
	self.DepartureA.destination = @"Sheffield";
	self.DepartureA.hasLowFloorAccess = YES;
	self.DepartureA.service = serviceA;
	
	self.DepartureB.expectedDepartureDate = DepartureDate;
	self.DepartureB.destination = @"Sheffield";
	self.DepartureB.hasLowFloorAccess = YES;
	self.DepartureB.service = serviceB;

	XCTAssertNotEqualObjects(self.DepartureA, self.DepartureB, @"");
}

- (void)testInequalityForDepartureDate {
	NSDate *DepartureDateA = [NSDate dateWithTimeIntervalSince1970:100000];
	NSDate *DepartureDateB = [NSDate dateWithTimeIntervalSince1970:100001];
	
	self.DepartureA.expectedDepartureDate = DepartureDateA;
	self.DepartureA.destination = @"Sheffield";
	self.DepartureA.hasLowFloorAccess = YES;
	
	self.DepartureB.expectedDepartureDate = DepartureDateB;
	self.DepartureB.destination = @"Sheffield";
	self.DepartureB.hasLowFloorAccess = YES;

	XCTAssertNotEqualObjects(self.DepartureA, self.DepartureB, @"");
}

- (void)testInequalityForDestination {
	NSDate *DepartureDate = [NSDate date];
	self.DepartureA.expectedDepartureDate = DepartureDate;
	self.DepartureA.destination = @"Sheffield";
	self.DepartureA.hasLowFloorAccess = YES;
	
	self.DepartureB.expectedDepartureDate = DepartureDate;
	self.DepartureB.destination = @"Rotherham";
	self.DepartureB.hasLowFloorAccess = YES;
	
	XCTAssertNotEqualObjects(self.DepartureA, self.DepartureB, @"");
}

- (void)testInequalityForLowFloorAccess {
	NSDate *DepartureDate = [NSDate date];
	self.DepartureA.expectedDepartureDate = DepartureDate;
	self.DepartureA.destination = @"Sheffield";
	self.DepartureA.hasLowFloorAccess = YES;
	
	self.DepartureB.expectedDepartureDate = DepartureDate;
	self.DepartureB.destination = @"Sheffield";
	self.DepartureB.hasLowFloorAccess = NO;
	
	XCTAssertNotEqualObjects(self.DepartureA, self.DepartureB, @"");
}

- (void)testCopies {
	NSDate *DepartureDate = [NSDate date];
	self.DepartureA.expectedDepartureDate = DepartureDate;
	self.DepartureA.destination = @"Sheffield";
	self.DepartureA.hasLowFloorAccess = YES;

    LJSDeparture *copy = [self.DepartureA copy];
	
	XCTAssertEqualObjects(copy, self.DepartureA, @"");
	
	// TODO: Test equality for all properties
}


@end
