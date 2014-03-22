//
//  LJSLiveDataViewController.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 22/03/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSLiveDataViewController.h"
#import "LJSYourNextBusClient.h"
#import "LJSStop.h"
#import "LJSService.h"
#import "LJSDepature.h"

@interface LJSLiveDataViewController ()
@property (nonatomic, copy, readwrite) NSString *NaPTANCode;
@property (nonatomic, strong) LJSStop *stop;
@property (nonatomic, copy) NSArray *sortedDepatures;
@property (nonatomic, strong) LJSYourNextBusClient *yourNextBusClient;
@end

@implementation LJSLiveDataViewController

- (instancetype)initWithNaPTANCode:(NSString *)NaPTANCode {
	self = [super initWithStyle:UITableViewStylePlain];
	if (self) {
		self.NaPTANCode = NaPTANCode;
		self.yourNextBusClient = [LJSYourNextBusClient new];
		[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
	}
	return self;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:YES];
	[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSURL *laterURL, NSURL *earlierURL, NSError *error) {
		if (!error) {
			self.stop = stop;
			self.title = self.stop.title;
			NSArray *allDepatures = [[stop.services valueForKeyPath:@"depatures"] valueForKeyPath:@"@unionOfArrays.self"];
			NSArray *sortDescriptors = @[
										 [NSSortDescriptor sortDescriptorWithKey:@"destination"
																	   ascending:YES],
										 [NSSortDescriptor sortDescriptorWithKey:@"expectedDepatureDate"
																	   ascending:YES]];
			self.sortedDepatures = [allDepatures sortedArrayUsingDescriptors:sortDescriptors];;
			[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
		}
	}];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.sortedDepatures != nil ? self.sortedDepatures.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
	
	LJSDepature *depature = self.sortedDepatures[indexPath.row];
	cell.textLabel.text = depature.destination;
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return self.sortedDepatures != nil ? @"Depatures" : nil;
}


@end
