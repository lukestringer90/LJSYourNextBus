//
//  LJSStop.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 29/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJSStop : NSObject

@property (nonatomic, readonly) NSString *NaPTANCode;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSDate *liveDate;
@property (nonatomic, readonly) NSArray *services;

- (BOOL)isEqualToStop:(LJSStop *)stop;

@end
