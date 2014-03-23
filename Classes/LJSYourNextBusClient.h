//
//  LJSYourNextBusClient.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 04/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LJSYourNextBusErrorDomain;

typedef NS_ENUM(NSInteger, LJSYourNextBusError) {
    LJSYourNextBusErrorScrapeFailure,
	LJSYourNextBusErrorDataUnavaiable
};

@class LJSStop;
@interface LJSYourNextBusClient : NSObject

// TODO: Should return an array of messages. Need to find HTML with multiple messages.
typedef void (^LJSLiveDataCompletion)(LJSStop *stop, NSURL *laterURL, NSURL *earlierURL, NSString *message, NSError *error);

- (void)liveDataForNaPTANCode:(NSString *)NaPTANCode completion:(LJSLiveDataCompletion)completion;
- (void)liveDataAtURL:(NSURL *)url completion:(LJSLiveDataCompletion)completion;
- (NSURL *)urlForNaPTANCode:(NSString *)stopNumber;

@end
