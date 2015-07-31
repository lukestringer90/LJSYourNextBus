//
//  LJSDepartureBuilder.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 30/07/2015.
//  Copyright (c) 2015 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJSServiceBuilder.h"

@interface LJSDepartureBuilder : NSObject <LJSDepartureBuilder>

@property (nonatomic, strong, readwrite) LJSService *service;
@property (nonatomic, copy, readwrite) NSString *destination;
@property (nonatomic, strong, readwrite) NSDate *expectedDepartureDate;
@property (nonatomic, copy, readwrite) NSString *countdownString;
@property (nonatomic, assign, readwrite) NSInteger minutesUntilDeparture;
@property (nonatomic, assign, readwrite) BOOL hasLowFloorAccess;

@end
