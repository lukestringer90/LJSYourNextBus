//
//  LJSViewController.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 29/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSNaPTANEntryViewController.h"
#import "LJSLiveDataViewController.h"

typedef NS_ENUM(NSInteger, EntryTableViewSection) {
    EntryTableViewSectionNaPTAN,
	EntryTableViewSectionSubmit,
	EntryTableViewSectionCount
};

static NSString * const NaPTANCellID = @"NaPTANCellID";
static NSString * const SubmitCellID = @"SubmitCellID";

@interface LJSNaPTANEntryViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *NaPTANCodeText;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation LJSNaPTANEntryViewController

- (instancetype)init {
	self = [super init];
	if (self) {
		self.title = @"YourNextBus API";
		
		self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NaPTANCellID];
		[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SubmitCellID];
		
		self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
		self.textField.delegate = self;
		self.textField.keyboardType = UIKeyboardTypeDecimalPad;
		self.textField.returnKeyType = UIReturnKeyDone;
		self.textField.placeholder = @"8 digit code";
		self.textField.text = @"37010115";
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	self.tableView.frame = self.view.bounds;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == EntryTableViewSectionSubmit) {
		[self NaPTANCodeWasEntryFinished];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return EntryTableViewSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
	
	switch (indexPath.section) {
		case EntryTableViewSectionNaPTAN:
			cell = [self NaPTANEntryCell];
			break;
		case EntryTableViewSectionSubmit:
			cell = [self submitCell];
			break;
		default:
			break;
	}
    
    return cell;
}

- (UITableViewCell *)NaPTANEntryCell {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NaPTANCellID];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	CGFloat xInset = 20.0f;
	self.textField.frame = CGRectMake(xInset,
									  CGRectGetMinY(cell.contentView.frame),
									  CGRectGetWidth(cell.contentView.frame) - xInset,
									  CGRectGetHeight(cell.contentView.frame));
	
	[cell.contentView addSubview:self.textField];
	
	return cell;
}

- (UITableViewCell *)submitCell {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SubmitCellID];
	cell.textLabel.text = @"Get Live YourNextBus Data";
	cell.textLabel.textAlignment = NSTextAlignmentCenter;
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return section == EntryTableViewSectionNaPTAN ? @"Enter NaPTAN Code:" : nil;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self.textField resignFirstResponder];
	[self NaPTANCodeWasEntryFinished];
	return YES;
}

- (void)NaPTANCodeWasEntryFinished {
	if (self.textField.text.length > 0) {
		LJSLiveDataViewController *liveDataViewController = [[LJSLiveDataViewController alloc] initWithNaPTANCode:self.textField.text];
		[self.navigationController pushViewController:liveDataViewController animated:YES];
	}
}

@end
