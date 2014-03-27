//
//  LJSDepartureDateParser.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 01/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJSDepartureDateParser : NSObject

/**
 *  Constructs an NSDate at a time (e.g 10:00) on a date (01.01.2014)
 *  Used when a departure time or a live time is specified such as 10:00 
 *  and a date is needed representing it on a specific date.
 *
 *  @param dateString A string of the form "HH:mm" specifying a time of hours and minutes.
 *  @param baseDate   The date on which the time is needed.
 *
 *  @return An NSDate of the day, month, year of the base date, and time from the dateString.
 */
- (NSDate *)dateFromString:(NSString *)dateString baseDate:(NSDate *)baseDate;
- (NSInteger)minutesUntilDate:(NSDate *)date departureDateString:(NSString *)departureDateString;

@end
