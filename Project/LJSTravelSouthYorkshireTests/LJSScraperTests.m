//
//  LJSScraperTests.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 02/02/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "LJSScraper.h"
#import "LJSStop.h"

@interface LJSScraperTests : XCTestCase {
    LJSScraper *_sut;
    NSDictionary *_correctData;
    NSString *_html;
}
@end

@implementation LJSScraperTests

#pragma mark - setUp / tearDown

- (void)setUp {
    [super setUp];
    _sut = [[LJSScraper alloc] init];
    _html = [self loadHTMLFileNamed:@"37010071"];
}

#pragma mark - Helpers

- (NSDictionary *)loadJSONFileNamed:(NSString *)fileName {
    NSString *path = [self pathInTestBundleForResource:fileName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (NSString *)loadHTMLFileNamed:(NSString *)fileName {
    NSString *path = [self pathInTestBundleForResource:fileName ofType:@"html"];
    return [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
}

- (NSString *)pathInTestBundleForResource:(NSString *)name ofType:(NSString *)extension {
    return [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:extension];
}

#pragma mark - Tests

- (void)testStopDetails {
    LJSStop *stop = [_sut scrapeStopDataFromHTML:_html];
	
	assertThat(stop.NaPTANCode, equalTo(@"37010071"));
	assertThat(stop.title, equalTo(@"Rotherham Intc"));
}

- (void)testServicesCount {
    LJSStop *stop = [_sut scrapeStopDataFromHTML:_html];
    NSArray *services = stop.services;
	
	assertThat(services, hasCountOf(4));
}

- (void)testDepaturesCount {
	LJSStop *stop = [_sut scrapeStopDataFromHTML:_html];
    NSArray *services = stop.services;
	NSMutableArray *allDepatures = [[services valueForKeyPath:@"depatures"] valueForKeyPath:@"@unionOfArrays.self"];
	
	assertThat(allDepatures, hasCountOf(16));
}



@end
