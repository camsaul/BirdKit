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
		if (!self[key] || ![obj isKindOfClass:[NSDictionary class]]) {
			result[key] = obj;
		} else {
			result[key] = [self[key] dictionaryByMergingWithDictionary:(NSDictionary *)obj];
		}
	}];
	
	return result;
}

- (NSDictionary *)dictionaryBySubtractingDictionary:(NSDictionary *)another {
	NSMutableDictionary *result = [NSMutableDictionary dictionary];
	
	if ([self isEqualToDictionary:another]) {
		return nil;
	}
	
	[self enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
		id anotherObj = another[key];
		if (!anotherObj) {
			result[key] = obj;
		} else if ([obj isKindOfClass:[NSDictionary class]]) {
			NSDictionary *recursiveSubtraction = [obj dictionaryBySubtractingDictionary:anotherObj];
			if (recursiveSubtraction != nil) {
				result[key] = recursiveSubtraction;
			}
		} else if (![obj isEqual:anotherObj]) {
			result[key] = obj;
		}
	}];
	
	return result;
}

- (NSUInteger)deepCount {
	__block NSUInteger count = 0;
	[self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		if ([obj respondsToSelector:@selector(deepCount)]) {
			count += [obj deepCount];
		} else if ([obj respondsToSelector:@selector(count)]) {
			count += [obj count];
		} else {
			count++;
		}
	}];
	return count;
}

@end
