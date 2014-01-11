//
//  LJSTravelSouthYorkshire.h
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 04/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJSTravelSouthYorkshire : NSObject

typedef void (^LJSDepatureDataCompletion)(NSDictionary *depatureData, NSURL *laterURL, NSURL *earlierURL, NSError *error);

- (void)depatureDataForNaPTANCode:(NSString *)NaPTANCode completion:(LJSDepatureDataCompletion)completion;

- (void)depatureDataAtURL:(NSURL *)url completion:(LJSDepatureDataCompletion)completion;

- (NSURL *)urlForStopNumber:(NSString *)stopNumber;

@end
