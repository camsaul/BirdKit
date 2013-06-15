//
//  NSValue+BirdKit.m
//  BirdKit
//
//  Created by Cameron Saul on 6/15/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "NSValue+BirdKit.h"

@implementation NSValue (BirdKit)

+ (NSValue *)valueWithMKCoordinateRegion:(MKCoordinateRegion)region {
	return [NSValue value:&region withObjCType:@encode(MKCoordinateRegion)];
}

- (MKCoordinateRegion)MKCoordinateRegionValue {
	MKCoordinateRegion region;
	[self getValue:&region];
	return region;
}

@end
