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
	// TODO: Pending
}

@end
