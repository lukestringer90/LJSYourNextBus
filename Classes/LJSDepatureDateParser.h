//
//  LJSDepatureDateParser.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 01/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJSDepatureDateParser : NSObject

- (NSDate *)dateFromString:(NSString *)dateString baseDate:(NSDate *)baseDate;

@end
