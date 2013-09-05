//  -*-ObjC-*-
//  NSArray+BirdKit.h
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

@import Foundation;

typedef id(^ArrayMapBlock)(id obj);

@interface NSArray (BirdKit)

/// Modeled after Ruby's "where" functionality. Takes a NSPredicate format string and any arguments to it.
/// Basically just shorthand for using filteredArrayUsingPredicate:.
///
/// @param predicateFormat e.g. "name LIKE(c) 'Ca*'"
/// @see xcdoc://ios/documentation/Cocoa/Conceptual/Predicates/predicates.html
- (NSArray *)where:(NSString *)predicateFormat, ...;

/*** The following methods are modelled after various Lisp/Clojure functions. ***/

/// Returns a new array that alternates items from self and another until one runs out of items.
/// e.g. [@[1 2 3] interleave:@[A B]] -> @[1 A 2 B]
- (NSArray *)interleave:(NSArray *)another;

/// Splits an array into arrays of partitionSize items. The last array may be smaller than the rest.
/// e.g. [@[1 2 3 4 5] partition:2] -> @[@[1 2] @[3 4] @[5]]
/// if partitionSize > self.count, will just return self.
- (NSArray *)partition:(NSUInteger)partitionSize;

/// Classic lisp mapping function, using blocks. Returns a new array of the results of applying block to every element in self.
/// If the block returns nil, no object will be added; thus, you can use this method to filter arrays.
/// Returns empty array if self is empty.
- (NSArray *)map:(ArrayMapBlock)block;

/// Classic lisp mapping function, using a selector. Returns a new array of the results of calling method on every object in array.
- (NSArray *)mapm:(SEL)sel;

#define MAP(METHOD_NAME, NSARRAY) [NSARRAY mapm:@selector(METHOD_NAME)]
#define MAPB(ARRAY_MAP_BLOCK, NSARRAY) [NSARRAY map:ARRAY_MAP_BLOCK]

@end