//
//  NSSet+BirdKit.h
//  BirdKit
//
//  Created by Cameron Saul on 8/16/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

typedef id(^SetMapBlock)(id obj);

@interface NSSet (BirdKit)

/// Classic lisp mapping function, using blocks. Returns a new set of the results of applying block to every element in self.
/// If the block returns nil, no object will be added; thus, you can use this method to filter sets.
/// Of course, it is also possible that multiple items in self will return the same response to the block; only one object
/// will be added in that case.
/// Returns empty set if self is empty.
- (NSSet *)map:(SetMapBlock)block;

@end
