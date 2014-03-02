//
//  LJSService.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 29/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSService.h"
#import "LJSStop.h"

@implementation LJSService

- (BOOL)isEqualToService:(LJSService *)service {
	return [self.stop isEqualToStop:service.stop] && [self.title isEqualToString:service.title];
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
	return [NSString stringWithFormat:@"Title: %@ - Stop: %@ - Depatures: %ld", self.title, self.stop.title, self.depatures.count];
}

@end
