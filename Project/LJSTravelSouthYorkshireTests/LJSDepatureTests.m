//
//  LJSDepatureTests.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 02/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LJSDepature.h"
#import "LJSService.h"
#import "LJSDepatureBuilder.h"
#import "LJSServiceBuilder.h"
#import "LJSStop.h"
#import "LJSStopBuilder.h"

@interface LJSDepatureTests : XCTestCase
@property (nonatomic, strong) LJSServiceBuilder *serviceBuilder;
@property (nonatomic, strong) LJSDepatureBuilder *depatureBuilder;
@property (nonatomic, strong) LJSService *service;
@property (nonatomic, strong) LJSStop *stop;
@end

@implementation LJSDepatureTests

- (void)setUp {
    [super setUp];
    self.depatureBuilder = [[LJSDepatureBuilder alloc] init];
	self.serviceBuilder = [[LJSServiceBuilder alloc] init];
	
	LJSStopBuilder *stopBuilder = [[LJSStopBuilder alloc] init];
	self.stop = [[stopBuilder stop] withNaPTANCode:@"stop-123"];
	self.service = [[[self.serviceBuilder service] withTitle:@"service-123"] withStop:self.stop];
}

- (void)testEquality {
	NSDate *depatureDate = [NSDate date];
	LJSDepature *depatureA = [[[[[self.depatureBuilder depature]
								 withService:self.service]
								withExpectedDepatureDate:depatureDate]
							   withDestination:@"Sheffield"]
							  withHasLowFloorAccess:YES];
	LJSDepature *depatureB = [[[[[self.depatureBuilder depature]
								 withService:self.service]
								withExpectedDepatureDate:depatureDate]
							   withDestination:@"Sheffield"]
							  withHasLowFloorAccess:YES];

	XCTAssertEqualObjects(depatureA, depatureB, @"");
}

- (void)testInequalityForServices {
    LJSService *serviceA = [[[self.serviceBuilder service] withTitle:@"service-123"] withStop:self.stop];
	LJSService *serviceB = [[[self.serviceBuilder service] withTitle:@"service-456"] withStop:self.stop];
	
	NSDate *depatureDate = [NSDate date];
	LJSDepature *depatureA = [[[[[self.depatureBuilder depature]
								 withService:serviceA]
								withExpectedDepatureDate:depatureDate]
							   withDestination:@"Sheffield"]
							  withHasLowFloorAccess:YES];
	LJSDepature *depatureB = [[[[[self.depatureBuilder depature]
								 withService:serviceB]
								withExpectedDepatureDate:depatureDate]
							   withDestination:@"Sheffield"]
							  withHasLowFloorAccess:YES];
	
	XCTAssertNotEqualObjects(depatureA, depatureB, @"");
}

- (void)testInequalityForDepatureDate {
	NSDate *depatureDateA = [NSDate dateWithTimeIntervalSince1970:100000];
	NSDate *depatureDateB = [NSDate dateWithTimeIntervalSince1970:100001];
	LJSDepature *depatureA = [[[[[self.depatureBuilder depature]
								 withService:self.service]
								withExpectedDepatureDate:depatureDateA]
							   withDestination:@"Sheffield"]
							  withHasLowFloorAccess:YES];
	LJSDepature *depatureB = [[[[[self.depatureBuilder depature]
								 withService:self.service]
								withExpectedDepatureDate:depatureDateB]
							   withDestination:@"Sheffield"]
							  withHasLowFloorAccess:YES];

	
	XCTAssertNotEqualObjects(depatureA, depatureB, @"");
}

- (void)testInequalityForDestination {
	NSDate *depatureDate = [NSDate date];
	LJSDepature *depatureA = [[[[[self.depatureBuilder depature]
								 withService:self.service]
								withExpectedDepatureDate:depatureDate]
							   withDestination:@"Sheffield"]
							  withHasLowFloorAccess:YES];
	LJSDepature *depatureB = [[[[[self.depatureBuilder depature]
								 withService:self.service]
								withExpectedDepatureDate:depatureDate]
							   withDestination:@"Rotherham"]
							  withHasLowFloorAccess:YES];
	
	
	XCTAssertNotEqualObjects(depatureA, depatureB, @"");
}

- (void)testInequalityForLowFloorAccess {
	NSDate *depatureDate = [NSDate date];
	LJSDepature *depatureA = [[[[[self.depatureBuilder depature]
								 withService:self.service]
								withExpectedDepatureDate:depatureDate]
							   withDestination:@"Sheffield"]
							  withHasLowFloorAccess:YES];
	LJSDepature *depatureB = [[[[[self.depatureBuilder depature]
								 withService:self.service]
								withExpectedDepatureDate:depatureDate]
							   withDestination:@"Sheffield"]
							  withHasLowFloorAccess:NO];
	
	
	XCTAssertNotEqualObjects(depatureA, depatureB, @"");
}


@end
