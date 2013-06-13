//
//  UIView+BirdKit.h
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

static const int HiddenButtonTag = 987654;

@interface UIView (BirdKit)

- (CGFloat)width;
- (CGFloat)height;

- (CGRect)frameIfCenteredInSuperview;

- (void)addConstraints:(NSArray *)visualFormatStrings views:(NSDictionary *)viewsDictionary;
- (void)addConstraints:(NSArray *)visualFormatStrings metrics:(NSDictionary *)metrics views:(NSDictionary *)viewsDictionary;

- (void)addConstraintToCenterViewHorizontally:(UIView *)view;
- (void)addConstraintToCenterViewVertically:(UIView *)view;

- (void)setBorderColor:(UIColor *)color;
- (void)setBorderWidth:(CGFloat)width;

- (UIButton *)hiddenButton;
- (void)addHiddenButton;
- (void)hiddenButtonAdded; // override this to reposition the hidden button if needed
- (void)removeHiddenButton;
- (void)hiddenButtonPressed; // default action is to call hideKeyboard. Override if needed

- (void)hideKeyboard; // calls resignFirstResponder on all subviews
- (void)keyboardDidHide; // called after hideKeyboard, in case you want to add additional functionality without rewriting the hideKeyboard method


@end
