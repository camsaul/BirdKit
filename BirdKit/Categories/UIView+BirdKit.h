//
//  UIView+BirdKit.h
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

/// Save ourselves a bit of typing by defining some really common resizing masks here
static const UIViewAutoresizing UIViewAutoresizingFlexibleVerticalMargins	= UIViewAutoresizingFlexibleTopMargin		| UIViewAutoresizingFlexibleBottomMargin;
static const UIViewAutoresizing UIViewAutoresizingFlexibleHorizontalMargins = UIViewAutoresizingFlexibleLeftMargin		| UIViewAutoresizingFlexibleRightMargin;
static const UIViewAutoresizing UIViewAutoresizingFlexibleMargins			= UIViewAutoresizingFlexibleVerticalMargins	| UIViewAutoresizingFlexibleHorizontalMargins;
static const UIViewAutoresizing UIViewAutoresizingFlexibleSize				= UIViewAutoresizingFlexibleHeight			| UIViewAutoresizingFlexibleWidth;

typedef void(^Transform3DCompletionBlock)();

@interface UIView (BirdKit)

/// Shorthand for self.frame.origin.
- (CGPoint)origin;
/// Shorthand for self.frame.origin.x
- (CGFloat)xOrigin;
/// Shorthand for self.frame.origin.y
- (CGFloat)yOrigin;
/// the maximum x edge of the view, equal to (xOrigin + width)
- (CGFloat)maxX;
/// the maximum y edge of the view, equal to (yOrigin + height)
- (CGFloat)maxY;
/// shorthand for self.center.x
- (CGFloat)centerX;
/// shorthand for self.center.y
- (CGFloat)centerY;
/// returns the rounded point in the center of the bounds
- (CGPoint)boundsCenter;
/// returns roundf(self.width / 2.0)
- (CGFloat)halfWidth;
/// returns roundf(self.height / 2.0)
- (CGFloat)halfHeight;
/// shorthand for self.bounds.size
- (CGSize)size;
/// shorthand for self.bounds.size.width
- (CGFloat)width;
/// shorthand for self.bounds.size.height
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
