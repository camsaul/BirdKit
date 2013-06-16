//
//  BKGeocoder.h
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

@import Foundation;
@import CoreLocation;

typedef void(^BKReverseGeocdoingCompletionBlock)(NSString *addressOrNil);

@interface BKGeocoder : NSObject

/**
 * According to apple, you can only have one reverse geocoding request at any given moment, so calling this will cancel any exisiting requests (completion block will return nil).
 */
+ (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate completion:(BKReverseGeocdoingCompletionBlock)completionBlock;

@end
