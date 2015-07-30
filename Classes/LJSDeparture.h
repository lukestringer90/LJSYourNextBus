//
//  LJSDeparture.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 29/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LJSService;

/**
 *  A Departure is a point when a Service is to depart from a Stop.
 */
@interface LJSDeparture : NSObject

/**
 *  The Service that will to depart.
 */
@property (nonatomic, strong, readonly) LJSService *service;

/**
 *  The destination towards which the Service will head towards once departed. e.g. "Hillsborough", "Sheffield City Centre"
 */
@property (nonatomic, copy, readonly) NSString *destination;

/**
 *  The date at which the Service is expected to depart at.
 */
@property (nonatomic, strong, readonly) NSDate *expectedDepartureDate;

/**
 *  A convenience string representation of how long the Service will be until it departs. For departures dates less than a minute away "Due" is used. For departures dates equal to or more than a minute away "1 Min" or "n Mins" is used. For departure dates more than 20 minutes away the time is used, e.g. "14:55". For departures dates in the past "Departed" is used.
 */
@property (nonatomic, copy, readonly) NSString *countdownString;

/**
 *  The number of minutes until the Service is expected to depart.
 */
@property (nonatomic, assign, readonly) NSInteger minutesUntilDeparture;

/**
 *  YES if the departing Service supports low floor access: preferable for wheelchair users, people with walking difficulties, and for pushchairs.
 */
@property (nonatomic, assign, readonly) BOOL hasLowFloorAccess;

- (BOOL)isEqualToDeparture:(LJSDeparture *)Departure;

/**
 *  JSON representation of the Departure.
 *
 *  @return JSON representation of the Departure.
 */
- (NSDictionary *)JSONRepresentation;

- (instancetype)initWithDestination:(NSString *)destination expectedDepartureDate:(NSDate *)expectedDepartureDate countdownString:(NSString *)countdownString minutesUntilDeparture:(NSInteger)minutesUntilDeparture hasLowFloorAccess:(BOOL)hasLowFloorAccess service:(LJSService *)service;

@end
