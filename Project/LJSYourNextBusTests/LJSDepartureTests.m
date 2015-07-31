//
//  LJSDepartureTests.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 02/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LJSDeparture.h"
#import "LJSDepartureBuilder.h"

@interface LJSDepartureTests : XCTestCase
@property (nonatomic, strong) LJSDepartureBuilder *departureBuilder;
@property (nonatomic, strong) LJSDeparture *departureA;
@property (nonatomic, strong) LJSDeparture *departureB;
@property (nonatomic, strong) NSDate *departureDate;
@end

@implementation LJSDepartureTests

- (void)setUp {
    [super setUp];
	
	self.departureBuilder = [LJSDepartureBuilder new];
	
	self.departureDate = [NSDate date];
	
	self.departureBuilder.expectedDepartureDate = self.departureDate;
	self.departureBuilder.countdownString = @"2 Mins";
	self.departureBuilder.destination = @"Sheffield";
	self.departureBuilder.hasLowFloorAccess = YES;
	self.departureBuilder.minutesUntilDeparture = 10;
	
	self.departureA = [self.departureBuilder buildForService:nil];
}

- (void)testEquality {
	self.departureBuilder.expectedDepartureDate = self.departureDate;
	self.departureBuilder.countdownString = @"2 Mins";
	self.departureBuilder.destination = @"Sheffield";
	self.departureBuilder.hasLowFloorAccess = YES;
	self.departureBuilder.minutesUntilDeparture = 10;
	
	self.departureB = [self.departureBuilder buildForService:nil];

	XCTAssertEqualObjects(self.departureA,self.departureB, @"");
}

- (void)testInequalityForDepartureDate {
	NSDate *departureDateA = [NSDate dateWithTimeIntervalSince1970:100000];
	NSDate *departureDateB = [NSDate dateWithTimeIntervalSince1970:100001];
	
	self.departureBuilder.expectedDepartureDate = departureDateA;
	self.departureA = [self.departureBuilder buildForService:nil];
	
	self.departureBuilder.expectedDepartureDate = departureDateB;
	self.departureBuilder.countdownString = @"2 Mins";
	self.departureBuilder.destination = @"Sheffield";
	self.departureBuilder.hasLowFloorAccess = YES;
	self.departureBuilder.minutesUntilDeparture = 10;
	self.departureB = [self.departureBuilder buildForService:nil];

	XCTAssertNotEqualObjects(self.departureA, self.departureB, @"");
}

- (void)testInequalityForCountDownString {
	self.departureBuilder.expectedDepartureDate = self.departureDate;
	self.departureBuilder.countdownString = @"10 Mins";
	self.departureBuilder.destination = @"Sheffield";
	self.departureBuilder.hasLowFloorAccess = YES;
	self.departureBuilder.minutesUntilDeparture = 10;
	self.departureB = [self.departureBuilder buildForService:nil];
	
	XCTAssertNotEqualObjects(self.departureA, self.departureB, @"");
}

- (void)testInequalityForDestination {
	self.departureBuilder.expectedDepartureDate = self.departureDate;
	self.departureBuilder.countdownString = @"2 Mins";
	self.departureBuilder.destination = @"Rotherham";
	self.departureBuilder.hasLowFloorAccess = YES;
	self.departureBuilder.minutesUntilDeparture = 10;
	self.departureB = [self.departureBuilder buildForService:nil];
	
	XCTAssertNotEqualObjects(self.departureA, self.departureB, @"");
}

- (void)testInequalityForLowFloorAccess {
	self.departureBuilder.expectedDepartureDate = self.departureDate;
	self.departureBuilder.countdownString = @"2 Mins";
	self.departureBuilder.destination = @"Sheffield";
	self.departureBuilder.hasLowFloorAccess = NO;
	self.departureBuilder.minutesUntilDeparture = 10;
	self.departureB = [self.departureBuilder buildForService:nil];
	
	XCTAssertNotEqualObjects(self.departureA, self.departureB, @"");
}

- (void)testInequalityForMinutesUntilDeparture {
	self.departureBuilder.expectedDepartureDate = self.departureDate;
	self.departureBuilder.countdownString = @"2 Mins";
	self.departureBuilder.destination = @"Sheffield";
	self.departureBuilder.hasLowFloorAccess = YES;
	self.departureBuilder.minutesUntilDeparture = 20;
	self.departureB = [self.departureBuilder buildForService:nil];
	
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
