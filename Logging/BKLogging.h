//
//  BKLogging.h
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
	LogFlagError	= (1 << 0), // 1 = 0001
	LogFlagWarn		= (1 << 1), // 2 = 0010
	LogFlagInfo		= (1 << 2), // 4 = 0100
	LogFlagVerbose	= (1 << 3), // 8 = 1000
} LogFlag;

typedef enum : NSUInteger {
	LogCategoryEtc					= (1 << 4), //  16 = 0001 0000
	LogCategoryLocation				= (1 << 5), //  32 = 0010 0000
	LogCategoryRootVCAndView		= (1 << 6), //  64 = 0100 0000
	LogCategoryRouteFinder			= (1 << 7), // 128 = 1000 0000
	LogCategoryAppHandler			= (1 << 8), // 256
} LogCategory;

void BKLog(LogFlag flag, LogCategory category, NSString *formatString, ...);


// ---------- DEFAULT LOGGING LEVEL ----------

typedef enum : NSUInteger {
	LogLevelError	= 1,	// 0001
	LogLevelWarn	= 3,	// 0011
	LogLevelInfo	= 7,	// 0111
	LogLevelVerbose	= 15,	// 1111
} LogLevel;

static const int CurrentLogLevel = LogFlagInfo | LogCategoryAppHandler;