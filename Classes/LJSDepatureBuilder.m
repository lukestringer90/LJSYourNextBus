//
//  LJSDepatureBuilder.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 26/02/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSDepatureBuilder.h"

@implementation LJSDepatureBuilder

- (LJSDepature *)depature {
	return [[LJSDepature alloc] init];
}

@end

@interface LJSDepature () {
    LJSService *_service;
	NSString *_destination;
	NSDate *_expectedDepatureDate;
	BOOL _hasLowFloorAccess;
}
@end

@implementation LJSDepature (LJSBuilderAdditions)

- (LJSDepature *)withService:(LJSService *)service {
	_service = service;
	return self;
}

- (LJSDepature *)withDestination:(NSString *)destination {
	_destination = destination;
	return self;
}

- (LJSDepature *)withExpectedDepatureDate:(NSDate *)expectedDepatureDate {
	_expectedDepatureDate = expectedDepatureDate;
	return self;
}

- (LJSDepature *)withHasLowFloorAccess:(BOOL)hasLowFloorAccess {
	_hasLowFloorAccess = hasLowFloorAccess;
	return self;
}

@end
