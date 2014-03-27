//
//  LJSYourNextBusClient.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 04/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Domain for errors from LJSYourNextBusClient.
 */
extern NSString * const LJSYourNextBusErrorDomain;

/**
 *  LJSYourNextBusClient related error codes.
 */
typedef NS_ENUM(NSInteger, LJSYourNextBusError) {
	/**
	 *  Returned when the downloaded HTML is not of a form that can be scraped for live data.
	 */
	LJSYourNextBusErrorScrapeFailure,
	/**
	 *  Returned when the downloaded HTML is of the correct form but contains no live data.
	 */
	LJSYourNextBusErrorDataUnavaiable
};

@class LJSStop;

@interface LJSYourNextBusClient : NSObject

@property (nonatomic, assign) BOOL saveDataToDisk;

typedef void (^LJSLiveDataCompletion)(LJSStop *stop, NSArray *messages, NSError *error);

- (void)liveDataForNaPTANCode:(NSString *)NaPTANCode completion:(LJSLiveDataCompletion)completion;

- (void)liveDataAtURL:(NSURL *)url completion:(LJSLiveDataCompletion)completion;
- (void)refreshStop:(LJSStop *)stop completion:(LJSLiveDataCompletion)completion;

- (NSURL *)urlForNaPTANCode:(NSString *)stopNumber;

@end