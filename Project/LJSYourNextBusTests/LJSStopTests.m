//
//  LJSStopTests.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 03/02/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LJSStop.h"
#import "LJSStop+LJSSetters.h"
#import "LJSService.h"
#import "LJSService+LJSSetters.h"

@interface LJSStopTests : XCTestCase
@property (nonatomic, strong) LJSStop *stopA;
@property (nonatomic, strong) LJSStop *stopB;
@end

@implementation LJSStopTests

- (void)setUp {
    [super setUp];
	self.stopA = [LJSStop new];
	self.stopB = [LJSStop new];
}

- (void)testEquality {
	self.stopA.NaPTANCode = @"123";
	self.stopB.NaPTANCode = @"123";
    
    XCTAssertEqualObjects(self.stopA, self.stopB, @"");
}

- (void)testInequalityForTitles {
    self.stopA.NaPTANCode = @"123";
	self.stopB.NaPTANCode = @"456";
    
    XCTAssertNotEqualObjects(self.stopA, self.stopB, @"");
}

- (void)testInequalityForServices {
	LJSService *serviceA = [LJSService new];
	LJSService *serviceB = [LJSService new];
	LJSService *serviceC = [LJSService new];
	
	serviceA.title = @"service-123";
	serviceB.title = @"service-456";
	serviceC.title = @"service-789";
	
	self.stopA.NaPTANCode = @"123";
	self.stopA.services = @[serviceA, serviceB];
	self.stopB.NaPTANCode = @"123";
	self.stopA.services = @[serviceA, serviceC];
	
	XCTAssertNotEqualObjects(self.stopA, self.stopB, @"");
}

- (void)testCopies {
	LJSService *serviceA = [LJSService new];
	serviceA.title = @"service-123";
	self.stopA.NaPTANCode = @"123";
	self.stopA.services = @[serviceA];
	
    LJSStop *copy = [self.stopA copy];
	
	XCTAssertEqualObjects(copy, self.stopA, @"");
}


@end
