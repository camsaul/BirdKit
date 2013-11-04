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
	DBKLog(LogFlagInfo, LogCategoryGeocoder, @"Reverse geocoding %f, %f", coordinate.latitude, coordinate.longitude);
	if (__activeRequest) {
		DBKLog(LogFlagInfo, LogCategoryGeocoder, @"An existing geocoding request has been canceled.");
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
		NSString *address = placemark.addressDictionary[@"Street"]; // <- what's the real constant key
		NSParameterAssert(!address || [address isKindOfClass:[NSString class]]);
		DBKLog(LogFlagInfo, LogCategoryGeocoder, @"Reverse geocoding result: %@", address);
		completionBlock(address);
	}];
}

+ (void)geocodeStreetAddress:(NSString *)requestedStreetAddress city:(NSString *)city state:(NSString *)state zipCode:(NSNumber *)zipCode
					 country:(NSString *)country inRegion:(CLRegion *)region completion:(BKGeocodingCompletionBlock)completionBlock {
	
	if (requestedStreetAddress.length < 3) {
		completionBlock(nil); // too short to even try searching yet
		return;
	}
	NSAssert(region, @"you must provide a region.");
	
	DBKLog(LogFlagInfo, LogCategoryGeocoder, @"geocoding %@, %@, %@, %@, %@", requestedStreetAddress, city, state, zipCode, country);
	
	if (__activeRequest) {
		DBKLog(LogFlagInfo, LogCategoryGeocoder, @"An existing geocoding request has been canceled.");
		[__geocoder cancelGeocode];
	}
	__activeRequest = YES;
	
	if (city.length) {
		requestedStreetAddress = [requestedStreetAddress stringByAppendingFormat:@", %@", city];
	}
	if (state.length) {
		requestedStreetAddress = [requestedStreetAddress stringByAppendingFormat:@", %@", state];
	}
	if (zipCode) {
		requestedStreetAddress = [requestedStreetAddress stringByAppendingFormat:@" %@", [zipCode description]];
	}
	if (!country) country = @"United States";
	requestedStreetAddress = [requestedStreetAddress stringByAppendingFormat:@", %@", country];
	
	[__geocoder geocodeAddressString:requestedStreetAddress inRegion:region completionHandler:^(NSArray *placemarks, NSError *error) {
		__activeRequest = NO;
		
        if (error || placemarks.count == 0) {
            completionBlock(nil);
            return;
        }
		
		DBKLog(LogFlagInfo, LogCategoryGeocoder, @"%d results for '%@' geocoding", placemarks.count, requestedStreetAddress);
        
        NSMutableArray *results = [NSMutableArray array];
        for (CLPlacemark *placemark in placemarks) {
            NSString *actualStreetAddress = nil;
            if (placemark.thoroughfare && placemark.subThoroughfare) {
                actualStreetAddress = [NSString stringWithFormat:@"%@ %@", [placemark subThoroughfare] /* 937A */, [placemark thoroughfare] /* Howard St */];
            } else if (placemark.thoroughfare) {
                actualStreetAddress = placemark.thoroughfare;
            } else if (placemark.subThoroughfare) {
                actualStreetAddress = placemark.subThoroughfare;
            }
			// want our name to be something like '937A Howard', otherwise try for placemark name (probably nil), otherwise just take the first part of whatever the user typed in
			NSString *name = actualStreetAddress.length ? actualStreetAddress : placemark.name.length ? placemark.name : [requestedStreetAddress componentsSeparatedByString:@","][0];
			
            if (placemark.locality) {
                if (actualStreetAddress) {
                    actualStreetAddress = [actualStreetAddress stringByAppendingFormat:@", %@", placemark.locality];
                } else {
                    actualStreetAddress = placemark.locality;
                }
            }
            if (placemark.administrativeArea) {
                if (actualStreetAddress) {
                    actualStreetAddress = [actualStreetAddress stringByAppendingFormat:@", %@", placemark.administrativeArea];
                } else {
                    actualStreetAddress = placemark.administrativeArea;
                }
            }
			BKGeocoderResult *result = [[BKGeocoderResult alloc] init];
			result.streetAddress = actualStreetAddress;
			result.name = name;
			result.coordinate = placemark.location.coordinate;
			[results addObject:result];
        }
        completionBlock(results);
    }];
}


@end
