//
//  UIColor+BirdKit.m
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "UIColor+BirdKit.h"

@implementation UIColor (BirdKit)

+ (UIColor *)colorWithHexString:(NSString *)string {
	if (string.length == 7 && [[string substringToIndex:1] isEqualToString:@"#"]) {
		return [UIColor colorWithHexString:[string substringFromIndex:1]];
	}
	
	NSAssert(string.length == 6, @"Hex string must be exactly six digits (not including optional '#' at beginning).");
	NSString *rString = [string substringWithRange:NSMakeRange(0, 2)];
	NSString *gString = [string substringWithRange:NSMakeRange(2, 2)];
	NSString *bString = [string substringWithRange:NSMakeRange(4, 2)];
	
	unsigned rValue;
	sscanf([rString UTF8String], "%x", &rValue);
	
	unsigned gValue;
	sscanf([gString UTF8String], "%x", &gValue);
	
	unsigned bValue;
	sscanf([bString UTF8String], "%x", &bValue);
	
	return [UIColor colorWithRed:((CGFloat)rValue / 255.0) green:((CGFloat)gValue / 255.0) blue:((CGFloat)bValue / 255.0) alpha:1.0];
}

@end
