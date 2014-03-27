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
@property (nonatomic, copy, readwrite) NSString *countdownString;
@property (nonatomic, assign, readwrite) NSInteger minutesUntilDeparture;
@property (nonatomic, assign, readwrite) BOOL hasLowFloorAccess;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation LJSDeparture

- (instancetype)copyWithZone:(NSZone *)zone {
	LJSDeparture *copy = [[LJSDeparture allocWithZone:zone] init];
	copy.service = self.service;
	copy.destination = self.destination;
	copy.expectedDepartureDate = self.expectedDepartureDate;
	copy.countdownString = self.countdownString;
	copy.hasLowFloorAccess = self.hasLowFloorAccess;
	copy.minutesUntilDeparture = self.minutesUntilDeparture;
	return copy;
}

- (BOOL)isEqualToDeparture:(LJSDeparture *)departure {
	BOOL datesEqual = [self.expectedDepartureDate isEqualToDate:departure.expectedDepartureDate];
	BOOL dateStringsEqual = [self.countdownString isEqualToString:departure.countdownString];
	BOOL destinationsEqual = [self.destination isEqualToString:departure.destination];
	BOOL lowFloorAccessEqual = self.hasLowFloorAccess == departure.hasLowFloorAccess;
	BOOL minutesEqual = self.minutesUntilDeparture == departure.minutesUntilDeparture;
	
	return datesEqual && dateStringsEqual && destinationsEqual && lowFloorAccessEqual && minutesEqual;
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
	return [NSString stringWithFormat:@"Service: %@ %@ - Expected Departure Date: %@ - Has Low Floor Acces: %@", self.service.title, self.destination, self.countdownString, self.hasLowFloorAccess ? @"YES" : @"NO"];
}

- (NSDictionary *)JSONRepresentation {
	NSString *expectedDepartureDateString = [self.dateFormatter stringFromDate:self.expectedDepartureDate];
	
	return @{
			 @"destination" : self.destination != nil ? self.destination : [NSNull null],
			 @"countdownString" : self.countdownString != nil ? self.countdownString : [NSNull null],
			 @"expectedDepartureDate" : expectedDepartureDateString != nil ? expectedDepartureDateString : [NSNull null],
			 @"hasLowFloorAccess" : @(self.hasLowFloorAccess),
			 @"minutesUntilDeparture" : @(self.minutesUntilDeparture)
			 };
}

- (NSDateFormatter *)dateFormatter {
	if (!_dateFormatter) {
		_dateFormatter = [[NSDateFormatter alloc] init];
		_dateFormatter.dateStyle = NSDateFormatterShortStyle;
		_dateFormatter.timeStyle = NSDateFormatterShortStyle;
	}
	return _dateFormatter;
}

@end
