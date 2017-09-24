//
//  NSDate+LJSCountDownString.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 24/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "NSDate+LJSCountDownString.h"

@implementation NSDate (LJSCountDownString)

- (NSString *)countdownStringTowardsDate:(NSDate *)date calendar:(NSCalendar *)calendar {

	
	NSDateComponents *dateComponents = [calendar components:NSMinuteCalendarUnit | NSSecondCalendarUnit
														fromDate:date
														  toDate:self
														 options:0];
    
    NSInteger minute = dateComponents.minute;
    NSInteger second = dateComponents.second;
    
	if (minute == 0) {
		return @"Due";
	}
	else if (minute < 0 || second < 0) {
		return @"Departed";
	}
	else if (minute <= 20) {
        NSInteger roundedMinute = second > 0 ? minute + 1 : minute;
		return [NSString stringWithFormat:@"%ld Mins", (long)roundedMinute];
	}
	else {
		return [[self dateFormatter] stringFromDate:self];
	}
	
	return nil;
}

- (NSDateFormatter *)dateFormatter
{
	static NSDateFormatter *dateFormatter = nil;
	if (!dateFormatter) {
		dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.timeStyle = NSDateFormatterShortStyle;
	}
	return dateFormatter;
}

@end
