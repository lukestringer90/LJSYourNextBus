//
//  LJSDepatureTests.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 02/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LJSDepature.h"
#import "LJSDepature+LJSSetters.h"
#import "LJSService.h"
#import "LJSService+LJSSetters.h"

@interface LJSDepatureTests : XCTestCase
@property (nonatomic, strong) LJSDepature *depatureA;
@property (nonatomic, strong) LJSDepature *depatureB;
@end

@implementation LJSDepatureTests

- (void)setUp {
    [super setUp];
    self.depatureA = [LJSDepature new];
	self.depatureB = [LJSDepature new];
}

- (void)testEquality {
	NSDate *depatureDate = [NSDate date];
	self.depatureA.expectedDepatureDate = depatureDate;
	self.depatureA.destination = @"Sheffield";
	self.depatureA.hasLowFloorAccess = YES;
	
	self.depatureB.expectedDepatureDate = depatureDate;
	self.depatureB.destination = @"Sheffield";
	self.depatureB.hasLowFloorAccess = YES;

	XCTAssertEqualObjects(self.depatureA,self.depatureB, @"");
}

- (void)testInequalityForServices {
    LJSService *serviceA = [LJSService new];
	LJSService *serviceB = [LJSService new];
	
	serviceA.title = @"service-123";
	serviceB.title = @"service-456";
	
	NSDate *depatureDate = [NSDate date];
	self.depatureA.expectedDepatureDate = depatureDate;
	self.depatureA.destination = @"Sheffield";
	self.depatureA.hasLowFloorAccess = YES;
	self.depatureA.service = serviceA;
	
	self.depatureB.expectedDepatureDate = depatureDate;
	self.depatureB.destination = @"Sheffield";
	self.depatureB.hasLowFloorAccess = YES;
	self.depatureB.service = serviceB;

	XCTAssertNotEqualObjects(self.depatureA, self.depatureB, @"");
}

- (void)testInequalityForDepatureDate {
	NSDate *depatureDateA = [NSDate dateWithTimeIntervalSince1970:100000];
	NSDate *depatureDateB = [NSDate dateWithTimeIntervalSince1970:100001];
	
	self.depatureA.expectedDepatureDate = depatureDateA;
	self.depatureA.destination = @"Sheffield";
	self.depatureA.hasLowFloorAccess = YES;
	
	self.depatureB.expectedDepatureDate = depatureDateB;
	self.depatureB.destination = @"Sheffield";
	self.depatureB.hasLowFloorAccess = YES;

	XCTAssertNotEqualObjects(self.depatureA, self.depatureB, @"");
}

- (void)testInequalityForDestination {
	NSDate *depatureDate = [NSDate date];
	self.depatureA.expectedDepatureDate = depatureDate;
	self.depatureA.destination = @"Sheffield";
	self.depatureA.hasLowFloorAccess = YES;
	
	self.depatureB.expectedDepatureDate = depatureDate;
	self.depatureB.destination = @"Rotherham";
	self.depatureB.hasLowFloorAccess = YES;
	
	XCTAssertNotEqualObjects(self.depatureA, self.depatureB, @"");
}

- (void)testInequalityForLowFloorAccess {
	NSDate *depatureDate = [NSDate date];
	self.depatureA.expectedDepatureDate = depatureDate;
	self.depatureA.destination = @"Sheffield";
	self.depatureA.hasLowFloorAccess = YES;
	
	self.depatureB.expectedDepatureDate = depatureDate;
	self.depatureB.destination = @"Sheffield";
	self.depatureB.hasLowFloorAccess = NO;
	
	XCTAssertNotEqualObjects(self.depatureA, self.depatureB, @"");
}


@end
