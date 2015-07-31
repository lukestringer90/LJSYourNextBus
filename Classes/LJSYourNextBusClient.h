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

@class LJSYourNextBusClient, LJSStop;
@protocol LJSYourNextBusClientDelegate <NSObject>

/**
 *  Delegate callback when the client has successfully obtained live data.
 *
 *  @param client   The Your Next Bus client that has obtained data.
 *  @param stop     A Stop object representing the live data.
 *  @param messages A list of messages for the stop live data containing meta information about the stop such as warnings or alerts. Or nil if their are no messages.
 */
- (void)client:(LJSYourNextBusClient *)client returnedStop:(LJSStop *)stop messages:(NSArray *)messages;

/**
 *  Delegate callback when the client has failed to obtained live data.
 *
 *  @param client     The Your Next Bus client that has failed.
 *  @param error      An error detailing the reason for the failure.
 *  @param NaPTANCode The NaPTAN code of the stop for which the original request to get live data was made for.
 */
- (void)client:(LJSYourNextBusClient *)client failedWithError:(NSError *)error NaPTANCode:(NSString *)NaPTANCode;

@end

@protocol LJSYourNextBusScrapeDelegate <NSObject>

/**
 *  Delegate callback when the client has successfully download the HTML for a NaPTAN code and is about to scrape it for live data.
 *
 *  @param client     The Your Next Bus client that will scrape.
 *  @param HTML       The HTML that will be scraped.
 *  @param NaPTANCode The NaPTAN code of the stop that the HTML has been obtained for.
 */
- (void)client:(LJSYourNextBusClient *)client willScrapeHTML:(NSString *)HTML NaPTANCode:(NSString *)NaPTANCode;

@end

/**
 *  Use a Your Next Bus Client subclass to get live data for particular stop (specified with a NapTAN code) in a particular region.
 */
@interface LJSYourNextBusClient : NSObject

/**
 *  Delegate to get client callbacks.
 */
@property (nonatomic, weak) id<LJSYourNextBusClientDelegate> clientDelegate;

/**
 *  Delegate to get scrape callbacks.
 */
@property (nonatomic, weak) id<LJSYourNextBusScrapeDelegate> scrapeDelegate;


/**
 *  Asynchronously get live data for a stop as sepcified by a NaPTAN code. NOTE: only one live data requests can be active at a time.
 *
 *  @param NaPTANCode The NaPTAN code of the stop to get live data for. For more information see `LJSStop`.
 *
 *  @return YES if the requests for live data was started. NO if the request was not started due to previous request being still active.
 */
- (BOOL)getLiveDataForNaPTANCode:(NSString *)NaPTANCode;

/**
 *  YES if a request to get live data is being performed. NO if client is idle and no requests are being perofmed.
 */
@property (nonatomic, assign, readonly, getter=isGettingLiveData) BOOL gettingLiveData;

/**
 *  Construct a URL to the web page where the live data is located for a NaPTAN code. Must be overriden in a subclass to construct the correct form of URL for a specific region.
 *
 *  @param stopNumber The NaPTAN code of the stop to get live data for.
 *
 *  @return A URL to the web page where live data is location for a stop in a specific region.
 */
- (NSURL *)urlForNaPTANCode:(NSString *)stopNumber;

@end