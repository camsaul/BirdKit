//
//  NavigationService.h
//  BirdKit
//
//  Created by Cameron Saul on 3/22/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface NavigationService : NSObject
+ (void)navigateTo:(NSString *)destinationClass params:(NSDictionary *)params;
+ (void)setNavigationController:(UINavigationController *)navigationController;
@end

@protocol InitWithParams <NSObject>
- (id)initWithParams:(NSDictionary *)params;
@optional
+ (void)validateParams:(NSDictionary *)params; // implement this static method and assert params are valid if desired
@end

@interface NSDictionary (NavigationService)
- (NSDictionary *)dictionaryByAddingValue:(NSObject *)value forKey:(NSString *)key;
- (BOOL)containsNumber:(NSString *)key;
- (NSInteger)valueForInteger:(NSString *)key;
- (float)valueForFloat:(NSString *)key;
- (double)valueForDouble:(NSString *)key;
- (BOOL)valueForBool:(NSString *)key;
@end