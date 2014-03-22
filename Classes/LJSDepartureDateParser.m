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

- (NSDate *)dateFromString:(NSString *)dateString baseDate:(NSDate *)baseDate {
	NSTextCheckingResult *regexMatch = [self regularExpressionMatchInDateString:dateString];
	
	if (regexMatch != nil) {
		return [self dateFromRegexMatch:regexMatch dateString:dateString baseDate:baseDate];
	}
	else {
		return [self dateFromMinutesString:dateString baseDate:baseDate];
	}
	
}

- (NSDate *)dateFromRegexMatch:(NSTextCheckingResult *)regexMatch dateString:(NSString *)dateString baseDate:(NSDate *)baseDate {
	NSRange hoursRange = [regexMatch rangeAtIndex:1];
	NSRange minutesRange = [regexMatch rangeAtIndex:2];
	
	NSString *hoursString = [dateString substringWithRange:hoursRange];
	NSString *minutesString = [dateString substringWithRange:minutesRange];
	
	NSDateComponents *dateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
														fromDate:baseDate];
	dateComponents.hour = [hoursString integerValue];
	dateComponents.minute = [minutesString integerValue];
	dateComponents.second = 0;
	
	return [self.calendar dateFromComponents:dateComponents];
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
