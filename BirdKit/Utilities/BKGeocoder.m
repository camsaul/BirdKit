//
//  BKGeocoder.m
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "BKGeocoder.h"
#import "BKLogging.h"
#import "NSMutableArray+Queue.h"

static CLGeocoder *__geocoder;
static BOOL __activeRequest;

@implementation BKGeocoder

+ (void)load {
	__geocoder = [[CLGeocoder alloc] init];
}

+ (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate completion:(BKReverseGeocdoingCompletionBlock)completionBlock {
	if (__activeRequest) {
		[__geocoder cancelGeocode];
	}
	
	__activeRequest = YES;
	[__geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] completionHandler:^(NSArray *placemarks, NSError *error) {
		__activeRequest = NO;
		
		if (error || !placemarks[0]) {
			completionBlock(nil);
			return;
		}
		CLPlacemark *placemark = placemarks[0];
		NSString *address = placemark.addressDictionary[@"Street"];
		BKLog(LogFlagInfo, LogCategoryLocation, @"Reverse Geocoder: %@", address);
		completionBlock(address);
	}];
}

@end
