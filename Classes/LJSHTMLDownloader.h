//
//  LJSHTMLDownloader.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 05/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJSHTMLDownloader : NSObject

- (NSString *)downloadHTMLFromURL:(NSURL *)url error:(NSError **)error;

@end
