//
//  NSArray+BirdKit.m
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "NSArray+BirdKit.h"

@implementation NSArray (BirdKit)

- (NSArray *)where:(NSString *)predicateFormat, ... {
	va_list args;
    va_start(args, predicateFormat);
	NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat arguments:args];
	va_end(args);
	
	return [self filteredArrayUsingPredicate:predicate];
}

- (NSArray *)interleave:(NSArray *)another {
	unsigned	remainingInSelf = self.count,
				remainingInAnother = another.count,
				idx = 0,
				resultSize = MIN(remainingInSelf, remainingInAnother) * 2;
	
	if (!resultSize) return nil;

	NSMutableArray *m = [NSMutableArray arrayWithCapacity:resultSize];
	while (remainingInSelf > 0 && remainingInAnother > 0) {
		[m addObject:self[idx]];
		[m addObject:another[idx]];
		remainingInSelf--;
		remainingInAnother--;
		idx++;
	}
	return m;
}

/// Splits an array into arrays of numPartitions items. The last array may be smaller than the rest.
/// e.g. [@[1 2 3 4 5] partition:2] -> @[@[1 2] @[3 4] @[5]]
- (NSArray *)partition:(NSUInteger)partitionSize {
	unsigned count = self.count;
	if (partitionSize > count) return self;
	
	unsigned numPartitions = (unsigned)ceilf((float)count / (float)partitionSize);
	
	NSMutableArray *partitions = [NSMutableArray arrayWithCapacity:numPartitions];
	for (unsigned i = 0; i < count; i++) {
		unsigned partitionNum = i / partitionSize;
		unsigned idxInPartition = i % partitionSize; // index relative to this partition
		
		NSMutableArray *partition = nil;
		if (idxInPartition == 0) {
			// first time seeing this partition, so create it
			partition = [NSMutableArray arrayWithCapacity:partitionSize];
			partitions[partitionNum] = partition;
		} else {
			partition = partitions[partitionNum];
		}
		
		partition[idxInPartition] = self[i];
	}
	
	return partitions;
}

- (NSArray *)map:(ArrayMapBlock)block {
	unsigned count = self.count;
	if (!count) return @[];
	NSMutableArray *m = [NSMutableArray arrayWithCapacity:count];
	for (int i = 0; i < count; i++) {
		__block id obj = self[i];
		id res = block(obj);
		if (res) [m addObject:res];
	}
	return m;
}

- (NSArray *)mapm:(SEL)sel {
	unsigned count = self.count;
	if (!count) return @[];
	NSMutableArray *m = [NSMutableArray arrayWithCapacity:count];
	for (int i = 0; i < count; i++) {
		id obj = self[i];
		IMP imp = [obj methodForSelector:sel];
		id res = imp(self[i], sel);
		if (res) [m addObject:res];
	}
	return m;
	
}

inline NSArray *mapm(SEL selector, NSArray *array) {
	return [array mapm:selector];
}

inline NSArray *mapb(ArrayMapBlock block, NSArray *array) {
	return [array map:block];
}

@end
