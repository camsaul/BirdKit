//
//  BKPivotViewController.m
//  BirdKit
//
//  Created by Cameron Saul on 5/12/12.
//  Copyright (c) 2012-2013 Lucky Bird, Inc. All rights reserved.
//

#import "BKPivotViewController.h"

@interface BKPivotViewController ()

@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic) NSUInteger currentPage;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;

/// If we haven't attempted to load a view yet we'll keep this object in its place
@property (nonatomic, strong) NSObject *UnknownIndexPlaceholder;
/// If we have attempted to load a view (and there is nothing to go there, i.e. for multi-page views) we'll keep this at that index
@property (nonatomic, strong) NSObject *EmptyIndexPlaceholder;

@end

@implementation BKPivotViewController

#pragma mark - Memory Management

- (id)init {
	self = [super init];
	if (self) {
		self.currentPage = NSNotFound; // just some random value so changing it later on will trigger the overriden setter
		self.startingPage = 0;
		
		self.UnknownIndexPlaceholder = [[NSObject alloc] init];
		self.EmptyIndexPlaceholder = [[NSObject alloc] init];
		
		self.animationDuration = 0.4;
		self.peekAmount = 20;
	}
	
	return self;
}


#pragma mark - View Lifecycle

- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
	
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	self.scrollView = scrollView;
	self.scrollView.width = [self pageWidth];
	self.scrollView.delegate = self;
	self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.pagingEnabled = YES;
	self.scrollView.bounces = YES;
	self.scrollView.clipsToBounds = NO;
	[self.view addSubview:self.scrollView];
	
	UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.height - 36.0, self.view.width, 36.0)];
	self.pageControl = pageControl;
	self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
	[self.pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:self.pageControl];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.currentPage = self.startingPage;
	[self reloadPagesAnimated:NO];
}


#pragma mark - Local Methods

- (CGFloat)pageWidth {
	return self.view.width - self.peekAmount;
}

- (int)tagForViewAtIndex:(NSUInteger)index {
	return index + 1234; // arbitrary offset to (hopefully) avoid conflicts with other (possible) subviews that might have an index of 0 or something
}

- (void)reloadPagesAnimated:(BOOL)animated {
	NSUInteger numPages =  [self.delegate pivotViewNumberOfPages];
	
	self.scrollView.contentSize = CGSizeMake([self pageWidth] * numPages, self.scrollView.contentSize.height);
	self.pageControl.numberOfPages = numPages;

	// remove all old pages
	for (UIView *pageView in self.pageViews) {
		if ([pageView isKindOfClass:[UIView class]]) {
			[pageView removeFromSuperview];
		}
	}
	
	self.pageViews = [NSMutableArray arrayWithCapacity:numPages];
	for (int i = 0; i < numPages; i++) {
		self.pageViews[i] = self.UnknownIndexPlaceholder;
	}
	
	// load the current page (default is 0)
	[self reloadPageAtIndex:self.currentPage animated:animated];
}

- (void)reloadPageAtIndex:(NSUInteger)index animated:(BOOL)animated {
	[self reloadPageAtIndex:index animated:animated loadNextPage:YES];
}

/// if loadNextPage is YES (default) then we'll recursively call reloadPageAtIndex on the next run loop to load the page FOLLOWING this page (so it can "peek" at the user)
- (void)reloadPageAtIndex:(NSUInteger)index animated:(BOOL)animated loadNextPage:(BOOL)loadNextPage {
	id oldPage = self.pageViews.count ? [self.pageViews objectAtIndex:index] : nil;
	
	NSUInteger pageSpan = 1;
	UIView *newPage = [self.delegate pivotViewControllerViewForPageAtIndex:index pageSpan:&pageSpan];
	self.pageViews[index] = !newPage ? self.EmptyIndexPlaceholder : newPage;
	
	if (pageSpan > 1) {
		for (int offset = 1; offset < pageSpan; offset++) {
			int i = index + offset;
			self.pageViews[i] = self.EmptyIndexPlaceholder;
		}
	}
	
	if (oldPage == newPage) return;
	
	if ([oldPage isKindOfClass:[UIView class]]) {
		if (animated) {
			[UIView animateWithDuration:self.animationDuration animations:^{
				((UIView *)oldPage).alpha = 0;
			} completion:^(BOOL finished) {
				[oldPage removeFromSuperview];
			}];
		} else {
			[oldPage removeFromSuperview];
		}
	}
	
	CGFloat pageWidth = [self pageWidth] + (self.view.width * (pageSpan - 1));
	newPage.frame = CGRectMake([self pageWidth] * index, 0, pageWidth, self.scrollView.height);
	[self addViewForIndex:index animated:animated];
	
	// go ahead and add the next page as well (on next run loop) so it can "peek" at the user
	int numPages = self.pageViews.count;
	if (index < numPages-1 && loadNextPage && self.pageViews[numPages-1] == self.UnknownIndexPlaceholder) {
		dispatch_next_run_loop(^{
			[self reloadPageAtIndex:index+1 animated:YES loadNextPage:NO];
		});
	}
}

/// Adds view to scrollview at index, if the object in self.pageViews at index is a UIView
- (void)addViewForIndex:(NSUInteger)index animated:(BOOL)animated {
	if (![self.pageViews[index] isKindOfClass:[UIView class]]) return;
	
	UIView *view = self.pageViews[index];
	
	if (view.superview == self.scrollView) return; // already done!
	
	if (animated) {
		view.alpha = 0;
		[self.scrollView addSubview:view];
		[UIView animateWithDuration:self.animationDuration animations:^{
			view.alpha = 1;
		}];
	} else {
		[self.scrollView addSubview:view];
	}
}

/// Returns YES if the view is the one being displayed for the current page.
- (BOOL)viewIsCurrentPage:(UIView *)view {
	return self.pageViews[self.currentPage] == view;
}

- (void)pageControlValueChanged:(id)sender {
	[self scrollToPageAtIndex:self.pageControl.currentPage animated:YES];
}

- (void)scrollToPageAtIndex:(NSUInteger)index animated:(BOOL)animated {
	NSAssert(index < self.pageViews.count, @"BKPivotViewController setCurrentPage: failed; the value %d id out of bounds.", index);
	
	if (_currentPage == index) return;
	
	_currentPage = index;
	
	if (self.pageViews[index] == self.UnknownIndexPlaceholder) {
		[self reloadPageAtIndex:index animated:animated];
	}
	if ([self.delegate respondsToSelector:@selector(pivotViewControllerDidScrollToIndex:)]) {
		[self.delegate pivotViewControllerDidScrollToIndex:index];
	}
}


#pragma mark - Overriden Setters/Getters

- (void)setCurrentPage:(NSUInteger)currentPage {
	_currentPage = currentPage;
	self.pageControl.currentPage = currentPage;
}

- (BOOL)scrollEnabled {
	return self.scrollView.scrollEnabled;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
	self.scrollView.scrollEnabled = scrollEnabled;
	self.pageControl.enabled = scrollEnabled;
}


#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if ((NSUInteger)self.scrollView.contentOffset.x % (int)[self pageWidth] == 0) {
		NSUInteger newIndex = (int)(self.scrollView.contentOffset.x / [self pageWidth]);
		NSUInteger oldIndex = self.currentPage;
		self.currentPage = newIndex;
		if (newIndex > oldIndex && newIndex < (self.pageViews.count - 1)) {
			if (self.pageViews[newIndex+1] == self.UnknownIndexPlaceholder) {
				[self reloadPageAtIndex:newIndex+1 animated:YES loadNextPage:NO];
			}
		}
	}
}

@end
