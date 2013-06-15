//
//  UIColor+BirdKit.h
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (BirdKit)

+ (UIColor *)colorWithHexString:(NSString *)string; // must be 6 digits (or 7 with a '#' at the beginning)

@end
