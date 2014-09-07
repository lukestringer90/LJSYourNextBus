//
//  LJSWestYorkshireClient.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 05/09/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSWestYorkshireClient.h"

@implementation LJSWestYorkshireClient

- (NSURL *)urlForNaPTANCode:(NSString *)stopNumber {
    if (stopNumber) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"http://wypte.acislive.com/pip/stop.asp?naptan=%@&textonly=1&pda=1", stopNumber]];
    }
    return nil;
}

@end
