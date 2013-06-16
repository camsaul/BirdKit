//
//  NSMutableArray+Queue.m
//  BirdKit
//
//  Created by Cameron Saul on 6/15/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "NSMutableArray+Queue.h"

@implementation NSMutableArray (QueueAdditions)

- (id)dequeue {
    if ([self count] == 0) return nil;
    id head = [self objectAtIndex:0];
	[self removeObjectAtIndex:0];
	return head;
}

- (void)enqueue:(id)anObject {
    [self addObject:anObject]; // adds at the end of the array
}
@end