//
//  LJSStop.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 29/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSStop.h"

@implementation LJSStop

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


- (NSUInteger)hash {
    return [self.NaPTANCode hash];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Title: %@ - NaPTAN Code: %@ - Live Date : %@ - Services: %ld", self.title, self.NaPTANCode, self.liveDate, (unsigned long)self.services.count];
}

@end
