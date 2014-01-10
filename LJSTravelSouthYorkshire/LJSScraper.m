//
//  LJSScraper.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 05/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSScraper.h"
#import <ObjectiveGumbo/ObjectiveGumbo.h>

NSString * const LJSNaPTANCodeKey = @"NaPTAN_code";
NSString * const LJSStopNameKey = @"stop_name";
NSString * const LJSDepaturesKey = @"departures";
NSString * const LJSDestinationKey = @"destination";
NSString * const LJSExpectedDepatureTimeKey = @"expected_departure_time";
NSString * const LJSLiveDateKey = @"live_information";


@implementation LJSScraper

#pragma mark - Public
#pragma mark -

- (NSURL *)scrapeLaterDepaturesURL:(NSString *)html {
    NSString *pattern = @".*<a href=\"(.*)\">Later.*";
    NSString *path = [self scrapeHTML:html usingRegexPattern:pattern];
    return [NSURL URLWithString:path];
}

/*
 
 Scraping into this form:
 
 {
    "departures" :     {
        "BLUE" :         [
                        {
                "destination" : "Malin Bridge",
                "expected_departure_time" : "11:49"
            },
                        {
                "destination" : "Malin Bridge",
                "expected_departure_time" : "12:09"
            },
                        {
                "destination" : "Malin Bridge",
                "expected_departure_time" : "12:29"
            }
        ],
        "YELL" :         [
                        {
                "destination" : "Middlewood",
                "expected_departure_time" : "11:38"
            },
                        {
                "destination" : "Middlewood",
                "expected_departure_time" : "11:58"
            },
                        {
                "destination" : "Middlewood",
                "expected_departure_time" : "12:18"
            }
        ]
    },
    "stop_code" : "37090168",
    "stop_name" : "Hillsborough",
    "live_information" : "00:31"
}
 
 */

- (NSDictionary *)scrapeDepatureDataFromHTML:(NSString *)html {
    OGNode *rootNode = [ObjectiveGumbo parseDocumentWithString:html];
    NSArray *tds = [rootNode elementsWithTag:GUMBO_TAG_TD];
    
    NSString *naptanCode = [self scrapeNaPTANCodeFromHTML:html];
    NSString *stopName = [self scrapeStopNameFromHTML:html];
    NSString *scrapeDate = [self scapeLiveDateFromHTML:html];
    
    NSDictionary *scrapedData = @{
                                  LJSNaPTANCodeKey : naptanCode,
                                  LJSStopNameKey : stopName,
                                  LJSLiveDateKey : scrapeDate
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

#pragma mark - Private

#pragma mark - Regex scraping

- (NSString *)scrapeNaPTANCodeFromHTML:(NSString *)html {
    NSString *pattern = @".*<p>Stop Number: <b>(.*?)</b></p>.*";
    return [self scrapeHTML:html usingRegexPattern:pattern];
}

- (NSString *)scrapeStopNameFromHTML:(NSString *)html {
    NSString *pattern = @".*<p>Departure information for <b>(.*?)</b> at.*";
    return [self scrapeHTML:html usingRegexPattern:pattern];
}

- (NSString *)scapeLiveDateFromHTML:(NSString *)html {
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

#pragma mark - ObjectiveGumbo scraping

- (NSDictionary *)processServiceValue:(NSString *)serviceValue destinationValue:(NSString *)destinationTimeValue depatureValue:(NSString *)depatureValue intoScrapedData:(NSDictionary *)scrapedData {
    
    NSMutableDictionary *allDepatures = [[scrapedData valueForKey:LJSDepaturesKey] mutableCopy];
    if (!allDepatures) {
        allDepatures = [NSMutableDictionary dictionaryWithObject:@[] forKey:serviceValue];
    }
    
    NSDictionary *depatureDictionary = @{
                                         LJSDestinationKey : destinationTimeValue,
                                         LJSExpectedDepatureTimeKey : depatureValue
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
