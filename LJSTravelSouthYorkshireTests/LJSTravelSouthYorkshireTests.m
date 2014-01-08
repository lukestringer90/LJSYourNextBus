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

@interface LJSTravelSouthYorkshireTests : XCTestCase

@end

@implementation LJSTravelSouthYorkshireTests

#pragma mark - Helpers

- (NSDictionary *)loadJSONFileNamed:(NSString *)fileName {
    NSString* filepath = [[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filepath];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (id)mockScraperReturning:(NSDictionary *)data {
    id scraperMock = [OCMockObject niceMockForClass:[LJSScraper class]];
    [[[scraperMock stub] andReturn:data] scrapeDepatureDataFromHTML:[OCMArg any]];
    return scraperMock;
}

- (id)mockContentDownloadReturn:(NSString *)htmlString {
    id contentDownloaderMock = [OCMockObject niceMockForClass:[LJSWebContentDownloader class]];
    [[[contentDownloaderMock stub] andReturn:htmlString] downloadHTMLFromURL:[OCMArg any] error:[OCMArg setTo:nil]];
    return contentDownloaderMock;
}

#pragma mark - Tests

- (void)testReturnsDataAfterSucessfulScrape {
    NSDictionary *correctData = [self loadJSONFileNamed:@"tram"];
    
    LJSTravelSouthYorkshire *client = [[LJSTravelSouthYorkshire alloc] init];
    client.scraper = [self mockScraperReturning:correctData];
    client.contentDownloader = [self mockContentDownloadReturn:@"some html"];
    
    __block NSDictionary *capturedData = nil;
    [client depatureDataForStopNumber:@"1234" completion:^(NSDictionary *data, NSURL *nextPageURL, NSError *error) {
        capturedData = data;
    }];
    
    XCTAssertEqualObjects(capturedData, correctData, @"");
    
}

- (void)testReturnsNextURLAfterSucessfulScrape {

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
