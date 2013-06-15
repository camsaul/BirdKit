//
//  NSObject+BirdKit.m
//  BirdKit
//
//  Created by Cameron Saul on 6/14/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "NSObject+BirdKit.h"
#import <objc/runtime.h>

@implementation NSObject (BirdKit)

- (NSArray *)keysForAllProperties {
	NSMutableArray *propertyNames = [NSMutableArray array];
	unsigned int outCount, i;
	objc_property_t *properties = class_copyPropertyList([self class], &outCount);
	for (i = 0; i < outCount; i++) {
		objc_property_t property = properties[i];
		NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSASCIIStringEncoding];
		[propertyNames addObject:propertyName];
	}
	free(properties);
	return propertyNames;
}

- (NSDictionary *)keysAndValuesForAllProperties {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	for (NSString *key in [self keysForAllProperties]) {
		id val = [self valueForKey:key];
		if (val) {
			dict[key] = val;
		}
	}
	return dict;
}

- (void)setValueForKey:(NSString *)key withValueFromObjectIfNonNil:(id)anotherObject {
	id newVal = [anotherObject valueForKey:key];
	if (newVal) {
		[self setValue:newVal forKey:key];
	}
}

- (id)copyByCopyingPropertiesWithZone:(NSZone *)zone {
	id new = [[[self class] allocWithZone:zone] init];
	[[self keysAndValuesForAllProperties] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		if ([obj respondsToSelector:@selector(copyWithZone:)]) {
			[new setValue:[obj copy] forKey:key];
		} else {
			[new setValue:obj forKey:key];
		}
	}];
	return new;
}


@end
