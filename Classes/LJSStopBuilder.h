//
//  LJSStopBuilder.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 30/07/2015.
//  Copyright (c) 2015 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJSStop.h"

@class LJSService;
@protocol LJSServiceBuilder <NSObject>

- (LJSService *)buildForWithStop:(LJSStop *)stop;

@end

@interface LJSStopBuilder : NSObject <LJSServicesProvider>

@property (nonatomic, copy, readwrite) NSString *NaPTANCode;
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSDate *liveDate;
@property (nonatomic, strong, readwrite) NSURL *laterURL;
@property (nonatomic, strong, readwrite) NSURL *earlierURL;

@property (nonatomic, copy, readwrite) NSArray *serviceBuilders;

- (LJSStop *)build;

@end
