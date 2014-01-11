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
    NSString *_html;
}
@end

@implementation LJSScraperTests

#pragma mark - setUp / tearDown

- (void)setUp {
    [super setUp];
    _sut = [[LJSScraper alloc] init];
    _correctData = [self loadJSONFileNamed:@"malin_bridge_tram"];
    _html = [self loadHTMLFileNamed:@"malin_bridge_tram"];
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

- (void)testScapesDepatures {
    NSDictionary *correctDepatures = _correctData[LJSDepaturesKey];
    
    NSDictionary *scrapedData = [_sut scrapeDepatureDataFromHTML:_html];
    NSDictionary *scrapedDepatures = scrapedData[LJSDepaturesKey];
    
    XCTAssertEqualObjects(scrapedDepatures, correctDepatures, @"");
}

- (void)testScrapesNaPTANCode {
    NSString *correctNaPTANCode = _correctData[LJSNaPTANCodeKey];
    
    NSDictionary *scrapedData = [_sut scrapeDepatureDataFromHTML:_html];
    NSString *scrapedNaPTANCode = scrapedData[LJSNaPTANCodeKey];
    
    XCTAssertEqualObjects(scrapedNaPTANCode, correctNaPTANCode, @"");
}

- (void)testScrapesStopName {
    NSString *correctStopName = _correctData[LJSStopNameKey];
    
    NSDictionary *scrapedData = [_sut scrapeDepatureDataFromHTML:_html];
    NSString *scrapedStopName = scrapedData[LJSStopNameKey  ];
    
    XCTAssertEqualObjects(scrapedStopName, correctStopName, @"");
}

- (void)testScrapesLiveInformationDate {
    NSString *correctLiveDate = _correctData[LJSLiveDateKey];
    
    NSDictionary *scrapedData = [_sut scrapeDepatureDataFromHTML:_html];
    NSString *scrapedLiveDate = scrapedData[LJSLiveDateKey];
    
    XCTAssertEqualObjects(scrapedLiveDate, correctLiveDate, @"");
}

- (void)testScrpaesLaterDepaturesURL {
    NSURL *corectURL = [NSURL URLWithString:@"/pip/stop.asp?naptan=37090168&pscode=BLUE&dest=&offset=12&textonly=1"];
    NSURL *scrapedURL = [_sut scrapeLaterDepaturesURL:_html];
    
    XCTAssertEqualObjects(scrapedURL, corectURL, @"");

}

- (void)testReturnsNoDepatureData {
    // TODO: No depature table in HTML
}

- (void)testInstantiatesError {
    // TODO: Malformed HTML
}

- (void)testReturnsNoLaterURL {
    // TODO: No later depatures URL in HTML
}

- (void)testReturnsNoEarlierURL {
    // TODO: No earlier depatures URL in HTML
}

@end
