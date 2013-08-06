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
#import "BKUtility.h"

static CLGeocoder *__geocoder;
static BOOL __activeRequest;

@interface BKGeocoderResult ()
PROP_STRONG NSString *name;
PROP_STRONG NSString *streetAddress;
PROP CLLocationCoordinate2D coordinate;
@end

@implementation BKGeocoderResult
- (BOOL)isEqual:(BKGeocoderResult *)another {
	if ([another class] != [self class]) return NO;
	return (CLLocationCoordinatesEqual(self.coordinate, another.coordinate)); // consider them to be same geocoding result if they have same coordinates
}
@end

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

+ (void)geocodeStreetAddress:(NSString *)streetAddress city:(NSString *)city state:(NSString *)state zipCode:(NSNumber *)zipCode country:(NSString *)country completion:(BKGeocodingCompletionBlock)completionBlock {
	if (streetAddress.length < 3) {
		completionBlock(nil); // too short to even try searching yet
		return;
	}
	NSAssert(city.length || state.length || zipCode, @"please provide either city or state.");
    NSMutableDictionary *locationDictionary = [@{(id)kABPersonAddressCountryKey: country ? country : @"United States",
												 (id)kABPersonAddressStreetKey: streetAddress} mutableCopy];
	if (city.length) {
		locationDictionary[(id)kABPersonAddressCityKey] = city;
	}
	if (state.length) {
		locationDictionary[(id)kABPersonAddressStateKey] = state;
	}
	if (zipCode) {
		locationDictionary[(id)kABPersonAddressZIPKey] = [zipCode description];
	}
    [[[CLGeocoder alloc] init] geocodeAddressDictionary:locationDictionary completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count == 0) {
            completionBlock(nil);
            return;
        }
		
		BKLog(LogFlagInfo, LogCategoryLocation, @"%d results for '%@' geocoding", placemarks.count, streetAddress);
        
        NSMutableArray *results = [NSMutableArray array];
        for (CLPlacemark *placemark in placemarks) {
            NSString *name = placemark.name ? placemark.name : streetAddress;
            NSString *streetAddress = nil;
            if (placemark.thoroughfare && placemark.subThoroughfare) {
                streetAddress = [NSString stringWithFormat:@"%@ %@", [placemark subThoroughfare], [placemark thoroughfare]];
            } else if (placemark.thoroughfare) {
                streetAddress = placemark.thoroughfare;
            } else if (placemark.subThoroughfare) {
                streetAddress = placemark.subThoroughfare;
            }
            if (placemark.locality) {
                if (streetAddress) {
                    streetAddress = [streetAddress stringByAppendingFormat:@", %@", placemark.locality];
                } else {
                    streetAddress = placemark.locality;
                }
            }
            if (placemark.administrativeArea) {
                if (streetAddress) {
                    streetAddress = [streetAddress stringByAppendingFormat:@", %@", placemark.administrativeArea];
                } else {
                    streetAddress = placemark.administrativeArea;
                }
            }
			BKGeocoderResult *result = [[BKGeocoderResult alloc] init];
			result.streetAddress = streetAddress;
			result.name = name;
			result.coordinate = placemark.location.coordinate;
			[results addObject:result];
        }
        completionBlock(results);
    }];
}


@end
