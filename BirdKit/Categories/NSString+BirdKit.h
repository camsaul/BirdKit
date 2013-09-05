//  -*-ObjC-*-
//  NSString+BirdKit.h
//  BirdKit
//
//  Created by Cameron Saul on 2/21/12.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

@interface NSString (BirdKit)

- (NSString *)stringByDecodingHTML;

/// Encodes string to be used in an HTTP request; Shorthand for [self stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
- (NSString *)stringByEncodingHTML;

- (NSString *)stringByRemovingHTMLTags;

- (BOOL)containsString:(NSString *)otherString;

- (NSInteger)distanceFromString:(NSString *)otherString;

@end
