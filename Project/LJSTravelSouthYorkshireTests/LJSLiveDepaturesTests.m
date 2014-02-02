//
//  LJSLiveDepaturesTests.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 02/02/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import <LJSTravelSouthYorkshire/LJSLiveDepatures.h>
#import <LJSTravelSouthYorkshire/LJSScraper.h>
#import <LJSTravelSouthYorkshire/LJSHTMLDownloader.h>

@interface LJSLiveDepatures (TestVisibility)
@property (nonatomic, strong) LJSScraper *scraper;
@property (nonatomic, strong) LJSHTMLDownloader *htmlDownloader;
@end

@interface LJSLiveDepaturesTests : XCTestCase {
    LJSLiveDepatures *_sut;
}
@end

@implementation LJSLiveDepaturesTests

#pragma mark - setUp / tearDown

- (void)setUp {
    [super setUp];
    _sut = [[LJSLiveDepatures alloc] init];
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

- (id)mockScraperReturningLaterURL:(NSURL *)url {
    id scraperMock = [OCMockObject niceMockForClass:[LJSScraper class]];
    [[[scraperMock stub] andReturn:url] scrapeLaterDepaturesURL:[OCMArg any]];
    return scraperMock;
}

- (id)mockScraperReturningEarlierURL:(NSURL *)url {
    id scraperMock = [OCMockObject niceMockForClass:[LJSScraper class]];
    [[[scraperMock stub] andReturn:url] scrapeEarlierDepaturesURL:[OCMArg any]];
    return scraperMock;
}


- (id)mockContentDownloadReturningHTML:(NSString *)htmlString {
    id contentDownloaderMock = [OCMockObject niceMockForClass:[LJSHTMLDownloader class]];
    [[[contentDownloaderMock stub] andReturn:htmlString] downloadHTMLFromURL:[OCMArg any] error:[OCMArg setTo:nil]];
    return contentDownloaderMock;
}

#pragma mark - Tests

- (void)testURLForNaPTANCode {
//    NSURL *correctURL = [NSURL URLWithString:@"http://tsy.acislive.com/pip/stop.asp?naptan=123456&textonly=1&pda=1"];
//    NSURL *generatedURL = [_sut urlForNaPTANCode:@"123456"];
//    XCTAssertEqualObjects(generatedURL, correctURL, @"");
}

- (void)testNoURLForNilNaPTANCode {
//    NSURL *generatedURL = [_sut urlForNaPTANCode:nil];
//    XCTAssertNil(generatedURL, @"");
}

- (void)testReturnsDataAfterSucessfulScrape {
//    NSDictionary *correctData = [self loadJSONFileNamed:@"malin_bridge_tram"];
//    
//    _sut.scraper = [self mockScraperReturningDepatureData:correctData];
//    _sut.htmlDownloader = [self mockContentDownloadReturningHTML:@"some html"];
//    
//    __block NSDictionary *capturedData = nil;
//    [_sut depatureDataForNaPTANCode:@"1234" completion:^(NSDictionary *depatureData, NSURL *laterURL, NSURL *earlierURL, NSError *error) {
//        capturedData = depatureData;
//    }];
//    
//    XCTAssertEqualObjects(capturedData, correctData, @"");
}

- (void)testReturnsLaterDepaturesURLAfterSucessfulScrape {
//    NSURL *correctURL = [NSURL URLWithString:@"pip/stop.asp?naptan=37090168&pscode=BLUE&dest=&offset=12&textonly=1"];
//    
//    _sut.scraper = [self mockScraperReturningLaterURL:correctURL];
//    _sut.htmlDownloader = [self mockContentDownloadReturningHTML:@"some html"];
//    
//    __block NSURL *capturedURL = nil;
//    [_sut depatureDataForNaPTANCode:@"1234" completion:^(NSDictionary *depatureData, NSURL *laterURL, NSURL *earlierURL, NSError *error) {
//        capturedURL = laterURL;
//    }];
//    
//    XCTAssertEqualObjects(capturedURL, correctURL, @"");
}

- (void)testReturnsEarlierDepaturesURLAfterSucessfulScrape {
//    NSURL *correctURL = [NSURL URLWithString:@"/pip/stop.asp?naptan=37090168&pscode=BLUE&dest=&offset=10&textonly=1"];
//    
//    _sut.scraper = [self mockScraperReturningEarlierURL:correctURL];
//    _sut.htmlDownloader = [self mockContentDownloadReturningHTML:@"some html"];
//    
//    __block NSURL *capturedURL = nil;
//    [_sut depatureDataForNaPTANCode:@"1234" completion:^(NSDictionary *depatureData, NSURL *laterURL, NSURL *earlierURL, NSError *error){
//        capturedURL = earlierURL;
//    }];
//    
//    XCTAssertEqualObjects(capturedURL, correctURL, @"");
}

- (void)testReturnsNoDataAfterUnsucessfulScrape {
    // TODO: No depature table in HTML
    
}

- (void)testReturnsErrorAfterUnsucessfulScrape {
    // TODO: Error from LJSSCraper
    
}

- (void)testReturnsErrorForUnsucessfulWebContentDownload {
    // TODO: Error from LJSWebContentDownloader
    
}


@end
