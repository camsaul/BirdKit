//
//  UIButton+BirdKit.m
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "UIButton+BirdKit.h"

@implementation UIButton (BirdKit)

- (void)addTarget:(id)target action:(SEL)action {
	[self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
