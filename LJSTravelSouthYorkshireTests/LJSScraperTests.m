//
//  LJSScraperTests.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 08/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LJSScraper.h"

@interface LJSScraperTests : XCTestCase {
    LJSScraper *_sut;
    NSDictionary *_correctData;
}
@end

@implementation LJSScraperTests

#pragma mark - setUp / tearDown

- (void)setUp {
    [super setUp];
    _sut = [[LJSScraper alloc] init];
    _correctData = [self loadJSONFileNamed:@"tram"];
}

#pragma mark - Helpers

- (NSDictionary *)loadJSONFileNamed:(NSString *)fileName {
    NSString* filepath = [[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filepath];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (NSString *)loadHTMLFileNamed:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType: @"html"];
    return [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
}

#pragma mark - Tests

- (void)testScapesDepatures {
    
    NSDictionary *correctDepatures = _correctData[LJSDepaturesKey];
    NSString *html = [self loadHTMLFileNamed:@"tram"];
    
    NSDictionary *scrapedData = [_sut scrapeDepatureDataFromHTML:html];
    NSDictionary *scrapedDepatures = scrapedData[LJSDepaturesKey];
    
    XCTAssertEqualObjects(scrapedDepatures, correctDepatures, @"");
}

- (void)testScrapesNaPTANCode {
    
    NSString *correctNaPTANCode = _correctData[LJSNaPTANCodeKey];
    NSString *html = [self loadHTMLFileNamed:@"tram"];
    
    NSDictionary *scrapedData = [_sut scrapeDepatureDataFromHTML:html];
    NSString *scrapedNaPTANCode = scrapedData[LJSNaPTANCodeKey];
    
    XCTAssertEqualObjects(scrapedNaPTANCode, correctNaPTANCode, @"");
}

- (void)testScrapesStopName {
    
    NSString *correctStopName = _correctData[LJSStopNameKey];
    NSString *html = [self loadHTMLFileNamed:@"tram"];
    
    NSDictionary *scrapedData = [_sut scrapeDepatureDataFromHTML:html];
    NSString *scrapedStopName = scrapedData[LJSStopNameKey  ];
    
    XCTAssertEqualObjects(scrapedStopName, correctStopName, @"");
}

- (void)testScrapesLiveInformationDate {
    
    NSString *correctLiveDate = _correctData[LJSLiveDateKey];
    NSString *html = [self loadHTMLFileNamed:@"tram"];
    
    NSDictionary *scrapedData = [_sut scrapeDepatureDataFromHTML:html];
    NSString *scrapedLiveDate = scrapedData[LJSLiveDateKey  ];
    
    XCTAssertEqualObjects(scrapedLiveDate, correctLiveDate, @"");
}

- (void)testReturnsNoDepatureData {
    // TODO: No depature table in HTML
}

- (void)testInstantiatesError {
    // TODO: Malformed HTML
}

- (void)testScrpaesNextPageURL {
    // TODO: Valid nextPageURL in HTML
}

- (void)testReturnsNoNextPageURL {
    // TODO: No nextPageURL in HTML
}

@end
