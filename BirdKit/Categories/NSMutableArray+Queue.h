//
//  NSMutableArray+Queue.h
//  BirdKit
//
//  Created by Cameron Saul on 6/15/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Provides dequeue and enqueue methods to use a NSMutableArray like a queue.
 * From http://stackoverflow.com/a/936497/1198455
 */
@interface NSMutableArray (Queue)

/**
 * Returns (and removes) the first (oldest) object in the queue.
 * Returns nil if no objects are currently in the queue.
 */
- (id)dequeue;

/**
 * Adds a new object to the end of the queue.
 */
- (void)enqueue:(id)obj;

@end
