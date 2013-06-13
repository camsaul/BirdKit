//
//  NSDictionary+BirdKit.h
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (BirdKit)

- (NSDictionary *)dictionaryByMergingWithDictionary:(NSDictionary *)dictionary;

@end
