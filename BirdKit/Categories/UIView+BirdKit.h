//
//  UIView+BirdKit.h
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

@import UIKit;

static const int HiddenButtonTag = 987654;

/// Save ourselves a bit of typing by defining some really common resizing masks here
static const UIViewAutoresizing UIViewAutoresizingFlexibleVerticalMargins	= UIViewAutoresizingFlexibleTopMargin		| UIViewAutoresizingFlexibleBottomMargin;
static const UIViewAutoresizing UIViewAutoresizingFlexibleHorizontalMargins = UIViewAutoresizingFlexibleLeftMargin		| UIViewAutoresizingFlexibleRightMargin;
static const UIViewAutoresizing UIViewAutoresizingFlexibleMargins			= UIViewAutoresizingFlexibleVerticalMargins	| UIViewAutoresizingFlexibleHorizontalMargins;
static const UIViewAutoresizing UIViewAutoresizingFlexibleSize				= UIViewAutoresizingFlexibleHeight			| UIViewAutoresizingFlexibleWidth;

typedef void(^Transform3DCompletionBlock)();

@interface UIView (BirdKit)

- (CGPoint)origin;
- (CGFloat)xOrigin;
- (CGFloat)yOrigin;
/// the maximum x edge of the view, equal to (xOrigin + width)
- (CGFloat)maxX;
/// the maximum y edge of the view, equal to (yOrigin + height)
- (CGFloat)maxY;
- (CGFloat)centerX;
- (CGFloat)centerY;
- (CGPoint)boundsCenter;
- (CGFloat)halfWidth;
- (CGFloat)halfHeight;
- (CGSize)size;
- (CGFloat)width;
- (CGFloat)height;
- (void)setOrigin:(CGPoint)origin;
- (void)setXOrigin:(CGFloat)xOrigin;
- (void)setYOrigin:(CGFloat)yOrigin;
/// Sets view.center with a new x value, keeping the original y value.
- (void)setCenterX:(CGFloat)centerX;
/// Sets view.center with a new y value, keeping the original x value.
- (void)setCenterY:(CGFloat)centerY;
- (void)setSize:(CGSize)size;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
/// Adjusts the center point of the view to make its right edge (xOrigin + width) equal to this amount.
- (void)setMaxX:(CGFloat)maxX;
/// Adjusts the center point of the view to make its bottom edge (yOrigin + height) equal to this amount.
- (void)setMaxY:(CGFloat)maxY;

- (CGRect)frameIfCenteredInSuperview;

/// Helper method to add constraints by an array of visual format strings to views passed in viewsDictionary.
- (void)addConstraints:(NSArray *)visualFormatStrings views:(NSDictionary *)viewsDictionary;
/// Helper method to add constraints by an array of visual format strings to views passed in viewsDictionary, using metrics in metrics dictionary.
- (void)addConstraints:(NSArray *)visualFormatStrings metrics:(NSDictionary *)metrics views:(NSDictionary *)viewsDictionary;

/// Helper method to add a constraint to keep this view centered horizontally in its superview.
- (void)addConstraintToCenterViewHorizontally:(UIView *)view;
/// Helper method to add a constraint to keep this view centered vertically in its superview.
- (void)addConstraintToCenterViewVertically:(UIView *)view;

- (void)setBorderColor:(UIColor *)color;
- (void)setBorderWidth:(CGFloat)width;

- (UIButton *)hiddenButton;
- (void)addHiddenButton;
/// override this to reposition the hidden button if needed
- (void)hiddenButtonAdded;
- (void)removeHiddenButton;
/// default action is to call hideKeyboard. Override if needed
- (void)hiddenButtonPressed;

/// calls resignFirstResponder on all subviews
- (void)hideKeyboard;
/// called after hideKeyboard, in case you want to add additional functionality without rewriting the hideKeyboard method
- (void)keyboardDidHide;

- (void)removeAllSubviews;
- (void)removeSubviewWithTag:(int)tag;

#pragma mark - 3D Animations


/// Duration of 0 is considered to mean "animated = NO"
+ (void)apply3DTransform:(CATransform3D)transform toView:(UIView *)view duration:(CGFloat)duration completion:(Transform3DCompletionBlock)completion;

@end
