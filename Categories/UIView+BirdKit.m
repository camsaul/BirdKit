//
//  UIView+BirdKit.m
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "UIView+BirdKit.h"
#import "NSLayoutConstraint+BirdKit.h"
#import "UIButton+BirdKit.h"

@implementation UIView (BirdKit)

- (CGFloat)width {
	return self.bounds.size.width;
}

- (CGFloat)height {
	return self.bounds.size.height;
}

- (CGRect)frameIfCenteredInSuperview {
	NSAssert(self.superview, @"must have a superview to call this method!");
	
	CGRect frame = self.frame;
	CGSize size = self.bounds.size;
	CGSize superviewSize = self.superview.bounds.size;
	
	frame.origin.x = round((superviewSize.width - size.width) / 2.0);
	frame.origin.y = round((superviewSize.height - size.height) / 2.0);
	
	return frame;
}

- (void)addConstraints:(NSArray *)visualFormatStrings views:(NSDictionary *)viewsDictionary {
	[self addConstraints:visualFormatStrings metrics:nil views:viewsDictionary];
}
- (void)addConstraints:(NSArray *)visualFormatStrings metrics:(NSDictionary *)metrics views:(NSDictionary *)viewsDictionary {
	if (!visualFormatStrings) return;
	
	for (NSString *vfString in visualFormatStrings) {
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfString options:0 metrics:metrics views:viewsDictionary priority:UILayoutPriorityRequired]];
	}
}

- (void)addConstraintToCenterViewHorizontally:(UIView *)view {
	[self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX equalToSameAttributeOfItem:self multiplier:1 constant:0]];
}
- (void)addConstraintToCenterViewVertically:(UIView *)view {
	[self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY equalToSameAttributeOfItem:self multiplier:1 constant:0]];
}


- (void)setBorderColor:(UIColor *)color {
	self.layer.borderColor = color.CGColor;
}

- (void)setBorderWidth:(CGFloat)width {
	self.layer.borderWidth = width;
}

- (UIButton *)hiddenButton {
	for (UIView *subview in self.subviews) {
		if (subview.tag == HiddenButtonTag) return (UIButton *)subview;
	}
	return nil;
}

- (void)addHiddenButton {
	if (self.hiddenButton) return;
	
	UIButton *hiddenButton = [UIButton buttonWithType:UIButtonTypeCustom];
	//	hiddenButton.backgroundColor = [UIColor rydeTransparentBlackOverlayColor];
	hiddenButton.tag = HiddenButtonTag;
	hiddenButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:hiddenButton];
	
	[self addConstraints:@[@"|[hiddenButton]|", @"V:|[hiddenButton]|"] views:NSDictionaryOfVariableBindings(hiddenButton)];
	
	[hiddenButton addTarget:self action:@selector(hiddenButtonPressed)];
	
	[self hiddenButtonAdded];
}

- (void)hiddenButtonAdded {}

- (void)removeHiddenButton {
	[self.hiddenButton removeFromSuperview];
}

- (void)hiddenButtonPressed {
	[self removeHiddenButton];
	[self hideKeyboard];
}

- (void)hideKeyboard {
	[self resignFirstResponder];
	for (UIView *subview in self.subviews) {
		[subview hideKeyboard];
	}
	[self keyboardDidHide];
}

- (void)keyboardDidHide {}


@end
