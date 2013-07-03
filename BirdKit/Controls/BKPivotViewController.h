//
//  BKPivotViewController.h
//  BirdKit
//
//  Created by Cameron Saul on 5/12/12.
//  Copyright (c) 2012-2013 Lucky Bird, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKUtility.h"
#import "UIView+BirdKit.h"

@protocol BKPivotViewControllerDelegate;

/**
 * BKPivotViewController implements a horizontally scrolling view controller with multiple pages --
 * similiar to (and inspired by) Windows Phone's PivotView.
 *
 * BKPivotViewController lazily loads pages as needed, and as such, 
 */
@interface BKPivotViewController : UIViewController <UIScrollViewDelegate>

/// Page the pivot should start on
@property (nonatomic) NSUInteger startingPage;

/// Current page index displayed by the pivot.
- (NSUInteger)currentPage;
///  Setting this property will scroll to the page at that index.
- (void)scrollToPageAtIndex:(NSUInteger)index animated:(BOOL)animated;

@property (nonatomic) BOOL scrollEnabled;

/// Amount the next page "peeks" from the right side of the pivot, in pixels. Default is 20.
@property (nonatomic) CGFloat peekAmount;
/// length of time for fade-in/fade-out (etc) animations, in seconds. Default is 0.4
@property (nonatomic) CGFloat animationDuration;

@property (nonatomic, weak) id<BKPivotViewControllerDelegate> delegate;

/// Reload all pages
- (void)reloadPagesAnimated:(BOOL)animated;
/// Reload a page at index
- (void)reloadPageAtIndex:(NSUInteger)index animated:(BOOL)animated;

/// Returns YES if the view is the one being displayed for the current page.
- (BOOL)viewIsCurrentPage:(UIView *)view;

@end

@protocol BKPivotViewControllerDelegate <NSObject>
/// Delegate should return the number of pages in the pivot view.
- (NSUInteger)pivotViewNumberOfPages;
/// This method is called when the pivot view is going to load a page. You can let a view extend multiple pages by setting pageSpan to a number greater than 1 (the default).
/// You can just pass nil for the view for those pages.
- (UIView *)pivotViewControllerViewForPageAtIndex:(NSUInteger)index pageSpan:(NSUInteger *)pageSpan;

@optional
/// Called when the pivot VC moves (e.g., users swipes to) a page.
- (UIView *)pivotViewControllerDidScrollToIndex:(NSUInteger)index;
@end