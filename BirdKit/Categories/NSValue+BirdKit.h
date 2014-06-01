//  -*-ObjC-*-
//  NSValue+BirdKit.h
//  BirdKit
//
//  Created by Cameron Saul on 6/15/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

@interface NSValue (BirdKit)

+ (NSValue *)valueWithMKCoordinateRegion:(MKCoordinateRegion)region;
- (MKCoordinateRegion)MKCoordinateRegionValue;

@end
