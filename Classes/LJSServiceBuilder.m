//
//  LJSServiceBuilder.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 03/02/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSServiceBuilder.h"
#import "LJSStop.h"

@implementation LJSServiceBuilder
- (LJSService *)service {
    return [[LJSService alloc] init];
}
@end

@interface LJSService () {
    LJSStop *_stop;
    NSString *_title;
    NSArray *_depatures;
}
@end

@implementation LJSService (LJSBuilderAdditions)

- (LJSService *)withStop:(LJSStop *)stop {
    _stop = stop;
    return self;
}

- (LJSService *)withTitle:(NSString *)title {
    _title = title;
    return self;
}

- (LJSService *)withDepautures:(NSArray *)depatures {
    _depatures = depatures;
    return self;
}


@end
