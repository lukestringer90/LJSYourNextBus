//
//  LJSService.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 29/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSService.h"
#import "LJSStop.h"
#import "LJSDepature.h"

@interface LJSService ()
@property (nonatomic, strong, readwrite) LJSStop *stop;
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSArray *depatures;
@end

@implementation LJSService

- (instancetype)copyWithZone:(NSZone *)zone {
	LJSService *copy = [[LJSService allocWithZone:zone] init];
	copy.stop = self.stop;
	copy.title = self.title;
	copy.depatures = self.depatures;
	return copy;
}

- (BOOL)isEqualToService:(LJSService *)service {
	BOOL stopsEqual = [self.stop isEqualToStop:service.stop] || (self.stop == nil && service.stop == nil);
	BOOL titlesEqual = [self.title isEqualToString:service.title];
	return stopsEqual && titlesEqual && [self allDepaturesEqualWithService:service];
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

- (BOOL)allDepaturesEqualWithService:(LJSService *)service {
	NSSet *depaturesA = [NSSet setWithArray:self.depatures];
	NSSet *depaturesB = [NSSet setWithArray:service.depatures];
	return [depaturesA isEqualToSet:depaturesB];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Title: %@ - Stop: %@ - Depatures: %ld", self.title, self.stop.title, self.depatures.count];
}


@end