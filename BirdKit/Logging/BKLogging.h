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
	LogCategoryRootVCAndView		= 1 << 6, //  64 = 0100 0000
	LogCategoryRouteFinder			= 1 << 7, // 128 = 1000 0000
	LogCategoryAppHandler			= 1 << 8, // 256
	LogCategoryNavigationService	= 1 << 9, // 512
	LogCategoryTODO					= 1 << 10,
	LogCategoryCoreData				= 1 << 11,
	LogCategoryAPI					= 1 << 12,
	LogCategoryAppMode				= 1 << 13,
	LogCategoryWalkingDirections	= 1 << 14,
	LogCategoryPredictions			= 1 << 15,
	LogCategorySearchResultsManager	= 1 << 16,
	LogCategoryGeocoder				= 1 << 17,
	LogCategoryDataSerializer		= 1 << 18,
	LogCategoryDataImporter			= 1 << 19,
	LogCategoryMap					= 1 << 20,
} LogCategory;

/// Logs a log message with flag and category. Log message will only be displayed if *BKLogLevel & (flag|category) is true.
/// DEPRECATED -- In the future, we're going to move towards the BLog2 style logging.
void BKLog(LogFlag flag, LogCategory category, const NSString *formatString, ...);

/// Logs a log message with flag and the class name of sender (you should always pass self for the first parameter). Log message will only be displayed if *BKLogLevel & flag is true.
void BKLog2(id sender, LogFlag flag, const NSString *formatString, ...);

/// Logs a todo message.
void BKLogTODO(NSString *formatString, ...);

#if DEBUG
	#define DBKLog(LOG_FLAG, LOG_CATEGORY, ...) BKLog(LOG_FLAG, LOG_CATEGORY, __VA_ARGS__)
	#define DBKLog2(LOG_FLAG, ...) BKLog2(self, LOG_FLAG, __VA_ARGS__)
#else
	#define DBKLog(LOG_FLAG, LOG_CATEGORY, ...)
	#define DBKLog2(LOG_FLAG, ...)
#endif


// ---------- DEFAULT LOGGING LEVEL ---------- //

typedef enum : NSUInteger {
	LogLevelError	= 1,	// 0001
	LogLevelWarn	= 3,	// 0011
	LogLevelInfo	= 7,	// 0111
	LogLevelVerbose	= 15,	// 1111
} LogLevel;

/// Change this value to set the logging level for the app (e.g., you may want to set it to 0 for production builds). Default is LogLevelInfo.
/// Note you may also use category flags as part of this bitmask, e.g. LogLevelWarn|LogLevelAPI (show errors, warnings, and everything in the API category)
extern int *BKLogLevel;
