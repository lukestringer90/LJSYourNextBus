//
//  LJSService+LJSSetters.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 22/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSService.h"

@class LJSStop;
@interface LJSService (LJSSetters)

- (void)setStop:(LJSStop *)stop;
- (void)setTitle:(NSString *)title;
- (void)setDepartures:(NSArray *)departures;

@end
