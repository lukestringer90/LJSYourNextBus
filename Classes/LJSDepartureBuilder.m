//
//  LJSDepartureBuilder.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 30/07/2015.
//  Copyright (c) 2015 Luke Stringer. All rights reserved.
//

#import "LJSDepartureBuilder.h"
#import "LJSDeparture.h"

@implementation LJSDepartureBuilder

- (LJSDeparture *)buildForService:(LJSService *)service
{
	return [[LJSDeparture alloc] initWithDestination:self.destination
							   expectedDepartureDate:self.expectedDepartureDate
									 countdownString:self.countdownString
							   minutesUntilDeparture:self.minutesUntilDeparture
								   hasLowFloorAccess:self.hasLowFloorAccess
											 service:service];
}

@end
