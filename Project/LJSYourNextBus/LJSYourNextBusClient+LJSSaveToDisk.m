//
//  LJSYourNextBusClient+LJSSaveToDisk.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 26/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSYourNextBusClient+LJSSaveToDisk.h"
#import "LJSStop.h"

@implementation LJSYourNextBusClient (LJSSaveToDisk)

- (void)saveToDisk:(NSString *)html stop:(LJSStop *)stop {
	NSString *directoryName = [self directoryNameFromLiveDate:[NSDate date]];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	
	NSString *directoryPath = [documentsPath stringByAppendingPathComponent:directoryName];
    
	if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath]){
		[[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
	}
	

	NSString *HTMLPath = [directoryPath stringByAppendingString:[NSString stringWithFormat:@"/%@.html", stop.NaPTANCode]];
	NSString *JSONPath = [directoryPath stringByAppendingString:[NSString stringWithFormat:@"/%@.json", stop.NaPTANCode]];
	
	NSData *HTMLData = [html dataUsingEncoding:NSUTF8StringEncoding];
	NSData *JSONData = [NSJSONSerialization dataWithJSONObject:[stop JSONRepresentation]
													   options:NSJSONWritingPrettyPrinted
														 error:nil];
	
	[HTMLData writeToFile:HTMLPath atomically:YES];
	[JSONData writeToFile:JSONPath atomically:YES];
}

- (NSString *)directoryNameFromLiveDate:(NSDate *)date {
	static NSDateFormatter *dateFormatter = nil;
	if (!dateFormatter) {
		dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"dd.MM.yyyy-HH.m.ss";
	}
	

	return [dateFormatter stringFromDate:date];
}


@end
