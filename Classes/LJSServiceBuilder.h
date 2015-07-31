//
//  LJSServiceBuilder.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 30/07/2015.
//  Copyright (c) 2015 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJSStopBuilder.h"
#import "LJSService.h"

@class LJSDeparture, LJSService;
@protocol LJSDepartureBuilder <NSObject>

- (LJSDeparture *)buildForService:(LJSService *)service;

@end

@interface LJSServiceBuilder : NSObject <LJSServiceBuilder, LJSDeparturesProvider>

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSArray *departureBuilders;

@end
