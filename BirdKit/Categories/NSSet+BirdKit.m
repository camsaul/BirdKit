//
//  NSSet+BirdKit.m
//  BirdKit
//
//  Created by Cameron Saul on 8/16/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "NSSet+BirdKit.h"
#import "NSArray+BirdKit.h"

@implementation NSSet (BirdKit)

- (NSSet *)map:(SetMapBlock)block {
	if (!self) return [NSSet set];
	
	return [NSSet setWithArray:[self.allObjects map:block]];
}

@end
