//
//  LJSStop.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 29/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSStop.h"

@implementation LJSStop

- (BOOL)isEqualToStop:(LJSStop *)stop {
    return [self.NaPTANCode isEqualToString:stop.NaPTANCode];
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


- (NSUInteger)hash {
    return [self.NaPTANCode hash];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Title: %@ - NaPTAN Code: %@ - Live Date : %@ - Services: %ld", self.title, self.NaPTANCode, self.liveDate, (unsigned long)self.services.count];
}

@end
