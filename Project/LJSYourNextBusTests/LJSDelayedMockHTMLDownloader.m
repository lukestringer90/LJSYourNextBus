//
//  LJSDelayedMockHTMLDownloader.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 31/07/2015.
//  Copyright (c) 2015 Luke Stringer. All rights reserved.
//

#import "LJSDelayedMockHTMLDownloader.h"

@interface LJSDelayedMockHTMLDownloader ()

@property (nonatomic, assign) NSTimeInterval delay;

@end

@implementation LJSDelayedMockHTMLDownloader

- (instancetype)initWithHTML:(NSString *)HTML ID:(NSString *)ID delay:(NSTimeInterval)delay
{
	if (self = [super initWithHTML:HTML ID:ID]) {
		self.delay = delay;
	}
	return self;
}

- (NSString *)downloadHTMLFromURL:(NSURL *)url error:(NSError **)error
{
	[NSThread sleepForTimeInterval:self.delay];
	
	return [super downloadHTMLFromURL:url error:error];
}

@end
