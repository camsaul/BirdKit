//
//  NSString+BirdKit.h
//  BirdKit
//
//  Created by Cameron Saul on 2/21/12.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BirdKit)

- (NSString *)stringByDecodingHTML;
- (NSString *)stringByEncodingHTML;
- (NSString *)stringByRemovingHTMLTags;
- (BOOL)containsString:(NSString *)otherString;
- (NSInteger)distanceFromString:(NSString *)otherString;

@end
