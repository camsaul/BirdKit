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
	
	__block NSArray *allObjects = self.allObjects;
	return [NSSet setWithArray:[allObjects map:block]];
}

@end

NSSet *filter_s(SetFilterBlock filterBlock, NSSet *set) {
	if (!set) return nil;
	if (!set.count) return set;
	
	NSMutableSet *mSet = [NSMutableSet set];
	for (id obj in set) {
		if (filterBlock(obj)) [mSet addObject:obj];
	}
	return mSet;
}
