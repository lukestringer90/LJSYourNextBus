//
//  LJSTravelSouthYorkshireTests.m
//  LJSTravelSouthYorkshireTests
//
//  Created by Luke Stringer on 04/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "LJSTravelSouthYorkshire.h"
#import "LJSScraper.h"
#import "LJSWebContentDownloader.h"

@interface LJSTravelSouthYorkshire (TestVisibility)
@property (nonatomic, strong) LJSScraper *scraper;
@property (nonatomic, strong) LJSWebContentDownloader *contentDownloader;
@end

@interface LJSTravelSouthYorkshireTests : XCTestCase {
     LJSTravelSouthYorkshire *_sut;
}
@end

@implementation LJSTravelSouthYorkshireTests

#pragma mark - setUp / tearDown

- (void)setUp {
    [super setUp];
    _sut = [[LJSTravelSouthYorkshire alloc] init];
}

#pragma mark - Helpers

- (NSDictionary *)loadJSONFileNamed:(NSString *)fileName {
    NSString* filepath = [[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filepath];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (id)mockScraperReturningDepatureData:(NSDictionary *)data {
    id scraperMock = [OCMockObject niceMockForClass:[LJSScraper class]];
    [[[scraperMock stub] andReturn:data] scrapeDepatureDataFromHTML:[OCMArg any]];
    return scraperMock;
}

- (id)mockScraperReturninglaterDepaturesURL:(NSURL *)url {
    id scraperMock = [OCMockObject niceMockForClass:[LJSScraper class]];
    [[[scraperMock stub] andReturn:url] scrapeLaterDepaturesURL:[OCMArg any]];
    return scraperMock;
}

- (id)mockContentDownloadReturningHTML:(NSString *)htmlString {
    id contentDownloaderMock = [OCMockObject niceMockForClass:[LJSWebContentDownloader class]];
    [[[contentDownloaderMock stub] andReturn:htmlString] downloadHTMLFromURL:[OCMArg any] error:[OCMArg setTo:nil]];
    return contentDownloaderMock;
}

#pragma mark - Tests

- (void)testURLForStopNumber {
    
}

- (void)testReturnsDataAfterSucessfulScrape {
    NSDictionary *correctData = [self loadJSONFileNamed:@"tram"];
    
    _sut.scraper = [self mockScraperReturningDepatureData:correctData];
    _sut.contentDownloader = [self mockContentDownloadReturningHTML:@"some html"];
    
    __block NSDictionary *capturedData = nil;
    [_sut depatureDataForNaPTANCode:@"1234" completion:^(NSDictionary *depatureData, NSURL *laterURL, NSURL *earlierURL, NSError *error) {
        capturedData = depatureData;
    }];
    
    XCTAssertEqualObjects(capturedData, correctData, @"");
}

- (void)testReturnsNextURLAfterSucessfulScrape {
    NSURL *correctURL = [NSURL URLWithString:@"pip/stop.asp?naptan=37090168&pscode=BLUE&dest=&offset=12&textonly=1"];
    
    _sut.scraper = [self mockScraperReturninglaterDepaturesURL:correctURL];
    _sut.contentDownloader = [self mockContentDownloadReturningHTML:@"some html"];
    
    __block NSURL *capturedURL = nil;
    [_sut depatureDataForNaPTANCode:@"1234" completion:^(NSDictionary *depatureData, NSURL *laterURL, NSURL *earlierURL, NSError *error) {
        capturedURL = laterURL;
    }];
    
    XCTAssertEqualObjects(capturedURL, correctURL, @"");
}

- (void)testReturnsNoDataAfterUnsucessfulScape {
    // TODO: No depature table in HTML

}

- (void)testReturnsErrorAfterUnsucessfulScrape {
    // TODO: Error from LJSSCraper

}

- (void)testReturnsErrorForUnsucessfulWebContentDownload {
    // TODO: Error from LJSWebContentDownloader

}

@end
