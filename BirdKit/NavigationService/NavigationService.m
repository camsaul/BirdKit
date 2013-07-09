//
//  NavigationService.m
//  BirdKit
//
//  Created by Cameron Saul on 3/22/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "NavigationService.h"
#import "BKLogging.h"

static UINavigationController *_navigationController;

@implementation NavigationService

+ (void)setNavigationController:(UINavigationController *)navigationController {
	_navigationController = navigationController;
}

+ (void)navigateTo:(NSString *)destination params:(NSDictionary *)params {
	NSAssert(_navigationController, @"you must call setNavigationController: before using the navigation service!");
	
	Class class = NSClassFromString(destination);
	UIViewController *vc;
	if ([class instancesRespondToSelector:@selector(initWithParams:)]) {
		if ([class respondsToSelector:@selector(validateParams:)]) {
			[class validateParams:params];
		}
		vc = [[class alloc] initWithParams:params];
		BKLog(LogFlagInfo, LogCategoryNavigationService, @"Pushed view controller %@ with params: %@", destination, params);
	} else {
		if (params) {
			BKLog(LogFlagWarn, LogCategoryNavigationService, @"Warning! Passing params to class %@, which does not accept params.", destination);
		}
		vc = [[class alloc] init];
		BKLog(LogFlagInfo, LogCategoryNavigationService, @"Pushed view controller %@", destination);
	}
	
	if (params[NavigationServiceDelegateParam]) {
		if ([vc respondsToSelector:@selector(setDelegate:)]) {
			[(id)vc setDelegate:params[NavigationServiceDelegateParam]];
		} else {
			BKLog(LogFlagWarn, LogCategoryNavigationService, @"Warning! Passing NavigationServiceDelegateParam to class %@, which does not respond to setDelegate:.", destination);
		}
	}
	
	[_navigationController pushViewController:vc animated:YES];
}

+ (void)popViewControllerAnimated:(BOOL)animated {
	[_navigationController popViewControllerAnimated:animated];
}

@end