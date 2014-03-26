//
//  LJSDeparture.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 29/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LJSService;
@interface LJSDeparture : NSObject

@property (nonatomic, strong, readonly) LJSService *service;
@property (nonatomic, copy, readonly) NSString *destination;
@property (nonatomic, strong, readonly) NSDate *expectedDepartureDate;
@property (nonatomic, copy, readonly) NSString *countdownString;
@property (nonatomic, assign, readonly) NSInteger minutesUntilDeparture;
@property (nonatomic, assign, readonly) BOOL hasLowFloorAccess;

- (BOOL)isEqualToDeparture:(LJSDeparture *)Departure;
- (NSDictionary *)JSONRepresentation;

@end
