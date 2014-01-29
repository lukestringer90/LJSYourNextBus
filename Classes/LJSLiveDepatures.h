//
//  LJSTravelSouthYorkshire.h
//  LJSTravelSouthYorkshire
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

@interface LJSLiveDepatures : NSObject

typedef void (^LJSDepatureDataCompletion)(NSDictionary *depatureData, NSURL *laterURL, NSURL *earlierURL, NSError *error);

- (void)depatureDataForNaPTANCode:(NSString *)NaPTANCode completion:(LJSDepatureDataCompletion)completion;
- (void)depatureDataAtURL:(NSURL *)url completion:(LJSDepatureDataCompletion)completion;
- (NSURL *)urlForNaPTANCode:(NSString *)stopNumber;

@end
