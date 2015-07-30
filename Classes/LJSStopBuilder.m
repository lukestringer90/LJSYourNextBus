//
//  LJSStopBuilder.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 30/07/2015.
//  Copyright (c) 2015 Luke Stringer. All rights reserved.
//

#import "LJSStopBuilder.h"

@implementation LJSStopBuilder

- (LJSStop *)build
{
	return [[LJSStop alloc] initWithNaPTANCode:self.NaPTANCode
										 title:self.title
									  liveDate:self.liveDate
									  laterURL:self.laterURL
									earlierURL:self.earlierURL
							  servicesProvider:self];
}

- (NSArray *)provideServicesForStop:(LJSStop *)stop
{
	NSMutableArray *services = [NSMutableArray array];
	for (id <LJSServiceBuilder> serviceBuilder in self.serviceBuilders) {
		LJSService *service = [serviceBuilder buildForWithStop:stop];
		[services addObject:service];
	}
	
	return [NSArray arrayWithArray:services];
}

@end
