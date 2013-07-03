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
		
		dispatch_next_run_loop(^{
			[self reloadPagesAnimated:NO];
		});
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

	self.pageViews = [NSMutableArray arrayWithCapacity:numPages];
	for (int i = 0; i < numPages; i++) {
		self.pageViews[i] = [NSNull null];
	}
	
	// load the current page (default is 0)
	[self reloadPageAtIndex:self.currentPage animated:animated];
}

- (void)reloadPageAtIndex:(NSUInteger)index animated:(BOOL)animated {
	id oldPage = [self.pageViews objectAtIndex:index];
	
	UIView *newPage = [self.delegate pivotViewControllerViewForPageAtIndex:index];
	self.pageViews[index] = !newPage ? self.EmptyIndexPlaceholder : newPage;
	
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
	
	[self addViewForIndex:index animated:animated];
}

- (void)addViewForIndex:(NSUInteger)index animated:(BOOL)animated {
	if (self.pageViews[index] == [NSNull null]) return;
	
	UIView *view = self.pageViews[index];
	
	if (view.superview == self.scrollView) return; // already done!
	
	// find out how many "null" pages are directly after this view controller
	CGFloat pageWidth = [self pageWidth];
	for (int i = index + 1; i < self.pageViews.count; i++) {
		if (self.pageViews[i] == self.UnknownIndexPlaceholder) {
			[self reloadPageAtIndex:i animated:animated];			
		}
		if (self.pageViews[i] != self.EmptyIndexPlaceholder) {
			break;
		} else {
			pageWidth += self.view.width;
		}
	}
	
	view.frame = CGRectMake([self pageWidth] * index, 0, pageWidth, self.scrollView.height);

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

/**
 * Returns YES if the view is the one being displayed for the current page.
 */
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
	
	[self reloadPageAtIndex:index animated:animated];
	[self.delegate pivotViewControllerDidScrollToIndex:index];
}


#pragma mark - Overriden Setters/Getters

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
		[self setCurrentPage:(int)(self.scrollView.contentOffset.x / [self pageWidth])];
	}
}

@end
