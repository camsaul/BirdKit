//
//  BKEdgeSwipeGestureRecognizer.m
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "BKEdgeSwipeGestureRecognizer.h"
#import "UIView+BirdKit.h"

@interface BKEdgeSwipeGestureRecognizer()
PROP UISwipeGestureRecognizerDirection swipeDirection;
PROP CGFloat swipeAmount;
PROP CGPoint swipeStartPoint;
PROP BOOL currentlyTrackingSwipe;
@end

@implementation BKEdgeSwipeGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action {
	self = [super initWithTarget:target action:action];
	if (self) {
		self.minimumNumberOfTouches = 1;
		self.maximumNumberOfTouches = 1;
		self.edgeThreshold = 40;
		self.edgeAmount = 0.4;
	}
	return self;
}

- (UISwipeGestureRecognizerDirection)validDirectionForStartPoint:(const CGPoint)startPoint {
	const int x = startPoint.x;
	const int y = startPoint.y;
	
	const float minEdgeAmount = self.edgeAmount / 2.0f;
	const float maxEdgeAmount = minEdgeAmount * 3.0f;
	
	const int hSwipeMinY = self.view.height * minEdgeAmount;
	const int hSwipeMaxY = self.view.height * maxEdgeAmount;
	const int vSwipeMinX = self.view.width * minEdgeAmount;
	const int vSwipeMaxX = self.view.width * maxEdgeAmount;
	
	const BOOL validHSwipeYPosition = y > hSwipeMinY && y < hSwipeMaxY;
	const BOOL validVSwipeXPosition = x > vSwipeMinX && vSwipeMaxX;
	
	if		(x < self.edgeThreshold && validHSwipeYPosition)							return UISwipeGestureRecognizerDirectionRight;	// left edge, swipe right
	else if (x > (self.view.width - self.edgeThreshold) && validHSwipeYPosition)		return UISwipeGestureRecognizerDirectionLeft;	// right edge, swipe left
	else if (y < self.edgeThreshold && validVSwipeXPosition)							return UISwipeGestureRecognizerDirectionDown;	// top edge, swipe down
	else if (y > (self.view.height - self.edgeThreshold) && validVSwipeXPosition)	return UISwipeGestureRecognizerDirectionUp;		// bottom edge, swipe up
	
	else return NSNotFound;
}

- (CGFloat)absoulteSwipeAmount {
	return ABS(self.swipeAmount);
}

- (void)reset {
	[super reset];
	self.currentlyTrackingSwipe = NO;
	self.swipeDirection = NSNotFound;
	self.swipeAmount = 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
		
    if (self.currentlyTrackingSwipe || self.numberOfTouches < self.minimumNumberOfTouches || self.numberOfTouches > self.maximumNumberOfTouches) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
	self.currentlyTrackingSwipe = YES;
	UITouch *touch = (UITouch *)[touches anyObject];
	CGPoint touchLocation = [touch locationInView:self.view];
	self.swipeDirection = [self validDirectionForStartPoint:touchLocation];
	
	if ((int)self.swipeDirection == NSNotFound) {
		self.state = UIGestureRecognizerStateFailed;
		return;
	}
	
	self.state = UIGestureRecognizerStateBegan;
	self.swipeStartPoint = touchLocation;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
	
    if (self.state == UIGestureRecognizerStateFailed) return;
	
	if (self.numberOfTouches < self.minimumNumberOfTouches || self.numberOfTouches > self.maximumNumberOfTouches) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
	UITouch *touch = (UITouch *)[touches anyObject];
	const CGPoint newPoint = [touch locationInView:self.view];

	const CGFloat dx = newPoint.x - self.swipeStartPoint.x;
	const CGFloat dy = newPoint.y - self.swipeStartPoint.y;
	const CGFloat absDy = ABS(dy);
	const CGFloat absDx = ABS(dx);
	
	const BOOL isHorizontal = absDx > absDy;
	const BOOL isVertical = !isHorizontal;
	const BOOL isPositive = isHorizontal ? (dx > 0) : (dy > 0);
	const BOOL isNegative = !isPositive;
	
	if (isHorizontal && ((isPositive && self.swipeDirection == UISwipeGestureRecognizerDirectionRight) || (isNegative && self.swipeDirection == UISwipeGestureRecognizerDirectionLeft))) {
		self.swipeAmount = dx;
		self.state = UIGestureRecognizerStateChanged;
	} else if (isVertical && ((isPositive && self.swipeDirection == UISwipeGestureRecognizerDirectionDown) || (isNegative && self.swipeDirection == UISwipeGestureRecognizerDirectionUp))) {
		self.swipeAmount = dy;
		self.state = UIGestureRecognizerStateChanged;
	} else {
		self.swipeDirection = NSNotFound;
		self.swipeAmount = 0;
		self.state = UIGestureRecognizerStateFailed;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
	if (self.state != UIGestureRecognizerStateFailed) {
		self.state = UIGestureRecognizerStateRecognized;
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
	self.swipeDirection = NSNotFound;
	self.swipeAmount = 0;
    self.state = UIGestureRecognizerStateFailed;
}

@end
