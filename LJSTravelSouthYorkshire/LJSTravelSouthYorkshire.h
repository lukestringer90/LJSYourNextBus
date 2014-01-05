//
//  LJSTravelSouthYorkshire.h
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 04/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJSTravelSouthYorkshire : NSObject

- (void)requestDepatureDataForStopNumber:(NSString *)stopNumber completion:(void (^)(id json, NSURL *nextPageURL, NSError *error))completion;

- (void)requestDepatureDataAtURL:(NSURL *)url completion:(void (^)(id json, NSURL *nextPageURL, NSError *))completion;

- (NSURL *)urlForStopNumber:(NSString *)stopNumber;

@end
