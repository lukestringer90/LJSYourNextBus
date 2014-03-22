//
//  LJSStop.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 29/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJSStop : NSObject <NSCopying>

/**
 *  An 8 digit stop number starting with e.g. 450 for West Yorkshire or 370 for South Yorkshire
 */
@property (nonatomic, copy, readonly) NSString *NaPTANCode;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSDate *liveDate;
@property (nonatomic, copy, readonly) NSArray *services;

- (BOOL)isEqualToStop:(LJSStop *)stop;

@end
