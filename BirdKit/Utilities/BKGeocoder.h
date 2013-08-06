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

/// Geocodes address. You must specify AT LEAST one of city/state/zip code. Upon completion, returns an array of BKGeocoderResult objects, or nil.
/// If you don't provie a country, will default to 'United States'.
+ (void)geocodeStreetAddress:(NSString *)streetAddress city:(NSString *)city state:(NSString *)state zipCode:(NSNumber *)zipCode country:(NSString *)country completion:(BKGeocodingCompletionBlock)completionBlock;

@end
