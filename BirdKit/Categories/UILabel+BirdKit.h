//  -*-ObjC-*-
//  UILabel+BirdKit.h
//  BirdKit
//
//  Created by Cameron Saul on 7/9/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (BirdKit)

/// By default setText: will reset text attributes such as text color
/// This method preserves these attributes so only the text changes.
- (void)setTextPreservingExistingAttributes:(NSString *)text;

@end
