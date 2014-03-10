//
//  LJSService.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 29/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LJSStop;
@interface LJSService : NSObject

@property (nonatomic, readonly) LJSStop *stop;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSArray *depatures;

- (BOOL)isEqualToService:(LJSService *)service;

@end
