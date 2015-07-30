//
//  LJSStopBuilder.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 30/07/2015.
//  Copyright (c) 2015 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LJSStopBuilder.h"
#import <OCMock/OCMock.h>
#import "LJSService.h"

@interface LJSStopBuilderTests : XCTestCase
@property (nonatomic, strong) LJSStop *stop;
@property (nonatomic, strong) LJSStopBuilder *builder;
@end

@implementation LJSStopBuilderTests

- (void)setUp
{
	self.builder = [LJSStopBuilder new];
}

- (void)testProperties {
	// Given
	NSDate *currentDate = [NSDate date];
	self.builder.title = @"Title";
	self.builder.NaPTANCode = @"1234";
	self.builder.liveDate = currentDate;
	self.builder.laterURL = [NSURL URLWithString:@"www.later.com"];
	self.builder.earlierURL = [NSURL URLWithString:@"www.earlier.com"];
	
	// When
	self.stop = [self.builder build];
	
	// Then
	XCTAssertEqualObjects(self.stop.title, @"Title");
	XCTAssertEqualObjects(self.stop.NaPTANCode, @"1234");
	XCTAssertEqualObjects(self.stop.liveDate, currentDate);
	XCTAssertEqualObjects(self.stop.laterURL, [NSURL URLWithString:@"www.later.com"]);
	XCTAssertEqualObjects(self.stop.earlierURL, [NSURL URLWithString:@"www.earlier.com"]);
}

- (void)testServices {
	// Given
	id mockServiceBuilder = [OCMockObject niceMockForProtocol:@protocol(LJSServiceBuilder)];
	id mockService = [OCMockObject mockForClass:[LJSService class]];
	[[[mockServiceBuilder stub] andReturn:mockService] buildForWithStop:[OCMArg any]];
	self.builder.serviceBuilders = @[mockServiceBuilder];
	
	// When
	self.stop = [self.builder build];
	
	// Then
	[[mockServiceBuilder verify] buildForWithStop:self.stop];
	XCTAssertTrue([self.stop.services containsObject:mockService]);
}

@end
