//
//  NSArray+BirdKit.h
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

@import Foundation;

@interface NSArray (BirdKit)

/// Modeled after Ruby's "where" functionality. Takes a NSPredicate format string and any arguments to it.
///
/// Basically just shorthand for using filteredArrayUsingPredicate:.
///
/// @param predicateFormat e.g. "name LIKE(c) 'Ca*'"
/// @see xcdoc://ios/documentation/Cocoa/Conceptual/Predicates/predicates.html
- (NSArray *)where:(NSString *)predicateFormat, ...;

@end
