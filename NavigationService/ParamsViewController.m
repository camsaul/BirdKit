//
//  ParamsViewController.m
//  BirdKit
//
//  Created by Cameron Saul on 3/23/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "ParamsViewController.h"

@implementation ParamsViewController

- (id)initWithParams:(NSDictionary *)params {
	self = [self init];
	
	if (self) {
		self.params = params;
	}
	
	return self;
}

@end
