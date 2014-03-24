
//  LJSDepatureCell.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 24/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSDepatureCell.h"
#import <Masonry/Masonry.h>

@interface LJSDepatureCell ()
@property (nonatomic, strong, readwrite) UILabel *destinationLabel;
@property (nonatomic, strong, readwrite) UILabel *expectedDepatureLabel;
@property (nonatomic, strong, readwrite) UILabel *serviceTitleLabel;
@property (nonatomic, strong, readwrite) UILabel *lowFloorAccessLabel;
@end

@implementation LJSDepatureCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		self.destinationLabel = [[UILabel alloc] initWithFrame:CGRectZero];\
		self.destinationLabel.adjustsFontSizeToFitWidth	= YES;
		self.destinationLabel.font = [UIFont systemFontOfSize:14.0];
		[self.contentView addSubview:self.destinationLabel];
		
		self.expectedDepatureLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.expectedDepatureLabel.adjustsFontSizeToFitWidth = YES;
		self.expectedDepatureLabel.font = [UIFont systemFontOfSize:22.0];
		[self.contentView addSubview:self.expectedDepatureLabel];
		
		self.serviceTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.serviceTitleLabel.adjustsFontSizeToFitWidth = YES;
		self.serviceTitleLabel.font = [UIFont systemFontOfSize:22.0];
		[self.contentView addSubview:self.serviceTitleLabel];
		
		self.lowFloorAccessLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.lowFloorAccessLabel.text = @"LF";
		self.lowFloorAccessLabel.font = [UIFont systemFontOfSize:14.0];
		[self.contentView addSubview:self.lowFloorAccessLabel];
		
    }
    return self;
}

- (void)prepareForReuse {
	[super prepareForReuse];
	
	self.destinationLabel.text = nil;
	self.expectedDepatureLabel.text = nil;
	self.serviceTitleLabel.text = nil;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	UIEdgeInsets padding = UIEdgeInsetsMake(5, 15, 5, 15);
	
	[self.expectedDepatureLabel sizeToFit];
	if (self.lowFloorAccessLabelIsVisible) {
		[self.expectedDepatureLabel updateConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.expectedDepatureLabel.superview.top).with.offset(padding.top);
			make.right.equalTo(self.expectedDepatureLabel.superview.right).with.offset(-padding.right);
		}];
		
		self.lowFloorAccessLabel.hidden = NO;
		[self.lowFloorAccessLabel updateConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.expectedDepatureLabel.bottom).with.offset(padding.top);
			make.bottom.equalTo(self.lowFloorAccessLabel.superview.bottom).with.offset(-padding.bottom);
			make.right.equalTo(self.expectedDepatureLabel.superview.right).with.offset(-padding.right);
		}];
	}
	else {
		self.lowFloorAccessLabel.hidden = YES;
		[self.expectedDepatureLabel updateConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self.expectedDepatureLabel.superview.centerY);
			make.right.equalTo(self.expectedDepatureLabel.superview.right).with.offset(-padding.right);
		}];
	}
	
	[self.serviceTitleLabel updateConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.serviceTitleLabel.superview.top).with.offset(padding.top);
		make.left.equalTo(self.serviceTitleLabel.superview.left).with.offset(padding.left);
		make.right.lessThanOrEqualTo(self.expectedDepatureLabel.left);
		make.height.equalTo(self.expectedDepatureLabel.height);
	}];
		
	[self.destinationLabel updateConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.serviceTitleLabel.bottom).with.offset(padding.top);
		make.bottom.equalTo(self.destinationLabel.superview.bottom).with.offset(-padding.bottom);
		make.left.equalTo(self.serviceTitleLabel.superview.left).with.offset(padding.left);
		make.right.lessThanOrEqualTo(self.expectedDepatureLabel.left);
	}];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
