//
//  LJSDepatureCell.h
//  LJSYourNextBus
//
//  Created by Luke Stringer on 24/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJSDepatureCell : UITableViewCell
@property (nonatomic, strong, readonly) UILabel *destinationLabel;
@property (nonatomic, strong, readonly) UILabel *expectedDepatureLabel;
@property (nonatomic, strong, readonly) UILabel *serviceTitleLabel;
@property (nonatomic, assign, readwrite, getter = lowFloorAccessLabelIsVisible) BOOL lowFloorAccessLabelVisible;
@end
