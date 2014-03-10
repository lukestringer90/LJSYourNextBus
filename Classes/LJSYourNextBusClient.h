//
//  LJSYourNextBusClient.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 04/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LJSNaPTANCodeKey;
extern NSString * const LJSStopNameKey;
extern NSString * const LJSDepaturesKey;
extern NSString * const LJSDestinationKey;
extern NSString * const LJSExpectedDepatureTimeKey;
extern NSString * const LJSLiveTimeKey;
extern NSString * const LJSLowFloorAccess;

@interface LJSYourNextBusClient : NSObject

typedef void (^LJSLiveDataCompletion)(NSDictionary *depatureData, NSURL *laterURL, NSURL *earlierURL, NSError *error);

- (void)liveDataForNaPTANCode:(NSString *)NaPTANCode completion:(LJSLiveDataCompletion)completion;
- (void)liveDataAtURL:(NSURL *)url completion:(LJSLiveDataCompletion)completion;
- (NSURL *)urlForNaPTANCode:(NSString *)stopNumber;

@end
