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

@interface LJSDepartureTests : XCTestCase
@property (nonatomic, strong) LJSDeparture *departureA;
@property (nonatomic, strong) LJSDeparture *departureB;
@property (nonatomic, strong) NSDate *departureDate;
@end

@implementation LJSDepartureTests

- (void)setUp {
    [super setUp];
	 
	self.departureDate = [NSDate date];
	
    self.departureA = [LJSDeparture new];
	self.departureA.expectedDepartureDate = self.departureDate;
	self.departureA.countdownString = @"2 Mins";
	self.departureA.destination = @"Sheffield";
	self.departureA.hasLowFloorAccess = YES;
	self.departureA.minutesUntilDeparture = 10;
	
	self.departureB = [LJSDeparture new];
}

- (void)testEquality {
	self.departureB.expectedDepartureDate = self.departureDate;
	self.departureB.countdownString = @"2 Mins";
	self.departureB.destination = @"Sheffield";
	self.departureB.hasLowFloorAccess = YES;
	self.departureB.minutesUntilDeparture = 10;

	XCTAssertEqualObjects(self.departureA,self.departureB, @"");
}

- (void)testInequalityForDepartureDate {
	NSDate *departureDateA = [NSDate dateWithTimeIntervalSince1970:100000];
	NSDate *departureDateB = [NSDate dateWithTimeIntervalSince1970:100001];
	
	self.departureA.expectedDepartureDate = departureDateA;
	
	self.departureB.expectedDepartureDate = departureDateB;
	self.departureB.countdownString = @"2 Mins";
	self.departureB.destination = @"Sheffield";
	self.departureB.hasLowFloorAccess = YES;
	self.departureB.minutesUntilDeparture = 10;

	XCTAssertNotEqualObjects(self.departureA, self.departureB, @"");
}

- (void)testInequalityForCountDownString {
	self.departureB.expectedDepartureDate = self.departureDate;
	self.departureB.countdownString = @"10 Mins";
	self.departureB.destination = @"Sheffield";
	self.departureB.hasLowFloorAccess = YES;
	self.departureB.minutesUntilDeparture = 10;
	
	XCTAssertNotEqualObjects(self.departureA, self.departureB, @"");
}

- (void)testInequalityForDestination {
	self.departureB.expectedDepartureDate = self.departureDate;
	self.departureB.countdownString = @"2 Mins";
	self.departureB.destination = @"Rotherham";
	self.departureB.hasLowFloorAccess = YES;
	self.departureB.minutesUntilDeparture = 10;
	
	XCTAssertNotEqualObjects(self.departureA, self.departureB, @"");
}

- (void)testInequalityForLowFloorAccess {
	self.departureB.expectedDepartureDate = self.departureDate;
	self.departureB.countdownString = @"2 Mins";
	self.departureB.destination = @"Sheffield";
	self.departureB.hasLowFloorAccess = NO;
	self.departureB.minutesUntilDeparture = 10;
	
	XCTAssertNotEqualObjects(self.departureA, self.departureB, @"");
}

- (void)testInequalityForMinutesUntilDeparture {
	self.departureB.expectedDepartureDate = self.departureDate;
	self.departureB.countdownString = @"2 Mins";
	self.departureB.destination = @"Sheffield";
	self.departureB.hasLowFloorAccess = YES;
	self.departureB.minutesUntilDeparture = 20;
	
	XCTAssertNotEqualObjects(self.departureA, self.departureB, @"");
}

- (void)testCopies {
    LJSDeparture *copy = [self.departureA copy];
	
	XCTAssertEqualObjects(copy.service, self.departureA.service, @"");
	XCTAssertEqualObjects(copy.destination, self.departureA.destination, @"");
	XCTAssertEqualObjects(copy.expectedDepartureDate, self.departureA.expectedDepartureDate, @"");
	XCTAssertEqualObjects(copy.countdownString, self.departureA.countdownString, @"");
	XCTAssertEqual((NSInteger)copy.minutesUntilDeparture, (NSInteger)self.departureA.minutesUntilDeparture, @"");
	XCTAssertEqual(copy.hasLowFloorAccess, self.departureA.hasLowFloorAccess, @"");
}

- (void)testJSONRepresentation {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateStyle = NSDateFormatterShortStyle;
	dateFormatter.timeStyle = NSDateFormatterShortStyle;
	
	NSDictionary *correctJSON = @{
								  @"destination" : @"Sheffield",
								  @"countdownString" : @"2 Mins",
								  @"expectedDepartureDate" : [dateFormatter stringFromDate:self.departureDate],
								  @"hasLowFloorAccess" : @(YES),
								  @"minutesUntilDeparture" : @(10)
								  };
	
	XCTAssertEqualObjects([self.departureA JSONRepresentation], correctJSON, @"");
}


@end
