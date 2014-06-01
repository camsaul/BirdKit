//  -*-ObjC-*-
//  NSObject+BirdKit.h
//  BirdKit
//
//  Created by Cameron Saul on 6/14/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

@interface NSObject (BirdKit)

- (NSArray *)keysForAllProperties;
- (NSDictionary *)keysAndValuesForAllProperties;

/// if the other object returns a non-nil value for this key, set our value to that. Basically a "merge"
- (void)setValueForKey:(NSString *)key withValueFromObjectIfNonNil:(id)anotherObject;

/// Makes a simple copy of an object by creating a new instance and setting all property values to a copied value if they support <NSCopying> or the current value if they don't.
/// A quick and dirty way to easily implement <NSCopying>
///
/// As of right now, DOES NOT WORK WITH NSNumbers for some reason!
- (id)copyByCopyingPropertiesWithZone:(NSZone *)zone; // __attribute__((deprecated));

@end
