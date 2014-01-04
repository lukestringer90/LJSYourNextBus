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

- (void)depatureDataForStopNumber:(NSString *)stopNumber completion:(void (^)(id json, NSError *error))completion {
    NSString *urlString = [NSString stringWithFormat:@"http://tsy.acislive.com/pip/stop.asp?naptan=%@&textonly=1&pda=1", stopNumber];
    
    NSError *error = nil;
    NSString *response = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]
                                                        encoding:NSStringEncodingConversionAllowLossy
                                                           error:&error];
    
    OGNode *topNode = [ObjectiveGumbo parseDocumentWithString:response];
    NSArray *tds = [topNode elementsWithTag:GUMBO_TAG_TD];
    
    for (NSInteger serviceRowIndex = 0; serviceRowIndex < tds.count; serviceRowIndex+=4) {
        OGElement *serviceElement = tds[serviceRowIndex];
        OGElement *destinationElement = tds[serviceRowIndex+1];
        OGElement *depatureElement = tds[serviceRowIndex+2];
        
        NSLog(@"%@ - %@ - %@", serviceElement.text, destinationElement.text, depatureElement.text);
    }

}

@end
