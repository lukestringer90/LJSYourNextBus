//
//  LJSStop.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 29/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSStop.h"

@interface LJSStop ()
@property (nonatomic, copy, readwrite) NSString *NaPTANCode;
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSDate *liveDate;
@property (nonatomic, copy, readwrite) NSArray *services;
@end

@implementation LJSStop

- (instancetype)copyWithZone:(NSZone *)zone {
	LJSStop *copy = [[LJSStop allocWithZone:zone] init];
	copy.NaPTANCode = self.NaPTANCode;
	copy.title = self.title;
	copy.liveDate = self.liveDate;
	copy.services = self.services;
	return copy;
}

- (BOOL)isEqualToStop:(LJSStop *)stop {
    return [self.NaPTANCode isEqualToString:stop.NaPTANCode] && [self allServicesEqualWithStop:stop];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[LJSStop class]]) {
        return NO;
    }
    
    return [self isEqualToStop:(LJSStop *)object];
}

- (BOOL)allServicesEqualWithStop:(LJSStop *)stop {
	NSSet *servicesA = [NSSet setWithArray:self.services];
	NSSet *servicesB = [NSSet setWithArray:stop.services];
	return [servicesA isEqualToSet:servicesB];
}



- (NSString *)description {
	return [NSString stringWithFormat:@"Title: %@ - NaPTAN Code: %@ - Live Date : %@ - Services: %ld", self.title, self.NaPTANCode, self.liveDate, (unsigned long)self.services.count];
}

@end
