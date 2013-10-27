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

/// Returns YES if this self contains otherString. Case-sensitive.
/// @seealso containsString:options:
- (BOOL)containsString:(NSString *)otherString;

/// Returns YES if self contains other string, with optional options, such as NSCaseInsensitiveSearch or NSDiacriticInsensitiveSearch
- (BOOL)containsString:(NSString *)otherString options:(NSStringCompareOptions)options;

/// Returs YES if self contains other string, case-insensitive and diacritic insensitive.
/// @seealso containsString: (case-sensitive) and containsString:options:
- (BOOL)containsStringCaseAndDiacriticInsensitve:(NSString *)otherString;

- (NSInteger)distanceFromString:(NSString *)otherString;

@end
