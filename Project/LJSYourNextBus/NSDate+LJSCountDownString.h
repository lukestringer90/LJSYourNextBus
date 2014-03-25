//
//  NSDate+LJSCountDownString.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 24/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LJSCountDownString)

- (NSString *)countdownStringTowardsDate:(NSDate *)date calendar:(NSCalendar *)calendar;

@end
