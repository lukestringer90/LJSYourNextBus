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

@interface LJSLiveDataViewController ()
@property (nonatomic, copy, readwrite) NSString *NaPTANCode;
@property (nonatomic, strong) LJSStop *stop;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, copy) NSArray *sortedDepartures;
@property (nonatomic, strong) LJSYourNextBusClient *yourNextBusClient;
@end

@implementation LJSLiveDataViewController

- (instancetype)initWithNaPTANCode:(NSString *)NaPTANCode {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		self.NaPTANCode = NaPTANCode;
		self.yourNextBusClient = [LJSYourNextBusClient new];
		self.dateFormatter = [[NSDateFormatter alloc] init];
		self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
		[self.tableView registerClass:[LJSDepatureCell class] forCellReuseIdentifier:NSStringFromClass([LJSDepatureCell class])];
		
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self getLiveData];
}

- (void)getLiveData {
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
											 (unsigned long)NULL), ^(void) {
		
		[self.yourNextBusClient liveDataForNaPTANCode:self.NaPTANCode completion:^(LJSStop *stop, NSArray *messages, NSError *error) {
			
			dispatch_sync(dispatch_get_main_queue(), ^{
				
				if (!error) {
					self.stop = stop;
					self.title = self.stop.title;
					NSArray *allDepartures = [[stop.services valueForKeyPath:@"Departures"] valueForKeyPath:@"@unionOfArrays.self"];
					NSArray *sortDescriptors = @[
												 [NSSortDescriptor sortDescriptorWithKey:@"expectedDepartureDate"
																			   ascending:YES],
												 [NSSortDescriptor sortDescriptorWithKey:@"destination"
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
				
			});
			
		}];
		
	});
	
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
	return self.sortedDepartures != nil ? self.sortedDepartures.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LJSDepatureCell *cell = (LJSDepatureCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LJSDepatureCell class])];
	
	LJSDeparture *departure = self.sortedDepartures[indexPath.row];
	cell.destinationLabel.text = departure.destination;
	cell.expectedDepatureLabel.text = [self.dateFormatter stringFromDate:departure.expectedDepartureDate];
	cell.serviceTitleLabel.text = departure.service.title;
	cell.lowFloorAccessLabelVisible = departure.hasLowFloorAccess;
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return self.sortedDepartures != nil ? [NSString stringWithFormat:@"Depatures For %@", [self.dateFormatter stringFromDate:self.stop.liveDate]] : nil;
}


@end
