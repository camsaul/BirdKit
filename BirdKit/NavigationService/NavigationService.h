//
//  NavigationService.h
//  BirdKit
//
//  Created by Cameron Saul on 3/22/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

/// this parameter is a special case; if you set this parameter and the target view controller responds to setDelegate:,
/// then setDelegate: will be called with the value when that view controller is pushed.
static const NSString *NavigationServiceDelegateParam = @"Delegate";

@interface NavigationService : NSObject
+ (void)navigateTo:(NSString *)destinationClass params:(NSDictionary *)params;
+ (void)popViewControllerAnimated:(BOOL)animated;
+ (void)setNavigationController:(UINavigationController *)navigationController;
@end

@protocol InitWithParams <NSObject>
- (id)initWithParams:(NSDictionary *)params;
@optional
/// implement this static method and assert params are valid if desired
+ (void)validateParams:(NSDictionary *)params;
@end