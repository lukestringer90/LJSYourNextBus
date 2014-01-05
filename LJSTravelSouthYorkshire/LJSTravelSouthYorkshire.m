//
//  LJSTravelSouthYorkshire.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 04/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSTravelSouthYorkshire.h"
#import "LJSScraper.h"
#import <ObjectiveGumbo/ObjectiveGumbo.h>

static BOOL const LoadHTMLFromBundle = YES;

@implementation LJSTravelSouthYorkshire

- (void)requestDepatureDataForStopNumber:(NSString *)stopNumber completion:(void (^)(NSDictionary *data, NSURL *nextPageURL, NSError *error))completion {
    NSURL *url = [self urlForStopNumber:stopNumber];
    [self requestDepatureDataAtURL:url completion:completion];
}

- (void)requestDepatureDataAtURL:(NSURL *)url completion:(void (^)(id json, NSURL *nextPageURL, NSError *))completion {
    NSError *error = nil;
    NSString *htmlString = [self htmlStringFromURLString:url error:&error];
    
    OGNode *topNode = [ObjectiveGumbo parseDocumentWithString:htmlString];
    LJSScraper *scraper = [[LJSScraper alloc] init];
    NSDictionary *json = [scraper scrapeDepatreData:topNode];
    NSURL *nextPageURL = [scraper scrapeNextPageURL:topNode];
    
    if (completion) {
        completion(json, nextPageURL, nil);
    }
}


- (NSURL *)urlForStopNumber:(NSString *)stopNumber {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://tsy.acislive.com/pip/stop.asp?naptan=%@&textonly=1&pda=1", stopNumber]];
}

- (NSString *)htmlStringFromURLString:(NSURL *)url error:(NSError **)error {
    if (LoadHTMLFromBundle) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"tram" ofType: @"html"];
        return [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    }
    
    return [[NSString alloc] initWithContentsOfURL:url
                                          encoding:NSStringEncodingConversionAllowLossy
                                             error:error];
}

@end
