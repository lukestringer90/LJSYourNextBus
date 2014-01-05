//
//  LJSWebContentDownloader.h
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 05/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJSWebContentDownloader : NSObject

@property (nonatomic, readonly) NSURL *url;

- (instancetype)initWithURL:(NSURL *)url;

- (NSString *)downloadHTML:(NSError **)error;

@end
