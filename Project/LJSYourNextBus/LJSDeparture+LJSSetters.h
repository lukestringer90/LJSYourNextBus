//
//  LJSDeparture+LJSSetters.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 22/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSDeparture.h"

@class LJSService;
@interface LJSDeparture (LJSSetters)

- (void)setService:(LJSService *)service;
- (void)setDestination:(NSString *)destination;
- (void)setExpectedDepartureDate:(NSDate *)expectedDepartureDate;
- (void)setCountdownString:(NSString *)countdownString;
- (void)setHasLowFloorAccess:(BOOL) hasLowFloorAccess;

@end
