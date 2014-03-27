//
//  LJSMockHTMLDownloader.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 27/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSMockHTMLDownloader.h"

@implementation LJSMockHTMLDownloader

- (instancetype)initWithHTML:(NSString *)HTML ID:(NSString *)ID {
	self = [super init];
	if (self) {
		self.HTML = HTML;
		self.ID = ID;
	}
	return self;
}

- (NSString *)downloadHTMLFromURL:(NSURL *)url error:(NSError **)error {
	return self.HTML;
}

@end
