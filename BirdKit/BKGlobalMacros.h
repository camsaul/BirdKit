//
//  BKGlobalMacros.h
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#define PROP @property (nonatomic)
#define PROP_RO @property (nonatomic, readonly)
#define PROP_STRONG @property (nonatomic, strong)
#define PROP_STRONG_RO @property (nonatomic, strong, readonly)
#define PROP_COPY @property (nonatomic, copy)
#define PROP_COPY_RO @property (nonatomic, copy, readonly)
#define PROP_WEAK @property (nonatomic, weak)
#define PROP_WEAK_RO @property (nonatomic, weak, readonly)
#define PROP_DELEGATE(PROTOCOL) PROP_WEAK id<PROTOCOL> delegate

#define NEW(CLASS, VAR_NAME) CLASS *VAR_NAME = [[CLASS alloc] init]

#define TODO_ALERT(MESSAGE...) { \
	NSString *message = [NSString stringWithFormat:MESSAGE]; \
	[[[UIAlertView alloc] initWithTitle:@"TODO" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show]; \
	BKLog(LogFlagWarn, LogCategoryTODO, message); \
}

