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
#import "LJSService.h"
#import "LJSDeparture.h"
#import "LJSDepartureDateParser.h"
#import "NSDate+LJSCountDownString.h"
#import "LJSStopBuilder.h"
#import "LJSServiceBuilder.h"
#import "LJSDepartureBuilder.h"

@interface LJSScraper ()
@property (nonatomic, strong) LJSDepartureDateParser *dateParser;
@property (nonatomic, strong) NSCalendar *calendar;
@end

@implementation LJSScraper

- (instancetype)init {
    self = [super init];
    if (self) {
		self.dateParser = [[LJSDepartureDateParser alloc] init];
		self.calendar = [NSCalendar currentCalendar];
    }
    return self;
}

#pragma mark - Public

- (BOOL)htmlIsValid:(NSString *)html {
	BOOL validTitleFound = [html rangeOfString:@"Departure information for"].location != NSNotFound;
	BOOL listFound = [html rangeOfString:@"The following list of stops matches the stop that you requested."].location == NSNotFound;
	return validTitleFound && listFound;
}

- (BOOL)htmlContainServices:(NSString *)html {
	return [html rangeOfString:@"There are no departures in the next hour from this stop."].location == NSNotFound;
}

- (NSArray *)scrapeMessagesFromHTML:(NSString *)html {
	NSString *pattern = @".*msgs\\[\\d+\\] = \\\"(.*?)\\\";.*";
	
	NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:0
                                                                             error:&error];
	if (error) return nil;
	
	__block NSArray *matches = nil;
	[regex enumerateMatchesInString:html
							options:0
							  range:NSMakeRange(0, [html length])
						 usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
							 NSString *match = [html substringWithRange:[result rangeAtIndex:1]];
							 if (match.length > 0) {
								 if (!matches) {
									 matches = [NSArray array];
								 }
								 matches = [matches arrayByAddingObject:match];
							 }
						 }];
	
    return matches;
}

- (LJSStop *)scrapeStopDataFromHTML:(NSString *)html {
    NSString *naptanCode = [self scrapeNaPTANCodeFromHTML:html];
    NSString *title = [self scrapeTitleFromHTML:html];
	
	// The "live date" is the time as specified in the HTML on the current day
	NSString *liveTimeString = [self scrapeLiveDateStringFromHTML:html];
	NSDate *liveDate = [self liveDateFromString:liveTimeString];
    
    LJSStopBuilder *stopBuilder = [LJSStopBuilder new];
	stopBuilder.NaPTANCode = naptanCode;
	stopBuilder.title = title;
	stopBuilder.liveDate = liveDate;
	
	if ([self htmlContainServices:html]) {
		NSArray *serviceBuilders = [self scrapeServicesFromHTML:html liveDate:liveDate];
		stopBuilder.serviceBuilders = serviceBuilders;
		
		stopBuilder.laterURL = [self scrapeLaterDeparturesURL:html];
		stopBuilder.earlierURL = [self scrapeEarlierDeparturesURL:html];
	}
    
    return [stopBuilder build];
}

- (NSURL *)scrapeLaterDeparturesURL:(NSString *)html {
    NSString *pattern = @".*<a href=\"(.*)\">Later.*";
    NSString *path = [self scrapeHTML:html usingRegexPattern:pattern];
    return [NSURL URLWithString:path];
}

- (NSURL *)scrapeEarlierDeparturesURL:(NSString *)html {
    NSString *pattern = @".*<a href=\"(.*)\">Earlier.*";
    NSString *path = [self scrapeHTML:html usingRegexPattern:pattern];
    return [NSURL URLWithString:path];
}

#pragma mark - Scraping

- (NSArray *)scrapeServicesFromHTML:(NSString *)html liveDate:(NSDate *)liveDate {
    OGNode *rootNode = [ObjectiveGumbo parseDocumentWithString:html];
    NSArray *tds = [rootNode elementsWithTag:GUMBO_TAG_TD];
	
    NSArray *servicesBuilders = [NSArray array];
	
    for (NSInteger titleRowIndex = 0; titleRowIndex < tds.count; titleRowIndex+=4) {
        OGElement *titleElement = tds[titleRowIndex];
        NSString *title = [self removeLastCharacterFromString:titleElement.text];
        
        LJSServiceBuilder *serviceBuilder = [[servicesBuilders filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", title]] firstObject];
        if (!serviceBuilder) {
			serviceBuilder = [LJSServiceBuilder new];
			serviceBuilder.title = title;
            servicesBuilders = [servicesBuilders arrayByAddingObject:serviceBuilder];
        }
        
        
        OGElement *destinationElement = tds[titleRowIndex+1];
        OGElement *departureDateElement = tds[titleRowIndex+2];
        OGElement *lowFloorAccessElement = tds[titleRowIndex+3];
        
		NSString *destinationStringValue = [self removeLastCharacterFromString:destinationElement.text];
		NSString *departureDateStringValue = [self removeLastCharacterFromString:departureDateElement.text];
		
		NSDate *expectedDepartureDate = [self.dateParser dateFromString:departureDateStringValue baseDate:liveDate];
		NSString *countDownString = [expectedDepartureDate countdownStringTowardsDate:liveDate
																			 calendar:self.calendar];
		NSInteger minutesUntilDeparture = [self.dateParser minutesUntilDate:liveDate
														departureDateString:departureDateStringValue];
		
        BOOL hasLowFloorAccess = [self lowFloorAccessFromString:lowFloorAccessElement.text];
		
		LJSDepartureBuilder *departureBuilder = [LJSDepartureBuilder new];
		departureBuilder.destination = destinationStringValue;
		departureBuilder.expectedDepartureDate = expectedDepartureDate;
		departureBuilder.countdownString = countDownString;
		departureBuilder.minutesUntilDeparture	= minutesUntilDeparture;
		departureBuilder.hasLowFloorAccess = hasLowFloorAccess;
		
		if (!serviceBuilder.departureBuilders) {
			serviceBuilder.departureBuilders = @[departureBuilder];
		}
		else {
			NSArray *sortDescriptors = @[
										 [NSSortDescriptor sortDescriptorWithKey:@"expectedDepartureDate"
																	   ascending:YES]];
			serviceBuilder.departureBuilders = [[serviceBuilder.departureBuilders arrayByAddingObject:departureBuilder] sortedArrayUsingDescriptors:sortDescriptors];
		}
		
        
    }
    return servicesBuilders;
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
	
    NSString *foundString = nil;
    if (match) {
        foundString = [html substringWithRange:[match rangeAtIndex:1]];
    }
    
    return foundString;
}

- (BOOL)lowFloorAccessFromString:(NSString *)string {
    return [string hasPrefix:@"LF"];
}

- (NSString *)removeLastCharacterFromString:(NSString *)string {
    // HTML contains a "&nbsp;" character after each value, so remove it
    return [string substringToIndex:[string length]-1];;
}

- (NSDate *)liveDateFromString:(NSString *)liveTimeString {
	if (liveTimeString) {
		return [self.dateParser dateFromString:liveTimeString baseDate:[self currentDate]];
	}
	return nil;
}

- (NSDate *)currentDate {
	return [NSDate date];
}

@end
