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

@interface LJSLiveDataViewController ()
@property (nonatomic, copy, readwrite) NSString *NaPTANCode;
@property (nonatomic, strong) LJSStop *stop;
@property (nonatomic, copy) NSArray *sortedDepartures;
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
			NSArray *allDepartures = [[stop.services valueForKeyPath:@"Departures"] valueForKeyPath:@"@unionOfArrays.self"];
			NSArray *sortDescriptors = @[
										 [NSSortDescriptor sortDescriptorWithKey:@"destination"
																	   ascending:YES],
										 [NSSortDescriptor sortDescriptorWithKey:@"expectedDepartureDate"
																	   ascending:YES]];
			self.sortedDepartures = [allDepartures sortedArrayUsingDescriptors:sortDescriptors];;
			[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
		}
		else {
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"Error"
								  message:[error localizedDescription]
								  delegate:nil
								  cancelButtonTitle:@"Okay"
								  otherButtonTitles: nil];
			[alert show];
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
	return self.sortedDepartures != nil ? self.sortedDepartures.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
	
	LJSDeparture *Departure = self.sortedDepartures[indexPath.row];
	cell.textLabel.text = Departure.destination;
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return self.sortedDepartures != nil ? @"Departures" : nil;
}


@end
