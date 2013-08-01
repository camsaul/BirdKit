//
//  BirdKitTests.m
//  BirdKitTests
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDictionary+BirdKit.h"
#import "NSMutableArray+Queue.h"

@interface BirdKitTests : XCTestCase

@end

@implementation BirdKitTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

#pragma mark - NSDictionary Subtraction

- (void)testNSDictionarySubtraction {
	const NSString *key1 = @"a", *key2 = @"b", *key3 = @"c";
	const NSString *val1 = @"1", *val2 = @"2", *val3 = @"3";
	NSDictionary *first = @{key1: val1, key2: val2, key3: val3};
	NSDictionary *second = @{key1: val1, key2: val2};
	
	NSDictionary *subtraction = [first dictionaryBySubtractingDictionary:second];
	XCTAssertEqualObjects(subtraction, @{key3: val3}, @"After subtracting the second dictionary, we should only have the key3/val3 pair remaining.");
}


#pragma mark - NSMutableDictionary+Queue

- (void)testQueue {
	NSMutableArray *ar = [NSMutableArray array];
	[ar enqueue:@(1)];
	[ar enqueue:@(1)];
	[ar enqueue:@(2)];
	XCTAssertEqual(ar.count, 3, @"enqueuing is broken!");
	
	NSNumber *res = [ar dequeue];
	XCTAssertEqual(ar.count, 2, @"dequeing is broken!");
	XCTAssertEqualObjects(res, @(1), @"dequeing is broken!");
	
	[ar dequeue];
	res = [ar dequeue];
	XCTAssertEqual(ar.count, 0, @"dequeing is broken!");
	XCTAssertEqualObjects(res, @(2), @"dequeing is broken!");
	
	// try calling one too many times
	[ar dequeue];
	[ar dequeue];
	
	// make sure we can-requeue
	[ar enqueue:@(5)];
	XCTAssertEqual(ar.count, 1, @"enqueuing is broken!");
}

@end
