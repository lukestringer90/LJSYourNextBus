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
        return [NSURL URLWithString:[NSString stringWithFormat:
                                     @"http://gettheresooner.travelsouthyorkshire.com/MobileNaptan.aspx?t=departure&sa=&dc&ac=99&vc&x=0&y=0&format=text&Mode=Mobile", stopNumber]];
    }
    return nil;
}

@end
