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
NSString * const LJSSopNameKey = @"stop_name";
NSString * const LJSDepaturesKey = @"departures";
NSString * const LJSDestinationKey = @"destination";
NSString * const LJSExpectedDepatureTime = @"expected_departure_time";

@interface LJSScraper ()
@property (nonatomic, strong) OGNode *rootNode;
@end

@implementation LJSScraper

- (instancetype)initWithHTMLString:(NSString *)htmlString {
    self = [super init];
    if (self) {
        self.rootNode = [ObjectiveGumbo parseDocumentWithString:htmlString];
    }
    return self;
}

- (NSDictionary *)scrapeDepatureData {
    NSArray *tds = [self.rootNode elementsWithTag:GUMBO_TAG_TD];
    
    NSString *stopCode = @"";
    NSString *stopName = @"";
    
    NSDictionary *scrapedData = @{
                                  LJSStopCodeKey : stopCode,
                                  LJSSopNameKey : stopName
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

- (NSURL *)scrapeNextPageURL {
    return nil;
}

@end
