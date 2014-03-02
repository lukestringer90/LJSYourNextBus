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
#import "LJSService.h"
#import "LJSDepature.h"
#import "LJSServiceBuilder.h"
#import "LJSDepatureBuilder.h"
#import "LJSDepatureDateParser.h"

NSString * const LJSNaPTANCodeKey = @"NaPTAN_code";
NSString * const LJSStopNameKey = @"stop_name";
NSString * const LJSDepaturesKey = @"departures";
NSString * const LJSDestinationKey = @"destination";
NSString * const LJSExpectedDepatureTimeKey = @"expected_departure_time";
NSString * const LJSLiveTimeKey = @"live_information_time";
NSString * const LJSLowFloorAccess = @"low_floor_access";

@interface LJSScraper ()
@property (nonatomic, strong) LJSStopBuilder *stopBuilder;
@property (nonatomic, strong) LJSServiceBuilder *serviceBuilder;
@property (nonatomic, strong) LJSDepatureBuilder *depatureBuilder;
@property (nonatomic, strong) LJSDepatureDateParser *dateParser;
@end

@implementation LJSScraper

- (instancetype)init {
    self = [super init];
    if (self) {
        self.stopBuilder = [[LJSStopBuilder alloc] init];
        self.serviceBuilder = [[LJSServiceBuilder alloc] init];
		self.depatureBuilder = [[LJSDepatureBuilder alloc] init];
		self.dateParser = [[LJSDepatureDateParser alloc] init];
    }
    return self;
}

#pragma mark - Public
#pragma mark -

- (LJSStop *)scrapeStopDataFromHTML:(NSString *)html {
    NSString *naptanCode = [self scrapeNaPTANCodeFromHTML:html];
    NSString *title = [self scrapeTitleFromHTML:html];
	
	NSString *liveDateString = [self scrapeLiveDateStringFromHTML:html];
	NSDate *liveDate = [self.dateParser dateFromString:liveDateString baseDate:[NSDate date]];
    
    LJSStop *stop = [[[[self.stopBuilder stop] withNaPTANCode:naptanCode] withTitle:title] withLiveDate:liveDate];
	NSArray *services = [self scrapeServicesFromHTML:html stop:stop liveDate:liveDate];
	stop = [stop withServices:services];
    
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


#pragma mark - Scraping

- (NSArray *)scrapeServicesFromHTML:(NSString *)html stop:(LJSStop *)stop liveDate:(NSDate *)liveDate {
    OGNode *rootNode = [ObjectiveGumbo parseDocumentWithString:html];
    NSArray *tds = [rootNode elementsWithTag:GUMBO_TAG_TD];
    
    NSArray *services = [NSArray array];
    
    for (NSInteger titleRowIndex = 0; titleRowIndex < tds.count; titleRowIndex+=4) {
        OGElement *titleElement = tds[titleRowIndex];
        NSString *title = [self removeLastCharacterFromString:titleElement.text];
        
        LJSService *service = [[services filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", title]] firstObject];
        if (!service) {
            service = [[[self.serviceBuilder service] withTitle:title] withStop:stop];
            services = [services arrayByAddingObject:service];
        }
        
        
        OGElement *destinationElement = tds[titleRowIndex+1];
        OGElement *depatureDateElement = tds[titleRowIndex+2];
        OGElement *lowFloorAccessElement = tds[titleRowIndex+3];
        
		NSString *destinationValue = [self removeLastCharacterFromString:destinationElement.text];
		NSString *depatureDateValue = [self removeLastCharacterFromString:depatureDateElement.text];
		
		NSDate *expectedDepatureDate = [self.dateParser dateFromString:depatureDateValue baseDate:liveDate];
        BOOL hasLowFloorAccess = [self lowFloorAccessFromString:lowFloorAccessElement.text];
		
		LJSDepature *depature = [[[[[self.depatureBuilder depature]
									withDestination:destinationValue]
								   withExpectedDepatureDate:expectedDepatureDate]
								  withHasLowFloorAccess:hasLowFloorAccess]
								 withService:service];
		
		if (!service.depatures) {
			service = [service withDepautures:@[depature]];
		}
		else {
			NSArray *newDepatures = [service.depatures arrayByAddingObject:depature];
			service = [service withDepautures:newDepatures];
		}

        
    }
    return services;
}

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

- (BOOL)lowFloorAccessFromString:(NSString *)string {
    return [string hasPrefix:@"LF"];
}

#pragma mark - ObjectiveGumbo scraping

//- (NSArray *)processServiceValue:(NSString *)serviceValue destinationValue:(NSString *)destinationTimeValue depatureValue:(NSString *)depatureValue lowFloorAccessValue:(NSNumber *)lowFloorAccessValue currentServices:(NSArray *)currentServices {
//    
//    NSDictionary *depatureDictionary = @{
//                                         LJSDestinationKey : destinationTimeValue,
//                                         LJSExpectedDepatureTimeKey : depatureValue,
//                                         LJSLowFloorAccess : lowFloorAccessValue
//                                         };
//    
//    NSArray *depatureForThisService = allDepatures[serviceValue];
//    NSArray *updatedDepatureForThisService;
//    if (depatureForThisService) {
//        updatedDepatureForThisService = [depatureForThisService arrayByAddingObject:depatureDictionary];
//    }
//    else {
//        updatedDepatureForThisService = @[depatureDictionary];
//    }
//    
//    allDepatures[serviceValue] = updatedDepatureForThisService;
//    
//    
//    NSMutableDictionary *newScrapedData = [scrapedData mutableCopy];
//    [newScrapedData setValue:allDepatures forKey:LJSDepaturesKey];
//    
//    return newScrapedData;
//}

#pragma mark - Other

- (NSString *)removeLastCharacterFromString:(NSString *)string {
    // HTML contains a "&nbsp;" character after each value, so remove it
    return [string substringToIndex:[string length]-1];;
}

@end
