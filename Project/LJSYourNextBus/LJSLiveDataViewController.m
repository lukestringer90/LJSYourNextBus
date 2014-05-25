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
#import "LJSDeparture.h"
#import "LJSDepatureCell.h"

@interface LJSLiveDataViewController () <LJSYourNextBusClientDelegate>
@property (nonatomic, copy, readwrite) NSString *NaPTANCode;
@property (nonatomic, strong) LJSStop *stop;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, copy) NSArray *allDepartures;
@property (nonatomic, strong) LJSYourNextBusClient *yourNextBusClient;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation LJSLiveDataViewController

- (instancetype)initWithNaPTANCode:(NSString *)NaPTANCode {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		self.NaPTANCode = NaPTANCode;
		
		self.yourNextBusClient = [LJSYourNextBusClient new];
		self.yourNextBusClient.delegate = self;
		self.yourNextBusClient.saveDataToDisk = YES;
		
		self.dateFormatter = [[NSDateFormatter alloc] init];
		self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
		[self.tableView registerClass:[LJSDepatureCell class] forCellReuseIdentifier:NSStringFromClass([LJSDepatureCell class])];
		
		self.refreshControl = [[UIRefreshControl alloc] init];
		[self.refreshControl addTarget:self action:@selector(getLiveData) forControlEvents:UIControlEventValueChanged];
		[self.tableView addSubview:self.refreshControl];
		
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self getLiveData];
}

- (void)getLiveData {
	
	[self.yourNextBusClient getLiveDataForNaPTANCode:self.NaPTANCode];
	
	
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60; // Default height
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.allDepartures != nil ? self.allDepartures.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LJSDepatureCell *cell = (LJSDepatureCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LJSDepatureCell class])];
	
	LJSDeparture *departure = self.allDepartures[indexPath.row];
	cell.destinationLabel.text = departure.destination;
	cell.serviceTitleLabel.text = departure.service.title;
	cell.lowFloorAccessLabelVisible = departure.hasLowFloorAccess;
	
	if (departure.minutesUntilDeparture <= 10) {
		cell.expectedDepatureLabel.text = departure.countdownString;
	}
	else {
		cell.expectedDepatureLabel.text = [self.dateFormatter stringFromDate:departure.expectedDepartureDate];
	}
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return self.allDepartures != nil ? [NSString stringWithFormat:@"Departures For %@", [self.dateFormatter stringFromDate:self.stop.liveDate]] : nil;
}

#pragma mark - LJSYourNextBusClientDelegate

- (void)client:(LJSYourNextBusClient *)client returnedStop:(LJSStop *)stop messages:(NSArray *)messages {
	[self.refreshControl endRefreshing];
	self.stop = stop;
	self.title = self.stop.title;
	self.allDepartures = [stop sortedDepartures];
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)client:(LJSYourNextBusClient *)client failedWithError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Error"
						  message:[error localizedDescription]
						  delegate:nil
						  cancelButtonTitle:@"Okay"
						  otherButtonTitles: nil];
	[alert show];
}


@end
