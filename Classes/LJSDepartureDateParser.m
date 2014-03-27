//
//  LJSDepartureDateParser.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 01/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSDepartureDateParser.h"

@interface LJSDepartureDateParser ()
@property (nonatomic, strong) NSCalendar *calendar;
@end

@implementation LJSDepartureDateParser

- (instancetype)init {
    if (self = [super init]) {
        self.calendar = [NSCalendar currentCalendar];
    }
    return self;
}

#pragma mark - Public

- (NSDate *)dateFromString:(NSString *)dateString baseDate:(NSDate *)baseDate {
	NSTextCheckingResult *regexMatch = [self regularExpressionMatchInDateString:dateString];
	
	if (regexMatch != nil) {
		// dateString is of the form "11:12"
		return [self dateFromRegexMatch:regexMatch dateString:dateString baseDate:baseDate];
	}
	else {
		// dateString is of the form "12 mins"
		return [self dateFromMinutesString:dateString baseDate:baseDate];
	}
}

- (NSInteger)minutesUntilDate:(NSDate *)date departureDateString:(NSString *)departureDateString {
	NSDate *departureDate = [self dateFromString:departureDateString baseDate:date];
	NSDateComponents *dateComponents = [self.calendar components:NSMinuteCalendarUnit
														fromDate:date
														  toDate:departureDate
														 options:0];
	return dateComponents.minute;
}

#pragma mark - Private

- (NSDate *)dateFromRegexMatch:(NSTextCheckingResult *)regexMatch dateString:(NSString *)dateString baseDate:(NSDate *)baseDate {
	NSRange hoursRange = [regexMatch rangeAtIndex:1];
	NSRange minutesRange = [regexMatch rangeAtIndex:2];
	
	NSInteger hours = [[dateString substringWithRange:hoursRange] integerValue];
	NSInteger minutes = [[dateString substringWithRange:minutesRange] integerValue];
	
	NSDateComponents *dateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
														fromDate:baseDate];
	
	dateComponents.hour = hours;
	dateComponents.minute = minutes;
	dateComponents.second = 0;
	
	NSDate *newDate = [self.calendar dateFromComponents:dateComponents];
	
	/**
	 *  New date and base date are different times but the same day.
	 *  If the new date time is before the base date's time then we need
	 *  the time tomorrow.
	 *  eg. if new date is 11:00 and base date is 12:00 then 11:00 tomorrow is needed.
	 */
	if ([newDate compare:baseDate] == NSOrderedAscending) {
		NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
		[offsetComponents setDay:1];
		newDate = [self.calendar dateByAddingComponents:offsetComponents
														  toDate:newDate
														 options:0];
	}
	
	return newDate;
}


- (NSDate *)dateFromMinutesString:(NSString *)mintuesString baseDate:(NSDate *)baseDate {
	NSArray *components = [mintuesString componentsSeparatedByString:@" "];
	NSString *minutesString = components[0];
	NSInteger minutes = [minutesString integerValue];
	
	NSDateComponents *minutesComponent = [[NSDateComponents alloc] init];
	minutesComponent.minute = minutes;
	
	NSDate *newDate = [self.calendar dateByAddingComponents:minutesComponent
													 toDate:baseDate
													options:0];
	return newDate;
	
}

- (NSTextCheckingResult *)regularExpressionMatchInDateString:(NSString *)dateString {
	NSRegularExpression *regex;
	regex = [NSRegularExpression regularExpressionWithPattern:@"^([0-9]|0[0-9]|1[0-9]|2[0-3]):([0-5][0-9])$"
													  options:NSRegularExpressionCaseInsensitive
														error:nil];
	
	NSArray *matches = [regex matchesInString:dateString
									  options:0
										range:NSMakeRange(0, dateString.length)];
	
	NSTextCheckingResult *match = [matches firstObject];
	return match;
	
}

@end
