//
//  LJSService.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 29/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSService.h"
#import "LJSStop.h"
#import "LJSDeparture.h"

@interface LJSService ()
@property (nonatomic, strong, readwrite) LJSStop *stop;
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSArray *departures;
@end

@implementation LJSService

- (instancetype)initWithTitle:(NSString *)title stop:(LJSStop *)stop departuresProvider:(id <LJSDeparturesProvider>)departuresProvider
{
	if (self = [super init]) {
		self.title = title;
		self.stop = stop;
		self.departures = [departuresProvider departuresForService:self];
	}
	return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
	LJSService *copy = [[LJSService allocWithZone:zone] init];
	copy.stop = self.stop;
	copy.title = self.title;
	copy.departures = self.departures;
	return copy;
}

- (BOOL)isEqualToService:(LJSService *)service {
	BOOL titlesEqual = [self.title isEqualToString:service.title];
	BOOL departuresEqual = [self.departures isEqualToArray:service.departures] || (self.departures.count == 0 && service.departures.count == 0);
	return titlesEqual && departuresEqual;
}

- (BOOL)isEqual:(id)object {
	if (self == object) {
		return YES;
	}
	
	if (![object isKindOfClass:[LJSService class]]) {
		return NO;
	}
	
	return [self isEqualToService:object];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"Title: %@ - Stop: %@ - Departures: %ld", self.title, self.stop.title, (unsigned long)self.departures.count];
}

- (NSDictionary *)JSONRepresentation {
	NSArray *departuresJSON = [NSArray array];
	for (LJSDeparture *departure in self.departures) {
		departuresJSON = [departuresJSON arrayByAddingObject:[departure JSONRepresentation]];
	}
	
	return @{
			 @"title" : self.title != nil ? self.title : [NSNull null],
			 @"departures" : departuresJSON
			 };
}

@end