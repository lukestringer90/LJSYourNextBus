//
//  LJSStop.m
//  LJSYourNextBus
//
//  Created by Luke Stringer on 29/01/2014.
//  Copyright (c) 2014 Luke Stringer. All rights reserved.
//

#import "LJSStop.h"
#import "LJSService.h"

@interface LJSStop ()
@property (nonatomic, copy, readwrite) NSString *NaPTANCode;
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSDate *liveDate;
@property (nonatomic, copy, readwrite) NSArray *services;
@property (nonatomic, strong, readwrite) NSURL *laterURL;
@property (nonatomic, strong, readwrite) NSURL *earlierURL;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation LJSStop

#pragma mark - Public

- (instancetype)initWithNaPTANCode:(NSString *)NaPTANCode title:(NSString *)title liveDate:(NSDate *)liveDate laterURL:(NSURL *)laterURL earlierURL:(NSURL *)earlierURL servicesProvider:(id <LJSServicesProvider>)servicesProvider
{
	if (self = [super init]) {
		self.NaPTANCode = NaPTANCode;
		self.title = title;
		self.liveDate = liveDate;
		self.laterURL = laterURL;
		self.earlierURL = earlierURL;
		self.services = [servicesProvider provideServicesForStop:self];
		
	}
	return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
	LJSStop *copy = [[LJSStop allocWithZone:zone] init];
	copy.NaPTANCode = self.NaPTANCode;
	copy.title = self.title;
	copy.liveDate = self.liveDate;
	copy.services = self.services;
	copy.laterURL = self.laterURL;
	copy.earlierURL = self.earlierURL;
	return copy;
}

- (BOOL)isEqualToStop:(LJSStop *)stop {
    return [self.NaPTANCode isEqualToString:stop.NaPTANCode] && [self allServicesEqualWithStop:stop];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[LJSStop class]]) {
        return NO;
    }
    
    return [self isEqualToStop:(LJSStop *)object];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Title: %@ - NaPTAN Code: %@ - Live Date : %@ - Services: %ld", self.title, self.NaPTANCode, self.liveDate, (unsigned long)self.services.count];
}

- (NSDictionary *)JSONRepresentation {
	NSArray *servicesJSON = [NSArray array];
	for (LJSService *service in self.services) {
		servicesJSON = [servicesJSON arrayByAddingObject:[service JSONRepresentation]];
	}
	
	return @{
			 @"NaPTANCode" : self.NaPTANCode != nil ? self.NaPTANCode : [NSNull null],
			 @"liveDate" : self.liveDate != nil ? [self.dateFormatter stringFromDate:self.liveDate] : [NSNull null],
			 @"laterURL" : self.laterURL !=nil ? [self.laterURL absoluteString] : [NSNull null],
			 @"earlierURL" : self.earlierURL != nil ? [self.earlierURL absoluteString] : [NSNull null],
			 @"services" : servicesJSON
			 };
}

- (NSArray *)sortedDepartures {
	NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"expectedDepartureDate" ascending:YES]];

	return [[[self.services valueForKeyPath:@"departures"] valueForKeyPath:@"@unionOfArrays.self"] sortedArrayUsingDescriptors:sortDescriptors];
}

#pragma mark - Private

- (BOOL)allServicesEqualWithStop:(LJSStop *)stop {
	NSSet *servicesA = [NSSet setWithArray:self.services];
	NSSet *servicesB = [NSSet setWithArray:stop.services];
	return [servicesA isEqualToSet:servicesB];
}


- (NSDateFormatter *)dateFormatter {
	if (!_dateFormatter) {
		_dateFormatter = [[NSDateFormatter alloc] init];
		_dateFormatter.dateStyle = NSDateFormatterShortStyle;
		_dateFormatter.timeStyle = NSDateFormatterShortStyle;
	}
	return _dateFormatter;
}


@end
