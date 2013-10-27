//
//  UILabel+BirdKit.m
//  BirdKit
//
//  Created by Cameron Saul on 7/9/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "UILabel+BirdKit.h"

@implementation UILabel (BirdKit)

- (void)setTextPreservingExistingAttributes:(NSString *)text {
	if (self.attributedText.length) {
		if (text == nil) text = @" "; // empty string to preserve attributes
		NSDictionary *attributes = [(NSAttributedString *)self.attributedText attributesAtIndex:0 effectiveRange:NULL];
		self.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
	} else {
		self.text = text;
	}
}

@end
