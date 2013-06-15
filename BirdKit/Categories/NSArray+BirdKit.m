//
//  NSArray+BirdKit.m
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "NSArray+BirdKit.h"

@implementation NSArray (BirdKit)

- (id)firstObjectOrNil {
	if (!self.count) return nil;
	return self[0];
}

@end
