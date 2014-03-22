//
//  LJSService.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 29/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LJSStop;
@interface LJSService : NSObject <NSCopying>

@property (nonatomic, strong, readonly) LJSStop *stop;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSArray *Departures;

- (BOOL)isEqualToService:(LJSService *)service;

@end
