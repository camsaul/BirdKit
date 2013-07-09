//
//  NSDictionary+BirdKit.h
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

@import Foundation;

@interface NSDictionary (BirdKit)

- (NSDictionary *)dictionaryByMergingWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)dictionaryBySubtractingDictionary:(NSDictionary *)dictionary;

- (NSUInteger)deepCount;

// navigation service stuff

- (NSDictionary *)dictionaryByAddingValue:(NSObject *)value forKey:(NSString *)key;
- (BOOL)containsNumber:(NSString *)key;
- (NSInteger)valueForInteger:(NSString *)key;
- (float)valueForFloat:(NSString *)key;
- (double)valueForDouble:(NSString *)key;
- (BOOL)valueForBool:(NSString *)key;

@end
