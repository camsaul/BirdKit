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

@end
