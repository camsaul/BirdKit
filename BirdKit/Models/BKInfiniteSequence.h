//
//  BKLazyArray.h
//  BirdKit
//
//  Created by Cameron Saul on 8/15/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/// An NSArray subclass (at least, one that acts like an NSArray) that repeats an object or serires of objects forever.
/// This allows you to things like [@[@1, @2, @3] interleave:[BKLazyArray infiniteSequenceOfObject:@"A"] -> @[@1, @"A", @2, @"B", @3, @"C"]
@interface BKInfiniteSequence : NSArray

/// Creates an array that acts as though it has an infinite number of repeating entries of a single object.
/// e.g. [BKInfiniteSequence infiniteSequenceOfObject:@1 -> @[@1, @1, @1...]
+ (BKInfiniteSequence *)infiniteSequenceOfObject:(id)object;

/// Creates an array that acts as though it has an infinite number of repeating entries of a series of objects.
/// e.g. [BKInfiniteSequence infiniteSequenceOfObjects:@[@1, @2, @3]] -> @[@1, @2, @3, @1, @2, @3 ...]
+ (BKInfiniteSequence *)infiniteSequenceOfObjects:(NSArray *)objects;

/// Always returns INT_MAX, since the sequence acts as though it were infinite.
/// @warning DO NOT TRY TO DO FOR/FOREACH LOOPS BASED ON THIS NUMBER!
- (NSUInteger)count;

@end
