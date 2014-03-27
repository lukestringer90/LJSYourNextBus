//
//  LJSMockHTMLDownloader.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 27/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSHTMLDownloader.h"

@interface LJSMockHTMLDownloader : LJSHTMLDownloader

@property (nonatomic, strong) NSString *HTML;
@property (nonatomic, strong) NSString *ID;

- (instancetype)initWithHTML:(NSString *)HTML ID:(NSString *)useID;

@end
