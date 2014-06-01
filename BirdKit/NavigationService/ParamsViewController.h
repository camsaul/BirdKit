//
//  ParamsViewController.h
//  BirdKit
//
//  Created by Cameron Saul on 3/23/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "NavigationService.h"

@interface ParamsViewController : UIViewController <InitWithParams>
@property (nonatomic, strong) NSDictionary *params;
@end
