//
//  NavigationService.m
//  BirdKit
//
//  Created by Cameron Saul on 3/22/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "NavigationService.h"

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
		NSLog(@"NAV SERVICE: Pushed view controller %@ with params: %@", destination, params);
	} else {
		if (params) {
			NSLog(@"NAV SERVICE: Warning! Passing params to class %@, which does not accept params.", destination);
		}
		vc = [[class alloc] init];
		NSLog(@"NAV SERVICE: Pushed view controller %@", destination);
	}
	
	[_navigationController pushViewController:vc animated:YES];
}

@end


@implementation NSDictionary (NavigationService)

- (NSDictionary *)dictionaryByAddingValue:(NSObject *)value forKey:(NSString *)key {
	NSMutableDictionary *newDict = [self mutableCopy];
	[newDict setValue:value forKey:key];
	return newDict;
}

- (BOOL)containsNumber:(NSString *)key
{
	NSNumber *number = [self objectForKey:key];
	return number && [number isKindOfClass:[NSNumber class]];
}

- (NSInteger)valueForInteger:(NSString *)key
{
	return [self[key] integerValue];
}

- (float)valueForFloat:(NSString *)key
{
	return [self[key] floatValue];
}

- (double)valueForDouble:(NSString *)key {
	return [self[key] doubleValue];
}

- (BOOL)valueForBool:(NSString *)key
{
	return [self[key] boolValue];
}

@end