//
//  LJSLiveDataResult.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 31/07/2015.
//  Copyright (c) 2015 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LJSStop;
@interface LJSLiveDataResult : NSObject

@property (nonatomic, strong, readonly) LJSStop *stop;
@property (nonatomic, copy, readonly) NSArray *messages;

- (instancetype)initWithStop:(LJSStop *)stop messages:(NSArray *)messages;

@end
