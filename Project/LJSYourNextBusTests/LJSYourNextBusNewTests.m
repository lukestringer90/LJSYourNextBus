//
//  LJSYourNextBusNewTests.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 14/08/2017.
//  Copyright © 2017 Luke Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "LJSSouthYorkshireClient.h"
#import "LJSMockHTMLDownloader.h"
#import "LJSScraper.h"
#import "LJSLiveDataResult.h"
#import "LJSStop.h"
#import "LJSService.h"
#import "LJSDeparture.h"

@interface LJSYourNextBusClient (TestVisibility)
@property (nonatomic, strong) LJSHTMLDownloader *htmlDownloader;
@property (nonatomic, strong) LJSScraper *scraper;
@end

@interface LJSScraper (TestVisibility)
- (NSDate *)liveDateFromString:(NSString *)liveTimeString;
- (NSDate *)currentDate;
@end

@interface LJSYourNextBusNewTests : XCTestCase <LJSYourNextBusClientDelegate, LJSYourNextBusScrapeDelegate>

@property (nonatomic, strong) LJSStop *returnedStop;

@property (nonatomic, strong) LJSSouthYorkshireClient *yourNextBusClient;
@property (nonatomic, strong) XCTestExpectation *willScrapeExpectation;
@property (nonatomic, strong) XCTestExpectation *returnedStopExpectation;
@property (nonatomic, strong) XCTestExpectation *errorExpectation;
@end

@implementation LJSYourNextBusNewTests

#pragma mark - LJSYourNextBusClientDelegate

- (void)client:(LJSYourNextBusClient *)client willScrapeHTML:(NSString *)HTML NaPTANCode:(NSString *)NaPTANCode
{
    [self.willScrapeExpectation fulfill];
}

- (void)client:(LJSYourNextBusClient *)client failedWithError:(NSError *)error NaPTANCode:(NSString *)NaPTANCode
{
    [self.errorExpectation fulfill];
}

#pragma mark - LJSYourNextBusScrapeDelegate
- (void)client:(LJSYourNextBusClient *)client returnedLiveDataResult:(LJSLiveDataResult *)result
{
    self.returnedStop = result.stop;
    
    [self.returnedStopExpectation fulfill];
}

#pragma mark - Helpers

- (id)stubLiveDate:(NSDate *)liveDate ofScraper:(LJSScraper *)scraper {
    id scraperMock = [OCMockObject partialMockForObject:scraper];
    [[[scraperMock stub] andReturn:liveDate] liveDateFromString:[OCMArg any]];
    return scraperMock;
}

- (id)stubCurrentDate:(NSDate *)liveDate ofScraper:(LJSScraper *)scraper {
    id scraperMock = [OCMockObject partialMockForObject:scraper];
    [[[scraperMock stub] andReturn:liveDate] currentDate];
    return scraperMock;
}

- (void)setupReturnedStopExpectation
{
    self.returnedStopExpectation = [self expectationWithDescription:@"returnedStop"];
}

- (void)setupWillScrapeExpectation
{
    self.willScrapeExpectation = [self expectationWithDescription:@"willScrape"];
}

- (void)setupErrorExpectation
{
    self.errorExpectation = [self expectationWithDescription:@"error"];
}

- (void)setUp
{
    [super setUp];
    
    self.yourNextBusClient = [[LJSSouthYorkshireClient alloc] init];
    self.yourNextBusClient.clientDelegate = self;
    self.yourNextBusClient.scrapeDelegate = self;
}

- (NSString *)loadHTMLFileNamed:(NSString *)fileName {
    NSString *path = [self pathInTestBundleForResource:fileName ofType:@"html"];
    return [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
}

- (NSString *)pathInTestBundleForResource:(NSString *)name ofType:(NSString *)extension {
    return [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:extension];
}

#pragma mark - Tests

- (void)testScrape
{
    [self setupReturnedStopExpectation];
    
    NSString *html = [self loadHTMLFileNamed:@"37090148-new"];
    self.yourNextBusClient.htmlDownloader = [[LJSMockHTMLDownloader alloc] initWithHTML:html ID:@"37090148-new"];
    [self.yourNextBusClient getLiveDataForNaPTANCode:@"37090148"];
    
    [self waitForExpectationsWithTimeout:2.0 handler:^(NSError * _Nullable error) {
        
        XCTAssertEqual(self.returnedStop.liveDate.timeIntervalSince1970, 1501927067);
        
        XCTAssertNotNil(self.returnedStop);
        XCTAssertEqual(self.returnedStop.services.count, 2);
        
        LJSService *yell = [[self.returnedStop.services filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == 'YELL'"]] firstObject];
        LJSService *blue = [[self.returnedStop.services filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == 'BLUE'"]] firstObject];
        
        XCTAssertEqual(yell.departures.count, 6);
        XCTAssertEqual(blue.departures.count, 6);
        
        NSArray *yellSortedDepartures = [yell.departures sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"expectedDepartureDate" ascending:YES]]];
        NSArray *blueSortedDepartures = [blue.departures sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"expectedDepartureDate" ascending:YES]]];
    }];

}

@end
