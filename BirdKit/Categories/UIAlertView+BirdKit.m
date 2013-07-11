//
//  UIAlertView+BirdKit.m
//  BirdKit
//
//  Created by Cameron Saul on 7/10/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "UIAlertView+BirdKit.h"
#import <objc/runtime.h>

static char AlertViewButtonPressedBlockKey;

@implementation UIAlertView (BirdKit)

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle {
	[[[self alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil] show];
}

+ (void)showAlertWithTitle:(NSString *)title
				   message:(NSString *)message
		buttonPressedBlock:(AlertViewButtonPressedBlock)buttonPressedBlock
		 cancelButtonTitle:(NSString *)cancelButtonTitle
		 otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {
	
	UIAlertView *alertView = [[self alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
	
	if (buttonPressedBlock) {
		alertView.delegate = alertView;
		objc_setAssociatedObject(alertView, &AlertViewButtonPressedBlockKey, buttonPressedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
	}
	[alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	AlertViewButtonPressedBlock block = objc_getAssociatedObject(alertView, &AlertViewButtonPressedBlockKey);
	if (block) {
		block(buttonIndex == self.cancelButtonIndex, buttonIndex);
	}
}

@end
