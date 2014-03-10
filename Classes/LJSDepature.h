//
//  LJSDepature.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 29/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LJSService;
@interface LJSDepature : NSObject

@property (nonatomic, readonly) LJSService *service;
@property (nonatomic, readonly) NSString *destination;
@property (nonatomic, readonly) NSDate *expectedDepatureDate;
@property (nonatomic, readonly) BOOL hasLowFloorAccess;

- (BOOL)isEqualToDepature:(LJSDepature *)depature;

@end
