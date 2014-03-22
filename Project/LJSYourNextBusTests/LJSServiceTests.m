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
#import "LJSDepature.h"
#import "LJSDepature+LJSSetters.h"

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

- (void)testInequalityForDepatures {
	NSDate *depatureDateA = [NSDate dateWithTimeIntervalSince1970:100000];
	NSDate *depatureDateB = [NSDate dateWithTimeIntervalSince1970:100001];
	NSDate *depatureDateC = [NSDate dateWithTimeIntervalSince1970:100002];
	
	LJSDepature *depatureA = [LJSDepature new];
	depatureA.expectedDepatureDate = depatureDateA;
	depatureA.destination = @"Sheffield";
	depatureA.hasLowFloorAccess = YES;
	
	LJSDepature *depatureB = [LJSDepature new];
	depatureB.expectedDepatureDate = depatureDateB;
	depatureB.destination = @"Rotherham";
	depatureB.hasLowFloorAccess = NO;
	
	LJSDepature *depatureC = [LJSDepature new];
	depatureC.expectedDepatureDate = depatureDateC;
	depatureC.destination = @"Barnsley";
	depatureC.hasLowFloorAccess = YES;
	
	self.serviceA.title = @"service-123";
	self.serviceA.depatures = @[depatureA, depatureB];
	self.serviceB.title = @"service-123";
	self.serviceB.depatures = @[depatureA, depatureC];
	
	XCTAssertNotEqualObjects(self.serviceA, self.serviceB, @"");
}

@end
