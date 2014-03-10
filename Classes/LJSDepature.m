//
//  LJSDepature.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 29/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSDepature.h"
#import "LJSService.h"

@implementation LJSDepature

- (BOOL)isEqualToDepature:(LJSDepature *)depature {
	BOOL servicesEqual = [self.service isEqualToService:depature.service] || (self.service == nil && depature.service == nil);
	BOOL datesEqual = [self.expectedDepatureDate isEqualToDate:depature.expectedDepatureDate];
	BOOL destinationsEqual = [self.destination isEqualToString:depature.destination];
	BOOL lowFloorAccessEqual = self.hasLowFloorAccess == depature.hasLowFloorAccess;
	
	return servicesEqual && datesEqual && destinationsEqual && lowFloorAccessEqual;
}

- (BOOL)isEqual:(id)object {
	if (self == object) {
		return YES;
	}
	
	if (![object isKindOfClass:[LJSDepature class]]) {
		return NO;
	}
	
	return [self isEqualToDepature:object];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Destination: %@ - Service: %@ - Expected Depature Date: %@ - Has Low Floor Acces: %@", self.destination,self.service.title,  self.expectedDepatureDate, self.hasLowFloorAccess ? @"YES" : @"NO"];
}

@end
