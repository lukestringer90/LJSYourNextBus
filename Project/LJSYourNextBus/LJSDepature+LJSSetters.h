//
//  LJSDepature+LJSSetters.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 22/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSDepature.h"

@class LJSService;
@interface LJSDepature (LJSSetters)

- (void)setService:(LJSService *)service;
- (void)setDestination:(NSString *)destination;
- (void)setExpectedDepatureDate:(NSDate *)expectedDepatureDate;
- (void)setHasLowFloorAccess:(BOOL) hasLowFloorAccess;

@end
