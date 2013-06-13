//
//  NSDictionary+BirdKit.m
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "NSDictionary+BirdKit.h"

@implementation NSDictionary (BirdKit)

- (NSDictionary *)dictionaryByMergingWithDictionary:(NSDictionary *)dictionary {
    NSMutableDictionary *result = [self mutableCopy];
	
	[dictionary enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
		if (![self objectForKey:key]) {
			if ([obj isKindOfClass:[NSDictionary class]]) {
				NSDictionary * newVal = [[self objectForKey:key] dictionaryByMergingWithDictionary:(NSDictionary *)obj];
				[result setObject:newVal forKey:key];
			} else {
				[result setObject:obj forKey:key];
			}
		}
	}];
	
	return result;
}

@end
