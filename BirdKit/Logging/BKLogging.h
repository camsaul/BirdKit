//
//  BKLogging.h
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

@import Foundation;

typedef enum : NSUInteger {
	LogFlagError	= 1 << 0, // 1 = 0001
	LogFlagWarn		= 1 << 1, // 2 = 0010
	LogFlagInfo		= 1 << 2, // 4 = 0100
	LogFlagVerbose	= 1 << 3, // 8 = 1000
} LogFlag;

typedef enum : NSUInteger {
	LogCategoryEtc					= 1 << 4, //  16 = 0001 0000
	LogCategoryLocation				= 1 << 5, //  32 = 0010 0000
	LogCategoryRootVCAndView			= 1 << 6, //  64 = 0100 0000
	LogCategoryRouteFinder			= 1 << 7, // 128 = 1000 0000
	LogCategoryAppHandler			= 1 << 8, // 256
	LogCategoryNavigationService		= 1 << 9, // 512
	LogCategoryTODO					= 1 << 10,
	LogCategoryCoreData				= 1 << 11,
	LogCategoryAPI					= 1 << 12,
	LogCategoryAppMode				= 1 << 13,
	LogCategoryWalkingDirections		= 1 << 14,
	LogCategoryPredictions			= 1 << 15,
	LogCategorySearchResultsManager	= 1 << 16,
	LogCategoryGeocoder				= 1 << 17,
	LogCategoryDataSerializer		= 1 << 18,
	LogCategoryDataImporter			= 1 << 19,
	LogCategoryMap					= 1 << 20,
} LogCategory;

void BKLog(LogFlag flag, LogCategory category, __strong NSString const * const formatString, ...);
void BKLogTODO(NSString *formatString, ...);


// ---------- DEFAULT LOGGING LEVEL ----------

typedef enum : NSUInteger {
	LogLevelError	= 1,	// 0001
	LogLevelWarn	= 3,	// 0011
	LogLevelInfo	= 7,	// 0111
	LogLevelVerbose	= 15,	// 1111
} LogLevel;

/// Change this value to set the logging level for the app (e.g., you may want to set it to 0 for production builds). Default is LogLevelInfo.
/// Note you may also use category flags as part of this bitmask, e.g. LogLevelWarn|LogLevelAPI (show errors, warnings, and everything in the API category)
extern int *BKLogLevel;