//
//  LJSTravelSouthYorkshire.h
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 04/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJSTravelSouthYorkshire : NSObject

- (void)depatureDataForNaPTANCode:(NSString *)NaPTANCode completion:(void (^)(NSDictionary *data, NSURL *nextPageURL, NSError *error))completion;
- (void)depatureDataAtURL:(NSURL *)url completion:(void (^)(id json, NSURL *laterDepaturesURL, NSError *))completion;

- (NSURL *)urlForStopNumber:(NSString *)stopNumber;

@end
