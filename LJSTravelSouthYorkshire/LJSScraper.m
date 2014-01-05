//
//  LJSScraper.m
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 05/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSScraper.h"
#import <ObjectiveGumbo/ObjectiveGumbo.h>

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

- (NSDictionary *)scrapeDepatreData {
    NSArray *tds = [self.rootNode elementsWithTag:GUMBO_TAG_TD];
    
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

- (NSURL *)scrapeNextPageURL {
    return nil;
}

@end
