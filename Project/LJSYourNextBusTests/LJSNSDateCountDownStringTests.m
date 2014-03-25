//
//  LJSNSDateCountDownStringTests.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 24/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDate+LJSCountDownString.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

@interface LJSNSDateCountDownStringTests : XCTestCase
@property (nonatomic, strong) NSDate *towardsDate;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDateComponents *dateComponents;
@end

@implementation LJSNSDateCountDownStringTests

- (void)setUp {
	[super setUp];
	
    self.towardsDate = [NSDate dateWithTimeIntervalSince1970:1395701730];
	self.calendar = [NSCalendar currentCalendar];
	self.dateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit
												   fromDate:self.towardsDate];
}

- (void)testCountDownStringDue {
	self.dateComponents.second += 59;
	
	NSDate *laterDate = [self.calendar dateFromComponents:self.dateComponents];
	NSString *countDownString = [laterDate countdownStringTowardsDate:self.towardsDate calendar:self.calendar];
	
	assertThat(countDownString, equalTo(@"Due"));
}

- (void)testCountDownStringDue1Minute {
	self.dateComponents.minute += 1;
	
	NSDate *laterDate = [self.calendar dateFromComponents:self.dateComponents];
	NSString *countDownString = [laterDate countdownStringTowardsDate:self.towardsDate calendar:self.calendar];
	
	assertThat(countDownString, equalTo(@"1 Min"));
}

- (void)testCountDownStringDueManyMinute {
	self.dateComponents.minute += 2;
	
	NSDate *laterDate = [self.calendar dateFromComponents:self.dateComponents];
	NSString *countDownString = [laterDate countdownStringTowardsDate:self.towardsDate calendar:self.calendar];
	
	assertThat(countDownString, equalTo(@"2 Mins"));
	
	self.dateComponents.minute += 10;
	laterDate = [self.calendar dateFromComponents:self.dateComponents];
	countDownString = [laterDate countdownStringTowardsDate:self.towardsDate calendar:self.calendar];
	
	assertThat(countDownString, equalTo(@"12 Mins"));
}

- (void)testCountDownStringDueZero {
	NSString *countDownString = [self.towardsDate countdownStringTowardsDate:self.towardsDate calendar:self.calendar];
	
	assertThat(countDownString, equalTo(@"Due"));
}

- (void)testCountDownStringDueNegative {
	self.dateComponents.minute -= 1;
	
	NSDate *laterDate = [self.calendar dateFromComponents:self.dateComponents];
	NSString *countDownString = [laterDate countdownStringTowardsDate:self.towardsDate calendar:self.calendar];
	
	assertThat(countDownString, equalTo(@"Departed"));
}

@end
