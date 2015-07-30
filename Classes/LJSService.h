//
//  LJSService.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 29/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LJSService;
@protocol LJSDeparturesProvider <NSObject>

- (NSArray *)departuresForService:(LJSService *)service;

@end

@class LJSStop;

/**
 *  A Service departs from a Stop.
 */
@interface LJSService : NSObject <NSCopying>

/**
 *  The Stop the Service will departure from.
 */
@property (nonatomic, strong, readonly) LJSStop *stop;

/**
 *  The common title for the service. e.g. "82", "SL2", "YELLOW"
 */
@property (nonatomic, copy, readonly) NSString *title;

/**
 *  A list of Departures detailing when the Service is departing from the Stop.
 */
@property (nonatomic, copy, readonly) NSArray *departures;

- (BOOL)isEqualToService:(LJSService *)service;

/**
 *  JSON representation of the Service.
 *
 *  @return JSON representation of the Service.
 */
- (NSDictionary *)JSONRepresentation;

- (instancetype)initWithTitle:(NSString *)title stop:(LJSStop *)stop departuresProvider:(id <LJSDeparturesProvider>)departuresProvider;

@end
