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

- (instancetype)copyWithZone:(NSZone *)zone {
	LJSService *copy = [[LJSService allocWithZone:zone] init];
	copy.stop = self.stop;
	copy.title = self.title;
	copy.departures = self.departures;
	return copy;
}

- (BOOL)isEqualToService:(LJSService *)service {
	BOOL stopsEqual = [self.stop isEqualToStop:service.stop] || (self.stop == nil && service.stop == nil);
	BOOL titlesEqual = [self.title isEqualToString:service.title];
	return stopsEqual && titlesEqual && [self allDeparturesEqualWithService:service];
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

- (BOOL)allDeparturesEqualWithService:(LJSService *)service {
	NSSet *departuresA = [NSSet setWithArray:self.departures];
	NSSet *departuresB = [NSSet setWithArray:service.departures];
	return [departuresA isEqualToSet:departuresB];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Title: %@ - Stop: %@ - Departures: %ld", self.title, self.stop.title, (unsigned long)self.departures.count];
}


@end