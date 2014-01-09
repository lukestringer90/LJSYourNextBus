//
//  LJSScraper.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 05/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSScraper.h"
#import <ObjectiveGumbo/ObjectiveGumbo.h>

NSString * const LJSStopCodeKey = @"stop_code";
NSString * const LJSStopNameKey = @"stop_name";
NSString * const LJSDepaturesKey = @"departures";
NSString * const LJSDestinationKey = @"destination";
NSString * const LJSExpectedDepatureTime = @"expected_departure_time";


@implementation LJSScraper

- (NSDictionary *)scrapeDepatureDataFromHTML:(NSString *)html {
    OGNode *rootNode = [ObjectiveGumbo parseDocumentWithString:html];
    NSArray *tds = [rootNode elementsWithTag:GUMBO_TAG_TD];
    
    NSString *stopCode = [self scrapeStopCodeFromHTML:html];
    NSString *stopName = [self scrapeStopNameFromHTML:html];
    
    NSDictionary *scrapedData = @{
                                  LJSStopCodeKey : stopCode,
                                  LJSStopNameKey : stopName
                                  };
    
    for (NSInteger serviceRowIndex = 0; serviceRowIndex < tds.count; serviceRowIndex+=4) {
        OGElement *serviceElement = tds[serviceRowIndex];
        OGElement *destinationElement = tds[serviceRowIndex+1];
        OGElement *depatureElement = tds[serviceRowIndex+2];
        
        scrapedData = [self processServiceValue:[self removeLastCharacterFromString:serviceElement.text]
                               destinationValue:[self removeLastCharacterFromString:destinationElement.text]
                                  depatureValue:[self removeLastCharacterFromString:depatureElement.text]
                                intoScrapedData:scrapedData];
        
    }
    return scrapedData;
}

- (NSString *)scrapeStopCodeFromHTML:(NSString *)html {
    NSString *pattern = @".*<p>Stop Number: <b>(.*)</b></p>.*";
    return [self scrapeHTML:html usingRegexPattern:pattern];
}

- (NSString *)scrapeStopNameFromHTML:(NSString *)html {
    NSString *pattern = @".*<p>Departure information for <b>(.*)</b> at.*";
    return [self scrapeHTML:html usingRegexPattern:pattern];
}

- (NSString *)scrapeHTML:(NSString *)html usingRegexPattern:(NSString *)pattern {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        return nil;
    }
    
    NSTextCheckingResult *match = [regex firstMatchInString:html
                                                    options:0
                                                      range:NSMakeRange(0, [html length])];
    
    NSString *stopCode = nil;
    if (match) {
        stopCode = [html substringWithRange:[match rangeAtIndex:1]];
    }
    
    return stopCode;
}

- (NSString *)removeLastCharacterFromString:(NSString *)string {
    return [string substringToIndex:[string length]-1];;
}

- (NSDictionary *)processServiceValue:(NSString *)serviceValue destinationValue:(NSString *)destinationTimeValue depatureValue:(NSString *)depatureValue intoScrapedData:(NSDictionary *)scrapedData {
    NSMutableDictionary *allDepatures = [[scrapedData valueForKey:LJSDepaturesKey] mutableCopy];
    
    if (!allDepatures) {
        allDepatures = [NSMutableDictionary dictionaryWithObject:@[] forKey:serviceValue];
    }
    
    NSDictionary *depatureDictionary = @{
                                         LJSDestinationKey : destinationTimeValue,
                                         LJSExpectedDepatureTime : depatureValue
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

- (NSURL *)scrapeNextPageURLFromHTML:(NSString *)html {
    return nil;
}

@end
