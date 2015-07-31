//
//  LJSDelayedMockHTMLDownloader.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 31/07/2015.
//  Copyright (c) 2015 Luke Stringer. All rights reserved.
//

#import "LJSMockHTMLDownloader.h"

@interface LJSDelayedMockHTMLDownloader : LJSMockHTMLDownloader

- (instancetype)initWithHTML:(NSString *)HTML ID:(NSString *)ID delay:(NSTimeInterval)delay;

@end
