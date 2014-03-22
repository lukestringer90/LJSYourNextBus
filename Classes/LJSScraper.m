//
//  LJSScraper.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 05/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSScraper.h"
#import <ObjectiveGumbo/ObjectiveGumbo.h>

#import "LJSStop.h"
#import "LJSStop+LJSSetters.h"
#import "LJSService.h"
#import "LJSService+LJSSetters.h"
#import "LJSDepature.h"
#import "LJSDepature+LJSSetters.h"
#import "LJSDepatureDateParser.h"


@interface LJSScraper ()
@property (nonatomic, strong) LJSDepatureDateParser *dateParser;
@end

@implementation LJSScraper

- (instancetype)init {
    self = [super init];
    if (self) {
		self.dateParser = [[LJSDepatureDateParser alloc] init];
    }
    return self;
}

#pragma mark - Public

- (LJSStop *)scrapeStopDataFromHTML:(NSString *)html {
    NSString *naptanCode = [self scrapeNaPTANCodeFromHTML:html];
    NSString *title = [self scrapeTitleFromHTML:html];
	
	NSString *liveDateString = [self scrapeLiveDateStringFromHTML:html];
	NSDate *liveDate = [self.dateParser dateFromString:liveDateString baseDate:[NSDate date]];
    
    LJSStop *stop = [LJSStop new];
	stop.NaPTANCode = naptanCode;
	stop.title = title;
	stop.liveDate = liveDate;
	
	NSArray *services = [self scrapeServicesFromHTML:html stop:stop liveDate:liveDate];
	stop.services = services;
    
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
			service = [LJSService new];
			service.title = title;
			service.stop = stop;
            services = [services arrayByAddingObject:service];
        }
        
        
        OGElement *destinationElement = tds[titleRowIndex+1];
        OGElement *depatureDateElement = tds[titleRowIndex+2];
        OGElement *lowFloorAccessElement = tds[titleRowIndex+3];
        
		NSString *destinationValue = [self removeLastCharacterFromString:destinationElement.text];
		NSString *depatureDateValue = [self removeLastCharacterFromString:depatureDateElement.text];
		
		NSDate *expectedDepatureDate = [self.dateParser dateFromString:depatureDateValue baseDate:liveDate];
        BOOL hasLowFloorAccess = [self lowFloorAccessFromString:lowFloorAccessElement.text];
		
		LJSDepature *depature = [LJSDepature new];
		depature.destination = destinationValue;
		depature.expectedDepatureDate = expectedDepatureDate;
		depature.hasLowFloorAccess = hasLowFloorAccess;
		depature.service = service;

		
		if (!service.depatures) {
			service.depatures = @[depature];
		}
		else {
			service.depatures = [service.depatures arrayByAddingObject:depature];
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
    if (error) return nil;
    
    NSTextCheckingResult *match = [regex firstMatchInString:html
                                                    options:NSMatchingAnchored
                                                      range:NSMakeRange(0, [html length])];

    NSString *NaPTANCode = nil;
    if (match) {
        NaPTANCode = [html substringWithRange:[match rangeAtIndex:1]];
    }
    
    return NaPTANCode;
}

- (BOOL)lowFloorAccessFromString:(NSString *)string {
    return [string hasPrefix:@"LF"];
}

- (NSString *)removeLastCharacterFromString:(NSString *)string {
    // HTML contains a "&nbsp;" character after each value, so remove it
    return [string substringToIndex:[string length]-1];;
}

@end
