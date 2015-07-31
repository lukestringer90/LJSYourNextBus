//
//  LJSServiceBuilder.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 30/07/2015.
//  Copyright (c) 2015 Luke Stringer. All rights reserved.
//

#import "LJSServiceBuilder.h"
#import "LJSService.h"

@implementation LJSServiceBuilder

- (LJSService *)buildForWithStop:(LJSStop *)stop
{
	return [[LJSService alloc] initWithTitle:self.title stop:stop departuresProvider:self];
}

- (NSArray *)departuresForService:(LJSService *)service
{
	if (self.departureBuilders.count == 0) {
		return nil;
	}
	
	NSMutableArray *departures = [NSMutableArray array];
	for (id <LJSDepartureBuilder>departudeBuilder in self.departureBuilders) {
		LJSDeparture *departure = [departudeBuilder buildForService:service];
		[departures addObject:departure];
	}
	
	return [NSArray arrayWithArray:departures];
}

@end
