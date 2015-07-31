//
//  LJSServiceBuilderTests.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 30/07/2015.
//  Copyright (c) 2015 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LJSServiceBuilder.h"
#import <OCMock/OCMock.h>
#import "LJSService.h"
#import "LJSDeparture.h"

@interface LJSServiceBuilderTests : XCTestCase
@property (nonatomic, strong) LJSServiceBuilder *builder;
@property (nonatomic, strong) id stopMock;
@end

@implementation LJSServiceBuilderTests

- (void)setUp
{
	self.builder = [LJSServiceBuilder new];
	self.stopMock = [OCMockObject niceMockForClass:[LJSStop class]];
}

- (void)testBuildsProperties {
	// Given
	self.builder.title = @"Title";
	
	// When
	LJSService *service = [self.builder buildForWithStop:self.stopMock];
	
	// Then
	XCTAssertEqualObjects(service.title, @"Title");
}


- (void)testBuildsDepartures {
	// Given
	id mockDepartureBuilder = [OCMockObject niceMockForProtocol:@protocol(LJSDepartureBuilder)];
	id mockDeparture = [OCMockObject mockForClass:[LJSDeparture class]];
	[[[mockDepartureBuilder stub] andReturn:mockDeparture] buildForService:[OCMArg any]];
	self.builder.departureBuilders = @[mockDepartureBuilder];
	
	// When
	LJSService *service = [self.builder buildForWithStop:self.stopMock];
	
	// Then
	[[mockDepartureBuilder verify] buildForService:service];
	XCTAssertTrue([service.departures containsObject:mockDeparture]);
}

@end
