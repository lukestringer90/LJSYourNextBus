//
//  LJSLiveDataResult.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 31/07/2015.
//  Copyright (c) 2015 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LJSStop;

/**
 *  A Live Data Result object represents the successful parsing of HTML by a Your Next Bus client. A client can finish successfully with a Stop (representing the departures for the next hour) and no messages. A client can also finish with no Stop (when there are no departure) but still generate an array of messages (representing meta information such as warnings). Finally a client can finish with both a Stop and an array of messages.
 */
@interface LJSLiveDataResult : NSObject

/**
 *  NaPTAN code of the original request to get live data.
 */
@property (nonatomic, strong, readonly) NSString *NaPTANCode;

/**
 *  The Stop representing the successful parsing of live departure data from HTML. Or nil if the HTML did not contain any data.
 */
@property (nonatomic, strong, readonly, nullable) LJSStop *stop;

/**
 *  An array of messages representing meta information such as warnings. Or nil if the HTML did not contain any data.
 */
@property (nonatomic, copy, readonly, nullable) NSArray *messages;

- (instancetype)initWithNaPTANCode:(NSString *)NaPTANCode stop:(LJSStop * __nullable)stop messages:(NSArray * __nullable)messages;

NS_ASSUME_NONNULL_END

@end
