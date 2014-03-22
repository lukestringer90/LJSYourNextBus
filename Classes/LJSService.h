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

@property (nonatomic, strong, readonly) LJSStop *stop;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSArray *depatures;

- (BOOL)isEqualToService:(LJSService *)service;

@end
