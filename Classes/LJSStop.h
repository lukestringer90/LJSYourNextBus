//
//  LJSStop.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 29/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LJSStop;
@protocol LJSServicesProvider <NSObject>

- (NSArray *)provideServicesForStop:(LJSStop *)stop;

@end

/**
 *  A Stop represents the successful parsing of live departure data from HTML. It is the root of the live data hierarchy and has a list of Services each of which have a list of Departures for the next hour. A Stop should only be considered relevant for no longer than 60 seconds.
 */
@interface LJSStop : NSObject <NSCopying>

/**
 *  An 8 digit number identifying a the Stop as a "National Public Transport Access Nodes". See here for more information: https://www.gov.uk/government/publications/national-public-transport-access-node-schema
 */
@property (nonatomic, copy, readonly) NSString *NaPTANCode;

/**
 *  The common title for the Stop as displayed on the sign post. e.g. "Sheffield Interchange"
 */
@property (nonatomic, copy, readonly) NSString *title;

/**
 *  The date on which the Stop was created from the live data source.
 */
@property (nonatomic, copy, readonly) NSDate *liveDate;

/**
 *  URL to the HTML page where later departure times (between +1 and +2 hours from now) can be found.
 */
@property (nonatomic, strong, readonly) NSURL *laterURL;
/**
 *  URL to the HTML page where earlier departure times (between -1 and 0 hours from now) can be found.
 */
@property (nonatomic, strong, readonly) NSURL *earlierURL;

/**
 *  A list of LJSService objects detailing which services are departing from the Stop within the next hour. Or nil if there are no departure in the next hour.
 */
@property (nonatomic, copy, readonly, nullable) NSArray *services;


/**
 *  Test equality with another Stop.
 *
 *  @param stop The other Stop to test for equality.
 *
 *  @return YES if the NaPTAN codes are equal and all the Services and Departures are also equal. Otherwise NO.
 */
- (BOOL)isEqualToStop:(LJSStop *)stop;

/**
 *  Sorts all the Departures for all the Services for the Stop  by expected departure date.
 *
 *  @return All the Departures for all the Services for the Stop, sorted by expected departure date.
 */
- (NSArray *)sortedDepartures;

/**
 *  JSON representation of the Stop.
 *
 *  @return JSON representation of the Stop.
 */
- (NSDictionary *)JSONRepresentation;

- (instancetype)initWithNaPTANCode:(NSString *)NaPTANCode title:(NSString *)title liveDate:(NSDate *)liveDate laterURL:(NSURL *)laterURL earlierURL:(NSURL *)earlierURL servicesProvider:(id <LJSServicesProvider>)servicesProvider;

NS_ASSUME_NONNULL_END

@end
