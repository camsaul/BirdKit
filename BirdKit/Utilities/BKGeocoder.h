//
//  BKGeocoder.h
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BKGeocoder : NSObject

+ (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate completion:(void(^)(NSString *addressOrNil))completionBlock;

@end