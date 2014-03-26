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
#import "LJSDeparture+LJSSetters.h"

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
	self.stopA.liveDate = [NSDate date];
	self.stopA.laterURL = [NSURL URLWithString:@"www.foo.com"];
	self.stopA.earlierURL = [NSURL URLWithString:@"www.bar.com"];
	
    LJSStop *copy = [self.stopA copy];
	
	XCTAssertEqualObjects(copy.title, self.stopA.title, @"");
	XCTAssertEqualObjects(copy.NaPTANCode, self.stopA.NaPTANCode, @"");
	XCTAssertEqualObjects(copy.liveDate, self.stopA.liveDate, @"");
	XCTAssertEqualObjects(copy.services, self.stopA.services, @"");
	XCTAssertEqualObjects(copy.laterURL, self.stopA.laterURL, @"");
	XCTAssertEqualObjects(copy.earlierURL, self.stopA.earlierURL, @"");
}

- (void)testJSONRepresentation {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateStyle = NSDateFormatterShortStyle;
	dateFormatter.timeStyle = NSDateFormatterShortStyle;
	
	LJSDeparture *departureA = [LJSDeparture new];
	departureA.expectedDepartureDate = [NSDate date];
	departureA.destination = @"Sheffield";
	departureA.hasLowFloorAccess = YES;
	departureA.countdownString = @"11:12";
	departureA.minutesUntilDeparture = 1;
	
	LJSDeparture *departureB = [LJSDeparture new];
	departureB.expectedDepartureDate = [NSDate date];
	departureB.destination = @"Rotherham";
	departureB.hasLowFloorAccess = NO;
	departureB.countdownString = @"12:12";
	departureB.minutesUntilDeparture = 2;

	LJSService *serviceA = [LJSService new];
	serviceA.title = @"service-123";
	serviceA.departures = @[departureA, departureB];
	
	NSDate *liveDate = [NSDate date];
	self.stopA.NaPTANCode = @"123";
	self.stopA.services = @[serviceA];
	self.stopA.liveDate = liveDate;
	self.stopA.laterURL = [NSURL URLWithString:@"www.foo.com"];
	self.stopA.earlierURL = [NSURL URLWithString:@"www.bar.com"];
	
	NSDictionary *correctJSON = @{
								  @"NaPTANCode" : @"123",
								  @"liveDate" : [dateFormatter stringFromDate:liveDate],
								  @"laterURL" : @"www.foo.com",
								  @"earlierURL" : @"www.bar.com",
								  @"services" : @[
										  [serviceA JSONRepresentation]
										  ]
								  };
	
	XCTAssertEqualObjects([self.stopA JSONRepresentation], correctJSON, @"");
}


@end
