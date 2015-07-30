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
	return [[LJSStop alloc] initWithNaPTANCode:self.NaPTANCode title:self.title liveDate:self.liveDate laterURL:self.laterURL earlierURL:self.earlierURL servicesProvider:self];
}

- (NSArray *)provideServicesForStop:(LJSStop *)stop
{
	return nil;
}

@end
