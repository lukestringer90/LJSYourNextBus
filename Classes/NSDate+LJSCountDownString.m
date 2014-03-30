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
	
	if (dateComponents.minute == 0 && dateComponents.second <= 59 && dateComponents.second >= 0) {
		return @"Due";
	}
	else if (dateComponents.minute < 0 || dateComponents.second < 0) {
		return @"Departed";
	}
	else if (dateComponents.minute == 1) {
		return [NSString stringWithFormat:@"%ld Min", (long)dateComponents.minute];
	}
	else {
		return [NSString stringWithFormat:@"%ld Mins", (long)dateComponents.minute];
	}
	
	return nil;
}

@end
