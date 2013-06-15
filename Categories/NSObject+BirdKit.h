//
//  NSObject+BirdKit.h
//  BirdKit
//
//  Created by Cameron Saul on 6/14/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BirdKit)

- (NSArray *)keysForAllProperties;
- (NSDictionary *)keysAndValuesForAllProperties;

/**
 * if the other object returns a non-nil value for this key, set our value to that. Basically a "merge"
 */
- (void)setValueForKey:(NSString *)key withValueFromObjectIfNonNil:(id)anotherObject;

/**
 * Makes a simple copy of an object by creating a new instance and setting all property values to a copied value if they support <NSCopying> or the current value if they don't.
 * A quick and dirty way to easily implement <NSCopying>
 */
- (id)copyByCopyingPropertiesWithZone:(NSZone *)zone;

@end
