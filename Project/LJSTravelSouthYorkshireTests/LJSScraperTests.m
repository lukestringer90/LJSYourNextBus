//
//  LJSScraperTests.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 02/02/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LJSTravelSouthYorkshire/LJSScraper.h>
#import <LJSTravelSouthYorkshire/LJSLiveDepatures.h>

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
//    _sut = [[LJSScraper alloc] init];
//    _correctData = [self loadJSONFileNamed:@"malin_bridge_tram"];
//    _html = [self loadHTMLFileNamed:@"malin_bridge_tram"];
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

#pragma mark - Depature data

- (void)testScapesDepaturesWithoutLowFloorAccess {
//    _correctData = [self loadJSONFileNamed:@"malin_bridge_tram"];
//    _html = [self loadHTMLFileNamed:@"malin_bridge_tram"];
//    
//    NSDictionary *correctDepatures = _correctData[LJSDepaturesKey];
//    
//    NSDictionary *scrapedData = [_sut scrapeDepatureDataFromHTML:_html];
//    NSDictionary *scrapedDepatures = scrapedData[LJSDepaturesKey];
//    
//    XCTAssertEqualObjects(scrapedDepatures, correctDepatures, @"");
}

- (void)testScapesDepaturesWithLowFloorAccess {
//    _correctData = [self loadJSONFileNamed:@"standwood_avenue_bus"];
//    _html = [self loadHTMLFileNamed:@"standwood_avenue_bus"];
//    
//    NSDictionary *correctDepatures = _correctData[LJSDepaturesKey];
//    
//    NSDictionary *scrapedData = [_sut scrapeDepatureDataFromHTML:_html];
//    NSDictionary *scrapedDepatures = scrapedData[LJSDepaturesKey];
//    
//    XCTAssertEqualObjects(scrapedDepatures, correctDepatures, @"");
}


- (void)testReturnsNoDepatureData {
//    _html = [self loadHTMLFileNamed:@"standwoord_avenue_bus_no_depatures"];
//    
//    NSDictionary *scrapedData = [_sut scrapeDepatureDataFromHTML:_html];
//    NSDictionary *scrapedDepatures = scrapedData[LJSDepaturesKey];
//    
//    XCTAssertNil(scrapedDepatures, @"");
}

#pragma mark - NaPTAN code

- (void)testScrapesNaPTANCode {
//    NSString *correctNaPTANCode = _correctData[LJSNaPTANCodeKey];
//    
//    NSDictionary *scrapedData = [_sut scrapeDepatureDataFromHTML:_html];
//    NSString *scrapedNaPTANCode = scrapedData[LJSNaPTANCodeKey];
//    
//    XCTAssertEqualObjects(scrapedNaPTANCode, correctNaPTANCode, @"");
}

#pragma mark - Stop name

- (void)testScrapesStopName {
//    NSString *correctStopName = _correctData[LJSStopNameKey];
//    
//    NSDictionary *scrapedData = [_sut scrapeDepatureDataFromHTML:_html];
//    NSString *scrapedStopName = scrapedData[LJSStopNameKey  ];
//    
//    XCTAssertEqualObjects(scrapedStopName, correctStopName, @"");
}

#pragma mark - Live information date

- (void)testScrapesLiveInformationDate {
//    NSString *correctLiveDate = _correctData[LJSLiveTimeKey];
//    
//    NSDictionary *scrapedData = [_sut scrapeDepatureDataFromHTML:_html];
//    NSString *scrapedLiveDate = scrapedData[LJSLiveTimeKey];
//    
//    XCTAssertEqualObjects(scrapedLiveDate, correctLiveDate, @"");
}

#pragma mark - Later URL

- (void)testScrpaesLaterDepaturesURL {
//    NSURL *correctURL = [NSURL URLWithString:@"/pip/stop.asp?naptan=37090168&pscode=BLUE&dest=&offset=12&textonly=1"];
//    NSURL *scrapedURL = [_sut scrapeLaterDepaturesURL:_html];
//    
//    XCTAssertEqualObjects(scrapedURL, correctURL, @"");
}

- (void)testReturnsNoLaterURL {
//    _html = [self loadHTMLFileNamed:@"standwoord_avenue_bus_no_later"];
//    
//    NSURL *scrapedURL = [_sut scrapeLaterDepaturesURL:_html];
//    
//    XCTAssertNil(scrapedURL, @"");
}

#pragma mark - Earlier URL

- (void)testEarlierDepaturesURL {
//    NSURL *correctURL = [NSURL URLWithString:@"/pip/stop.asp?naptan=37090168&pscode=BLUE&dest=&offset=10&textonly=1"];
//    NSURL *scrapedURL = [_sut scrapeEarlierDepaturesURL:_html];
//    
//    XCTAssertEqualObjects(scrapedURL, correctURL, @"");
}

- (void)testReturnsNoEarlierURL {
//    _html = [self loadHTMLFileNamed:@"standwoord_avenue_bus_no_earlier"];
//    
//    NSURL *scrapedURL = [_sut scrapeEarlierDepaturesURL:_html];
//    
//    XCTAssertNil(scrapedURL, @"");
}

#pragma mark - Other

- (void)testInstantiatesError {
    // TODO: Malformed HTML
}


@end
