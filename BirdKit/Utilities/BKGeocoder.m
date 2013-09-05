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
- (NSUInteger)hash {
	return (int)(self.coordinate.latitude * 7.0f) + (int)(self.coordinate.longitude * 3.0f);
}
- (NSString *)description {
	return [NSString stringWithFormat:@"<BKGeocoderResult>: %@, %@, %f, %f", self.name, self.streetAddress, self.coordinate.latitude, self.coordinate.longitude];
}
@end

@implementation BKGeocoder

+ (void)load {
	__geocoder = [[CLGeocoder alloc] init];
}

+ (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate completion:(BKReverseGeocdoingCompletionBlock)completionBlock {
	BKLog(LogFlagInfo, LogCategoryLocation, @"Reverse Geocoder: Reverse geocoding %f, %f", coordinate.latitude, coordinate.longitude);
	if (__activeRequest) {
		BKLog(LogFlagInfo, LogCategoryLocation, @"Reverse Geocoder: An existing geocoding request has been canceled.");
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

+ (void)geocodeStreetAddress:(NSString *)streetAddress city:(NSString *)city state:(NSString *)state zipCode:(NSNumber *)zipCode
					 country:(NSString *)country inRegion:(CLRegion *)region completion:(BKGeocodingCompletionBlock)completionBlock {
	
	if (streetAddress.length < 3) {
		completionBlock(nil); // too short to even try searching yet
		return;
	}
	NSAssert(region, @"you must provide a region.");
	
	BKLog(LogFlagInfo, LogCategoryLocation, @"Geocoder: geocoding %@, %@, %@, %@, %@", streetAddress, city, streetAddress, zipCode, country);
	
	if (__activeRequest) {
		BKLog(LogFlagInfo, LogCategoryLocation, @"Geocoder: An existing geocoding request has been canceled.");
		[__geocoder cancelGeocode];
	}
	__activeRequest = YES;
	
	if (city.length) {
		streetAddress = [streetAddress stringByAppendingFormat:@", %@", city];
	}
	if (state.length) {
		streetAddress = [streetAddress stringByAppendingFormat:@", %@", state];
	}
	if (zipCode) {
		streetAddress = [streetAddress stringByAppendingFormat:@" %@", [zipCode description]];
	}
	if (!country) country = @"United States";
	streetAddress = [streetAddress stringByAppendingFormat:@", %@", country];
	
	[__geocoder geocodeAddressString:streetAddress inRegion:region completionHandler:^(NSArray *placemarks, NSError *error) {
		__activeRequest = NO;
		
        if (error || placemarks.count == 0) {
            completionBlock(nil);
            return;
        }
		
		BKLog(LogFlagInfo, LogCategoryLocation, @"%d results for '%@' geocoding", placemarks.count, streetAddress);
        
        NSMutableArray *results = [NSMutableArray array];
        for (CLPlacemark *placemark in placemarks) {
            NSString *streetAddress = nil;
            if (placemark.thoroughfare && placemark.subThoroughfare) {
                streetAddress = [NSString stringWithFormat:@"%@ %@", [placemark subThoroughfare] /* 937A */, [placemark thoroughfare] /* Howard St */];
            } else if (placemark.thoroughfare) {
                streetAddress = placemark.thoroughfare;
            } else if (placemark.subThoroughfare) {
                streetAddress = placemark.subThoroughfare;
            }
			// want our name to be something like '937A Howard', otherwise just take the first part of placemark name (probably whatever the user typed in)
			NSString *name = streetAddress ? streetAddress : [placemark.name componentsSeparatedByString:@","][0];
			
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
