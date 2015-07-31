//
//  LJSLiveDataResult.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 31/07/2015.
//  Copyright (c) 2015 Luke Stringer. All rights reserved.
//

#import "LJSLiveDataResult.h"

@interface LJSLiveDataResult ()
@property (nonatomic, strong, readwrite) NSString *NaPTANCode;
@property (nonatomic, strong, readwrite) LJSStop *stop;
@property (nonatomic, copy, readwrite) NSArray *messages;
@end

@implementation LJSLiveDataResult

- (instancetype)initWithNaPTANCode:(NSString *)NaPTANCode stop:(LJSStop *)stop messages:(NSArray *)messages
{
	if (self = [super init]) {
		self.NaPTANCode = NaPTANCode;
		self.stop = stop;
		self.messages = messages;
	}
	return self;
}

@end
