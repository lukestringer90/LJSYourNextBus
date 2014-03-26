//
//  LJSYourNextBusClient+LJSSaveToDisk.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 26/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSYourNextBusClient.h"

@interface LJSYourNextBusClient (LJSSaveToDisk)

- (void)saveToDisk:(NSString *)html stop:(LJSStop *)stop;


@end
