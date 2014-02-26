//
//  LJSDepatureBuilder.h
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 26/02/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJSDepature.h"

@class LJSService;
@interface LJSDepatureBuilder : NSObject

- (LJSDepature *)depature;

@end

@interface LJSDepature (LJSBuilderAdditions)

- (LJSDepature *)withService:(LJSService *)service;
- (LJSDepature *)withDestination:(NSString *)destination;
- (LJSDepature *)withExpectedDepatureDate:(NSDate *)expectedDepatureDate;
- (LJSDepature *)withHasLowFloorAccess:(BOOL)hasLowFloorAccess;

@end
