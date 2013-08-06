//
//  BKGeocoder.h
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

typedef void(^BKReverseGeocdoingCompletionBlock)(NSString *addressOrNil);
typedef void(^BKGeocodingCompletionBlock)(NSArray *results);

@interface BKGeocoderResult : NSObject
- (NSString *)name;
- (NSString *)streetAddress;
- (CLLocationCoordinate2D)coordinate;
@end

@interface BKGeocoder : NSObject

/// According to Apple, you can only have one reverse geocoding request at any given moment, so calling this will cancel any exisiting requests (completion block will return nil).
+ (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate completion:(BKReverseGeocdoingCompletionBlock)completionBlock;

/// Geocodes address. City/State/Zip/Country are all optional.
/// If you don't provie a country, will default to 'United States'.
+ (void)geocodeStreetAddress:(NSString *)streetAddress city:(NSString *)city state:(NSString *)state zipCode:(NSNumber *)zipCode country:(NSString *)country inRegion:(CLRegion *)region completion:(BKGeocodingCompletionBlock)completionBlock;

@end
