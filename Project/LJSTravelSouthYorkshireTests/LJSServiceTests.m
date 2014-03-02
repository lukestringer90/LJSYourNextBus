//
//  LJSServiceTests.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 02/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LJSService.h"
#import "LJSServiceBuilder.h"
#import "LJSStop.h"
#import "LJSStopBuilder.h"
#import "LJSDepature.h"
#import "LJSDepatureBuilder.h"

@interface LJSServiceTests : XCTestCase
@property (nonatomic, strong) LJSServiceBuilder *serviceBuilder;
@property (nonatomic, strong) LJSStopBuilder *stopBuilder;
@end

@implementation LJSServiceTests

- (void)setUp {
    [super setUp];
	self.serviceBuilder = [[LJSServiceBuilder alloc] init];
    self.stopBuilder = [[LJSStopBuilder alloc] init];
}

- (void)testEquality {
	
	LJSService *serviceA = [[self.serviceBuilder service] withTitle:@"service-123"];
	LJSService *serviceB = [[self.serviceBuilder service] withTitle:@"service-123"];
	
	XCTAssertEqualObjects(serviceA, serviceB, @"");
}

- (void)testInequalityForTitle {
	LJSService *serviceA = [[self.serviceBuilder service] withTitle:@"service-123"] ;
	LJSService *serviceB = [[self.serviceBuilder service] withTitle:@"service-456"];
	
	XCTAssertNotEqualObjects(serviceA, serviceB, @"");
}

- (void)testInequalityForStop {
	LJSStop *stopA = [[self.stopBuilder stop] withNaPTANCode:@"stop-123"];
	LJSStop *stopB = [[self.stopBuilder stop] withNaPTANCode:@"stop-456"];
	
	LJSService *serviceA = [[[self.serviceBuilder service] withTitle:@"service-123"] withStop:stopA];
	LJSService *serviceB = [[[self.serviceBuilder service] withTitle:@"service-123"] withStop:stopB];
	
	XCTAssertNotEqualObjects(serviceA, serviceB, @"");
}

- (void)testInequalityForDepatures {
	LJSDepatureBuilder *depatureBuilder = [[LJSDepatureBuilder alloc] init];
	NSDate *depatureDateA = [NSDate dateWithTimeIntervalSince1970:100000];
	NSDate *depatureDateB = [NSDate dateWithTimeIntervalSince1970:100001];
	NSDate *depatureDateC = [NSDate dateWithTimeIntervalSince1970:100002];
	LJSDepature *depatureA = [[[[depatureBuilder depature]
								withExpectedDepatureDate:depatureDateA]
							   withDestination:@"Sheffield"]
							  withHasLowFloorAccess:YES];
	LJSDepature *depatureB = [[[[depatureBuilder depature]
								withExpectedDepatureDate:depatureDateB]
							   withDestination:@"Rotherham"]
							  withHasLowFloorAccess:NO];
	LJSDepature *depatureC = [[[[depatureBuilder depature]
								withExpectedDepatureDate:depatureDateC]
							   withDestination:@"Barnsley"]
							  withHasLowFloorAccess:YES];
		
	LJSService *serviceA = [[[self.serviceBuilder service] withTitle:@"service-123"] withDepautures:@[depatureA, depatureB]];
	LJSService *serviceB = [[[self.serviceBuilder service] withTitle:@"service-123"] withDepautures:@[depatureA, depatureC]];
	
	XCTAssertNotEqualObjects(serviceA, serviceB, @"");
}

@end
