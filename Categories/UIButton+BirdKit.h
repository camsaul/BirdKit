//
//  UIButton+BirdKit.h
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (BirdKit)

- (void)addTarget:(id)target action:(SEL)action; // shorthand so you don't need to type out the action since 99.99% of the time we want TouchUpInside

@end
