//
//  LJSSouthYorkshireClient.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 05/09/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSSouthYorkshireClient.h"

@implementation LJSSouthYorkshireClient

- (NSURL *)urlForNaPTANCode:(NSString *)stopNumber {
    if (stopNumber) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"http://tsy.acislive.com/web/stop_reference.asp?areacode=&naptan=%@&textonly=1", stopNumber]];
    }
    return nil;
}

@end
