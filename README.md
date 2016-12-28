# LJSYourNextBus
[![Build Status](https://travis-ci.org/lukestringer90/LJSYourNextBus.svg?branch=master)](https://travis-ci.org/lukestringer90/LJSYourNextBus)

Objective-C wrapper for YourNextBus times from South and West Yorkshire Transport. Scrapes live departure data from http://tsy.acislive.com/web (South Yorkshire) and http://wypte.acislive.com (West Yorkshire).

## NaPTAN Code

In the UK every public transport stop (Bus, Tram, Train etc) is a known as a "National Public Transport Access Node". Each of these nodes is given a unique identifier: an 8 digit number called a NaPTANCode. More information here: https://www.gov.uk/government/publications/national-public-transport-access-node-schema

## Usage

To obtain live data for a stop, the NaPTAN code is specified to a `LJSYourNextBusClient` object for either South or West Yorkshire. South Yorkshire codes begin with "310" and West Yorkshire code being with "450". Use the correct subclass for your needs: either `LJSSouthYorkshireClient` or `LJSWestYorkshireClient`. These subclasses construct a URL to the live data for a specific region. This URL is used by the base `LJSYourNextBusClient` to get live data. 

Note: **do not** create and use instances of `LJSYourNextBusClient` directly. Either use a `LJSSouthYorkshireClient` or `LJSWestYorkshireClient` instance or create a custom subclass yourself, overriding the method to construct the URL to the live data.

```
// LJSSouthYorkshireClient or LJSWestYorkshireClient
LJSYourNextBusClient *client = [LJSSouthYorkshireClient new];
client.clientDelegate = self;

[client getLiveDataForNaPTANCode:@"37010200"];

#pragma mark - LJSYourNextBusStopDelegate

- (void)client:(LJSYourNextBusClient *)client failedWithError:(NSError *)error NaPTANCode:(NSString *)NaPTANCode {
	NSLog(@"Failed to get live data for NaPTAN: %@ with error: %@", NaPTANCode, error);
}

- (void)client:(LJSYourNextBusClient *)client returnedLiveDataResult:(LJSLiveDataResult *)result {
	LJSStop *stop = result.stop;
	NSLog(@"Live Data for: %@ %@", stop.NaPTANCode, stop.title);
	for (LJSDeparture *departure in [stop sortedDepartures]) {
		NSLog(@"\t%@ at %@", departure.service.title, departure.countdownString);
	}
	
	/*
	 *	Prints:
	 *	37010200 Meadowhall Intc at 2015-08-01 6:15:00 PM +0000
	 *		X78 at Due → Sheffield Intc
	 *		76 at Due → Low Edges
	 *		X78 at 3 Mins → Sheffield Intc
	 *		38 at 5 Mins → Jordanthorpe
	 *		38 at 18 Mins → Sheffield Intc
	 *		X78 at 6:40 PM → Sheffield Intc
	 *		35 at 6:40 PM → Hillsborough Intc
	 */
}


```

## Object Graph

Data model.

```
┌───────────────┐                                                       ┌───────────────────────────┐
│Stop           │                 ┌───────────────┐                     │Departure                  │
│ - NaPTANCode  │                 │Service        │                     │ - destination             │
│ - title       │                 │ - title       │                     │ - expectedDepartureDate   │
│ - liveDate    │────services────▶│ - stop        │──────departures────▶│ - countdownString         │
│ - laterURL    │                 │ - departures  │                     │ - minutesUntilDeparture   │
│ - earlierURL  │                 └───────────────┘                     │ - hasLowFloorAccess       │
│ - services    │                                                       │ - service                 │
└───────────────┘                                                       └───────────────────────────┘
```	 

Example of the instantiated objects from the above example for Meadowhall Intc.

```
                                                                 ┌─────────────────────┐
┌──────────────────────┐                                         │Departure            │
│Stop                  │        ┌───────────────────┐            │ - Sheffield Intc    │
│ - 37010200           │        │Service            │            │ - 6:15 PM           │
│ - Meadowhall Intc    │───┬───▶│ - X78             ├─────┬─────▶│ - Due               │
│ - 31/07/14 6:00 PM   │   │    │ - Meadowhall Intc │     │      │ - 0                 │
└──────────────────────┘   │    └───────────────────┘     │      │ - X78               │
                           │                              │      └─────────────────────┘
                           │                              │      ┌─────────────────────┐
                           │                              │      │Departure            │
                           │                              │      │ - Sheffield Intc    │
                           │                              │      │ - 6:18 PM           │
                           │                              ├─────▶│ - 3 Mins            │
                           │                              │      │ - 3                 │
                           │                              │      │ - X78               │
                           │                              │      └─────────────────────┘
                           │                              │      ┌─────────────────────┐
                           │                              │      │Departure            │
                           │                              │      │ - Sheffield Intc    │
                           │                              │      │ - 6:40 PM           │
                           │                              └─────▶│ - 6:40 PM           │
                           │                                     │ - 25                │
                           │                                     │ - X78               │
                           │                                     └─────────────────────┘
                           │                                     ┌─────────────────────┐
                           │                                     │Departure            │
                           │   ┌───────────────────┐             │ - Low Edges         │
                           │   │Service            │             │ - 6:15 PM           │
                           ├──▶│ - 76              │────────────▶│ - Due               │
                           │   │ - Meadowhall Intc │             │ - 0                 │
                           │   └───────────────────┘             │ - 76                │
                           │                                     └─────────────────────┘
                           │                                     ┌─────────────────────┐
                           │                                     │Departure            │
                           │   ┌───────────────────┐             │ - Jordanthorpe      │
                           │   │Service            │             │ - 6:20 PM           │
                           ├──▶│ - 38              │──────┬─────▶│ - 5 Mins            │
                           │   │ - Meadowhall Intc │      │      │ - 5                 │
                           │   └───────────────────┘      │      │ - 38                │
                           │                              │      └─────────────────────┘
                           │                              │      ┌─────────────────────┐
                           │                              │      │Departure            │
                           │                              │      │ - Sheffield Intc    │
                           │                              │      │ - 6:33 PM           │
                           │                              └─────▶│ - 18 Mins           │
                           │                                     │ - 18                │
                           │                                     │ - 38                │
                           │                                     └─────────────────────┘
                           │                                     ┌─────────────────────┐
                           │                                     │Departure            │
                           │    ┌───────────────────┐            │ - Hillsborough Intc │
                           │    │Service            │            │ - 6:40 PM           │
                           └───▶│ - 35              │───────────▶│ - 25 Mins           │
                                │ - Meadowhall Intc │            │ - 25                │
                                └───────────────────┘            │ - 35                │
                                                                 └─────────────────────┘
```
