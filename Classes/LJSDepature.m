//
//  LJSDepature.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 29/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSDepature.h"
#import "LJSService.h"

@implementation LJSDepature

- (NSString *)description {
	return [NSString stringWithFormat:@"Destination: %@ - Service: %@ - Expected Depature Date: %@ - Has Low Floor Acces: %@", self.destination,self.service.title,  self.expectedDepatureDate, self.hasLowFloorAccess ? @"YES" : @"NO"];
}

@end
