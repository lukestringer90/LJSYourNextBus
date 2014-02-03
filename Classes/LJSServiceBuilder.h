//
//  LJSServiceBuilder.h
//  LJSTravelSouthYorkshire
//
//  Created by Luke Stringer on 03/02/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJSService.h"

@class LJSStop;
@interface LJSServiceBuilder : NSObject

- (LJSService *)service;

@end

@interface LJSService (LJSBuilderAdditions)

- (LJSService *)withStop:(LJSStop *)stop;
- (LJSService *)withTitle:(NSString *)title;
- (LJSService *)withDepautures:(NSArray *)depatures;

@end
