//
//  LJSLiveDataViewController.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 22/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJSLiveDataViewController : UITableViewController

@property (nonatomic, copy, readonly) NSString *NaPTANCode;

- (instancetype)initWithNaPTANCode:(NSString *)NaPTANCode;

@end
