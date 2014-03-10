//
//  LJSStopTests.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 03/02/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LJSStop.h"
#import "LJSStopBuilder.h"
#import "LJSServiceBuilder.h"
#import "LJSService.h"

@interface LJSStopTests : XCTestCase
@property (nonatomic, strong) LJSStopBuilder *stopBuilder;
@end

@implementation LJSStopTests

- (void)setUp {
    [super setUp];
    self.stopBuilder = [[LJSStopBuilder alloc] init];
}

- (void)testEquality {
    LJSStop *stopA = [[self.stopBuilder stop] withNaPTANCode:@"123"];
    LJSStop *stopB = [[self.stopBuilder stop] withNaPTANCode:@"123"];
    
    XCTAssertEqualObjects(stopA, stopB, @"");
}

- (void)testInequalityForTitles {
    LJSStop *stopA = [[self.stopBuilder stop] withNaPTANCode:@"123"];
    LJSStop *stopB = [[self.stopBuilder stop] withNaPTANCode:@"456"];
    
    XCTAssertNotEqualObjects(stopA, stopB, @"");
}

- (void)testInequalityForServices {
	LJSServiceBuilder *serviceBuilder = [[LJSServiceBuilder alloc] init];
	LJSService *serviceA = [[serviceBuilder service] withTitle:@"service-123"];
	LJSService *serviceB = [[serviceBuilder service] withTitle:@"service-456"];
	LJSService *serviceC = [[serviceBuilder service] withTitle:@"service-789"];
	
	LJSStop *stopA = [[[self.stopBuilder stop] withNaPTANCode:@"123"] withServices:@[serviceA, serviceB]];
    LJSStop *stopB = [[[self.stopBuilder stop] withNaPTANCode:@"123"] withServices:@[serviceA, serviceC]];
	
	XCTAssertNotEqualObjects(stopA, stopB, @"");
}


@end
