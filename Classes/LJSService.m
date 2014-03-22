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
@property (nonatomic, copy, readwrite) NSArray *Departures;
@end

@implementation LJSService

- (instancetype)copyWithZone:(NSZone *)zone {
	LJSService *copy = [[LJSService allocWithZone:zone] init];
	copy.stop = self.stop;
	copy.title = self.title;
	copy.Departures = self.Departures;
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
	NSSet *DeparturesA = [NSSet setWithArray:self.Departures];
	NSSet *DeparturesB = [NSSet setWithArray:service.Departures];
	return [DeparturesA isEqualToSet:DeparturesB];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Title: %@ - Stop: %@ - Departures: %ld", self.title, self.stop.title, (unsigned long)self.Departures.count];
}


@end