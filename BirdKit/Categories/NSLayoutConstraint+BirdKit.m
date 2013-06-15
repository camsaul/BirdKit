//
//  NSLayoutConstraint+BirdKit.m
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "NSLayoutConstraint+BirdKit.h"

@implementation NSLayoutConstraint (BirdKit)

+ (NSArray *)constraintsWithVisualFormat:(NSString *)format options:(NSLayoutFormatOptions)opts metrics:(NSDictionary *)metrics views:(NSDictionary *)views priority:(UILayoutPriority)priority {
	NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:opts metrics:metrics views:views];
	for (NSLayoutConstraint *constraint in constraints) {
		constraint.priority = priority;
	}
	return constraints;
}

+ (id)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
	return [self constraintWithItem:view1 attribute:attr1 relatedBy:relation toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:multiplier constant:constant];
}

+ (id)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr equalToSameAttributeOfItem:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
	return [self constraintWithItem:view1 attribute:attr relatedBy:NSLayoutRelationEqual toItem:view2 attribute:attr multiplier:multiplier constant:constant];
}

@end
