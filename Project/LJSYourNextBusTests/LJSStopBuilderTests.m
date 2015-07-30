//
//  LJSStopBuilder.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 30/07/2015.
//  Copyright (c) 2015 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LJSStopBuilder.h"

@interface LJSStopBuilderTests : XCTestCase

@end

@implementation LJSStopBuilderTests

- (void)testProperties {
	NSDate *currentDate = [NSDate date];
	
	LJSStopBuilder *builder = [LJSStopBuilder new];
	builder.title = @"Title";
	builder.NaPTANCode = @"1234";
	builder.liveDate = currentDate;
	builder.laterURL = [NSURL URLWithString:@"www.later.com"];
	builder.earlierURL = [NSURL URLWithString:@"www.earlier.com"];
	
	LJSStop *stop = [builder build];
	
	XCTAssertEqualObjects(stop.title, @"Title");
	XCTAssertEqualObjects(stop.NaPTANCode, @"1234");
	XCTAssertEqualObjects(stop.liveDate, currentDate);
	XCTAssertEqualObjects(stop.laterURL, [NSURL URLWithString:@"www.later.com"]);
	XCTAssertEqualObjects(stop.earlierURL, [NSURL URLWithString:@"www.earlier.com"]);
}


@end
