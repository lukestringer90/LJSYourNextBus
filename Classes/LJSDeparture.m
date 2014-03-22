//
//  LJSDeparture.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 29/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSDeparture.h"
#import "LJSService.h"

@interface LJSDeparture ()
@property (nonatomic, strong, readwrite) LJSService *service;
@property (nonatomic, copy, readwrite) NSString *destination;
@property (nonatomic, strong, readwrite) NSDate *expectedDepartureDate;
@property (nonatomic, assign, readwrite) BOOL hasLowFloorAccess;
@end

@implementation LJSDeparture

- (instancetype)copyWithZone:(NSZone *)zone {
	LJSDeparture *copy = [[LJSDeparture allocWithZone:zone] init];
	copy.service = self.service;
	copy.destination = self.destination;
	copy.expectedDepartureDate = self.expectedDepartureDate;
	copy.hasLowFloorAccess = self.hasLowFloorAccess;
	return copy;
}

- (BOOL)isEqualToDeparture:(LJSDeparture *)Departure {
	BOOL servicesEqual = [self.service isEqualToService:Departure.service] || (self.service == nil && Departure.service == nil);
	BOOL datesEqual = [self.expectedDepartureDate isEqualToDate:Departure.expectedDepartureDate];
	BOOL destinationsEqual = [self.destination isEqualToString:Departure.destination];
	BOOL lowFloorAccessEqual = self.hasLowFloorAccess == Departure.hasLowFloorAccess;
	
	return servicesEqual && datesEqual && destinationsEqual && lowFloorAccessEqual;
}

- (BOOL)isEqual:(id)object {
	if (self == object) {
		return YES;
	}
	
	if (![object isKindOfClass:[LJSDeparture class]]) {
		return NO;
	}
	
	return [self isEqualToDeparture:object];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Destination: %@ - Service: %@ - Expected Departure Date: %@ - Has Low Floor Acces: %@", self.destination,self.service.title,  self.expectedDepartureDate, self.hasLowFloorAccess ? @"YES" : @"NO"];
}

@end
