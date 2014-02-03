//
//  LJSScraper.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 05/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSScraper.h"
#import <ObjectiveGumbo/ObjectiveGumbo.h>

#import "LJSStop.h"
#import "LJSStopBuilder.h"

NSString * const LJSNaPTANCodeKey = @"NaPTAN_code";
NSString * const LJSStopNameKey = @"stop_name";
NSString * const LJSDepaturesKey = @"departures";
NSString * const LJSDestinationKey = @"destination";
NSString * const LJSExpectedDepatureTimeKey = @"expected_departure_time";
NSString * const LJSLiveTimeKey = @"live_information_time";
NSString * const LJSLowFloorAccess = @"low_floor_access";

@interface LJSScraper ()
@property (nonatomic, strong) LJSStopBuilder *stopBuilder;
@end

@implementation LJSScraper

- (instancetype)init {
    self = [super init];
    if (self) {
        self.stopBuilder = [[LJSStopBuilder alloc] init];
    }
    return self;
}

#pragma mark - Public
#pragma mark -

- (LJSStop *)scrapeStopDataFromHTML:(NSString *)html {
    NSString *naptanCode = [self scrapeNaPTANCodeFromHTML:html];
    NSString *title = [self scrapeTitleFromHTML:html];
    NSString *liveDateString = [self scrapeLiveDateStringFromHTML:html];
    
    LJSStop *stop = [[[self.stopBuilder stop] withNaPTANCode:naptanCode] withTitle:title];
    
    return stop;
}

- (NSURL *)scrapeLaterDepaturesURL:(NSString *)html {
    NSString *pattern = @".*<a href=\"(.*)\">Later.*";
    NSString *path = [self scrapeHTML:html usingRegexPattern:pattern];
    return [NSURL URLWithString:path];
}

- (NSURL *)scrapeEarlierDepaturesURL:(NSString *)html {
    NSString *pattern = @".*<a href=\"(.*)\">Earlier.*";
    NSString *path = [self scrapeHTML:html usingRegexPattern:pattern];
    return [NSURL URLWithString:path];
}


- (NSDictionary *)scrapeDepatureDataFromHTML:(NSString *)html {
    OGNode *rootNode = [ObjectiveGumbo parseDocumentWithString:html];
    NSArray *tds = [rootNode elementsWithTag:GUMBO_TAG_TD];
    
    NSString *naptanCode = [self scrapeNaPTANCodeFromHTML:html];
    NSString *stopName = [self scrapeTitleFromHTML:html];
    NSString *liveDate = [self scrapeLiveDateStringFromHTML:html];
    
    NSDictionary *scrapedData = @{
                                  LJSNaPTANCodeKey : naptanCode,
                                  LJSStopNameKey : stopName,
                                  LJSLiveTimeKey : liveDate,
                                  };
    
    for (NSInteger serviceRowIndex = 0; serviceRowIndex < tds.count; serviceRowIndex+=4) {
        OGElement *serviceElement = tds[serviceRowIndex];
        OGElement *destinationElement = tds[serviceRowIndex+1];
        OGElement *depatureElement = tds[serviceRowIndex+2];
        OGElement *lowFloorAccessElement = tds[serviceRowIndex+3];
        
        NSNumber *lowFloorAccessValue = [self lowFloorAccessFromString:lowFloorAccessElement.text];
        
        scrapedData = [self processServiceValue:[self removeLastCharacterFromString:serviceElement.text]
                               destinationValue:[self removeLastCharacterFromString:destinationElement.text]
                                  depatureValue:[self removeLastCharacterFromString:depatureElement.text]
                            lowFloorAccessValue:lowFloorAccessValue
                                intoScrapedData:scrapedData];
        
    }
    return scrapedData;
}

#pragma mark - Private

#pragma mark - Regex scraping

- (NSString *)scrapeNaPTANCodeFromHTML:(NSString *)html {
    NSString *pattern = @".*<p>Stop Number: <b>(.*?)</b></p>.*";
    return [self scrapeHTML:html usingRegexPattern:pattern];
}

- (NSString *)scrapeTitleFromHTML:(NSString *)html {
    NSString *pattern = @".*<p>Departure information for <b>(.*?)</b> at.*";
    return [self scrapeHTML:html usingRegexPattern:pattern];
}

- (NSString *)scrapeLiveDateStringFromHTML:(NSString *)html {
    NSString *pattern = @".*at <b>(.*?)</b>.*";
    return [self scrapeHTML:html usingRegexPattern:pattern];
}

- (NSString *)scrapeHTML:(NSString *)html usingRegexPattern:(NSString *)pattern {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionDotMatchesLineSeparators
                                                                             error:&error];
    if (error) {
        return nil;
    }
    
    NSTextCheckingResult *match = [regex firstMatchInString:html
                                                    options:0
                                                      range:NSMakeRange(0, [html length])];

    NSString *NaPTANCode = nil;
    if (match) {
        // Assume group of interest is at index 1
        NaPTANCode = [html substringWithRange:[match rangeAtIndex:1]];
    }
    
    return NaPTANCode;
}

- (NSNumber *)lowFloorAccessFromString:(NSString *)string {
    if ([string rangeOfString:@"LF"].location == NSNotFound) {
        return @0;
    }
    return @1;
}

#pragma mark - ObjectiveGumbo scraping

- (NSDictionary *)processServiceValue:(NSString *)serviceValue destinationValue:(NSString *)destinationTimeValue depatureValue:(NSString *)depatureValue lowFloorAccessValue:(NSNumber *)lowFloorAccessValue intoScrapedData:(NSDictionary *)scrapedData {
    
    NSMutableDictionary *allDepatures = [[scrapedData valueForKey:LJSDepaturesKey] mutableCopy];
    if (!allDepatures) {
        allDepatures = [NSMutableDictionary dictionaryWithObject:@[] forKey:serviceValue];
    }
    
    NSDictionary *depatureDictionary = @{
                                         LJSDestinationKey : destinationTimeValue,
                                         LJSExpectedDepatureTimeKey : depatureValue,
                                         LJSLowFloorAccess : lowFloorAccessValue
                                         };
    
    NSArray *depatureForThisService = allDepatures[serviceValue];
    NSArray *updatedDepatureForThisService;
    if (depatureForThisService) {
        updatedDepatureForThisService = [depatureForThisService arrayByAddingObject:depatureDictionary];
    }
    else {
        updatedDepatureForThisService = @[depatureDictionary];
    }
    
    allDepatures[serviceValue] = updatedDepatureForThisService;
    
    
    NSMutableDictionary *newScrapedData = [scrapedData mutableCopy];
    [newScrapedData setValue:allDepatures forKey:LJSDepaturesKey];
    
    return newScrapedData;
}

#pragma mark - Other

- (NSString *)removeLastCharacterFromString:(NSString *)string {
    // HTML contains a "&nbsp;" character after each value, so remove it
    return [string substringToIndex:[string length]-1];;
}

@end
