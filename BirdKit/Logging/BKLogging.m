//
//  DBKLogging.m
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "BKLogging.h"
#import <objc/runtime.h>

static int CurrentLogLevel = LogLevelInfo;
int *BKLogLevel = &CurrentLogLevel;

#pragma GCC diagnostic ignored "-Wunused"

#if DEBUG
	static const char *string_for_log_category(LogCategory category) {
		switch (category) {
			case LogCategoryEtc:					return "Etc";
			case LogCategoryLocation:				return "Location";
			case LogCategoryRootVCAndView:			return "RootVC/RootView";
			case LogCategoryRouteFinder:			return "Route Finder";
			case LogCategoryAppHandler:				return "App Handler";
			case LogCategoryNavigationService:		return "Nav Service";
			case LogCategoryTODO:					return "TODO";
			case LogCategoryCoreData:				return "CoreData";
			case LogCategoryAPI:					return "API";
			case LogCategoryAppMode:				return "AppMode";
			case LogCategoryWalkingDirections:		return "WalkingDirs";
			case LogCategoryPredictions:			return "Predictions";
			case LogCategorySearchResultsManager:	return "SearchResultsManager";
			case LogCategoryGeocoder:				return "Geocoder";
			case LogCategoryDataSerializer:			return "DataSerialzer";
			case LogCategoryDataImporter:			return "DataImporter";
			case LogCategoryMap:					return "Map";
		}
		return NULL;
	}

	static const char *string_for_log_flag(LogFlag flag) {
		switch (flag) {
			case LogFlagVerbose:	return "Verbose";
			case LogFlagInfo:		return "Info";
			case LogFlagWarn:		return "Warn";
			case LogFlagError:		return "Error";
		}
		return NULL;
	}

	void BKLog(LogFlag flag, LogCategory category, const NSString *formatString, ...) {
		if (!(CurrentLogLevel & (flag|category))) return;
		
		va_list argptr;
		va_start(argptr, formatString);
		NSString *string = [[NSString alloc] initWithFormat:(NSString *)formatString arguments:argptr];
		printf("[%s %s] %s\n", string_for_log_category(category), string_for_log_flag(flag), [string cStringUsingEncoding:NSUTF8StringEncoding]);
		va_end(argptr);
	}

	void BKLog2(id sender, LogFlag flag, const NSString *formatString, ...) {
		if (!(CurrentLogLevel & flag)) return;
		
		va_list argptr;
		va_start(argptr, formatString);
		NSString *string = [[NSString alloc] initWithFormat:(NSString *)formatString arguments:argptr];
		printf("[%s %s] %s\n", class_getName([sender class]), string_for_log_flag(flag), [string cStringUsingEncoding:NSUTF8StringEncoding]);
		va_end(argptr);
	}

	void BKLogTODO(NSString *formatString, ...) {
		va_list argptr;
		va_start(argptr, formatString);
		BKLog(LogFlagWarn, LogCategoryTODO, formatString, argptr);
		va_end(argptr);
	}
#else
	// empty inline functions, hopefully compiler will optimize out entire calls
	inline void BKLog(LogFlag flag, LogCategory category, const NSString *formatString, ...) {}
	inline void BKLog2(id sender, LogFlag flag, const NSString *formatString, ...) {}
	void BKLogTODO(NSString *formatString, ...) {}
#endif
