//
//  LJSScraper.h
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 05/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OGNode;
@interface LJSScraper : NSObject

- (NSDictionary *)scrapeDepatreData:(OGNode *)rootNode;

- (NSURL *)scrapeNextPageURL:(OGNode *)topNode;

@end
