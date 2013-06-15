//
//  BKGeocoder.m
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "BKGeocoder.h"
#import "BKLogging.h"

@implementation BKGeocoder

+ (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate completion:(void(^)(NSString *address))completionBlock {
	CLGeocoder *geocoder = [[CLGeocoder alloc] init];
	[geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] completionHandler:^(NSArray *placemarks, NSError *error) {
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
