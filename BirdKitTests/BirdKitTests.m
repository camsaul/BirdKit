//
//  BirdKitTests.m
//  BirdKitTests
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "NSDictionary+BirdKit.h"
#import <XCTest/XCTest.h>

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

- (void)testNSDictionarySubtraction {
	const NSString *key1 = @"a", *key2 = @"b", *key3 = @"c";
	const NSString *val1 = @"1", *val2 = @"2", *val3 = @"3";
	NSDictionary *first = @{key1: val1, key2: val2, key3: val3};
	NSDictionary *second = @{key1: val1, key2: val2};
	
	NSDictionary *subtraction = [first dictionaryBySubtractingDictionary:second];
	XCTAssertEqualObjects(subtraction, @{key3: val3}, @"After subtracting the second dictionary, we should only have the key3/val3 pair remaining.");
}

@end
