//
//  LJSTravelSouthYorkshire.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 04/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSTravelSouthYorkshire.h"
#import <ObjectiveGumbo/ObjectiveGumbo.h>

@implementation LJSTravelSouthYorkshire

- (void)requestDepatureDataForStopNumber:(NSString *)stopNumber completion:(void (^)(id json, NSURL *nextPageURL, NSError *error))completion {
    NSURL *url = [self urlForStopNumber:stopNumber];
    
    NSError *error = nil;
    NSString *htmlString = [self htmlStringFromURLString:url error:&error];
    
    
    OGNode *topNode = [ObjectiveGumbo parseDocumentWithString:htmlString];
    id json = [self scrapeIntoJSON:topNode];
    NSString *nextPageURL = [self scrapeNextPageURL:topNode];
    
    if (completion) {
        completion(json, nil, nil);
    }
}

- (id)scrapeIntoJSON:(OGNode *)rootNode {
    NSArray *tds = [rootNode elementsWithTag:GUMBO_TAG_TD];
    
    NSString *stopName = @"stop_name";
    NSString *serviceKey = @"service";
    NSString *depaturesKey = @"depatures";
    NSString *destinationKey = @"destination";
    NSString *timeKey = @"time";
    
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    for (NSInteger serviceRowIndex = 0; serviceRowIndex < tds.count; serviceRowIndex+=4) {
        OGElement *serviceElement = tds[serviceRowIndex];
        OGElement *destinationElement = tds[serviceRowIndex+1];
        OGElement *depatureElement = tds[serviceRowIndex+2];
        
        NSLog(@"%@ - %@ - %@", serviceElement.text, destinationElement.text, depatureElement.text);
        
        NSMutableDictionary *allDepatures = [[json valueForKey:depaturesKey] mutableCopy];
        
        if (!allDepatures) {
            allDepatures = [NSMutableDictionary dictionaryWithObject:@[] forKey:serviceElement.text];
        }
        
        NSDictionary *depatureDictionary = @{
                                             destinationKey : destinationElement.text,
                                             timeKey : depatureElement.text
                                             };
        
        NSArray *sericeDepatures = allDepatures[serviceElement.text];
        NSArray *updateDServiceDepatures;
        if (sericeDepatures) {
            updateDServiceDepatures = [sericeDepatures arrayByAddingObject:depatureDictionary];
        }
        else {
            updateDServiceDepatures = @[depatureDictionary];
        }
        
        allDepatures[serviceElement.text] = updateDServiceDepatures;
        
        json[depaturesKey] = allDepatures;
        
    }
    return json;
}

- (NSString *)scrapeNextPageURL:(OGNode *)topNode {
    return nil;
}

- (NSURL *)urlForStopNumber:(NSString *)stopNumber {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://tsy.acislive.com/pip/stop.asp?naptan=%@&textonly=1&pda=1", stopNumber]];
}

- (NSString *)htmlStringFromURLString:(NSURL *)url error:(NSError **)error {
    return [[NSString alloc] initWithContentsOfURL:url
                                                        encoding:NSStringEncodingConversionAllowLossy
                                                           error:error];
}

@end
