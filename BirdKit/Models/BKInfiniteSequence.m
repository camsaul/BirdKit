//
//  BKLazyArray.m
//  BirdKit
//
//  Created by Cameron Saul on 8/15/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "BKInfiniteSequence.h"

@interface BKInfiniteSequence () {
	// these are ivars for performance reasons
	__strong NSArray *_sequence;
	NSUInteger _sequenceLength;
}
@end

@implementation BKInfiniteSequence

+ (BKInfiniteSequence *)infiniteSequenceOfObject:(id)object {
	BKInfiniteSequence *is = [[BKInfiniteSequence alloc] init];
	is->_sequence = @[object];
	is->_sequenceLength = 1;
	return is;
}

+ (BKInfiniteSequence *)infiniteSequenceOfObjects:(NSArray *)objects {
	BKInfiniteSequence *is = [[BKInfiniteSequence alloc] init];
	is->_sequence = objects;
	is->_sequenceLength = objects.count;
	return is;
}

- (NSUInteger)count {
	return INT_MAX;
}

- (id)objectAtIndex:(NSUInteger)index {
	return self->_sequence[index % _sequenceLength];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<BKInfiniteSequnce>: %@", self->_sequence.description];
}

- (BOOL)isEqual:(id)object {
	if (self.class != [object class]) return NO;
	return [self isEqualToArray:object];
}

- (BOOL)isEqualToArray:(BKInfiniteSequence *)otherArray {
	if (self.class != [otherArray class]) return NO;
	return [self->_sequence isEqualToArray:otherArray->_sequence];
}

- (id)copyWithZone:(NSZone *)zone {
	BKInfiniteSequence *i = [[BKInfiniteSequence allocWithZone:zone] init];
	i->_sequence = [self->_sequence copyWithZone:zone];
	return i;
}

- (id)mutableCopy {
	NSAssert(NO, @"currently, BKInfiniteSequence does not support mutableCopy:.");
	return nil;
}

@end
