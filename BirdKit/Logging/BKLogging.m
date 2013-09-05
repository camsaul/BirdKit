//
//  BKLogging.m
//  BirdKit
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "BKLogging.h"

static int CurrentLogLevel = LogLevelInfo | LogCategoryAppHandler;

static const char *string_for_log_category(LogCategory category) {
	switch (category) {
		case LogCategoryEtc:						return "Etc";
		case LogCategoryLocation:				return "Location";
		case LogCategoryRootVCAndView:			return "RootVC/RootView";
		case LogCategoryRouteFinder:				return "Route Finder";
		case LogCategoryAppHandler:				return "App Handler";
		case LogCategoryNavigationService:		return "Nav Service";
		case LogCategoryTODO:					return "TODO";
		case LogCategoryCoreData:				return "CoreData";
		case LogCategoryAPI:						return "API";
		case LogCategoryAppMode:					return "AppMode";
		case LogCategoryWalkingDirections:		return "WalkingDirs";
		case LogCategoryPredictions:				return "Predictions";
		case LogCategorySearchResultsManager:	return "SearchResultsManager";
		case LogCategoryGeocoder:				return "Geocoder";
	}
	assert(false); // Please add a string for log category
}

void BKLog(LogFlag flag, LogCategory category, __strong NSString const * const formatString, ...) {
	if (CurrentLogLevel & (flag|category)) {
		va_list argptr;
		va_start(argptr, formatString);
		NSString *string = [[NSString alloc] initWithFormat:(NSString *)formatString arguments:argptr];
		printf("[%s] %s\n", string_for_log_category(category), [string cStringUsingEncoding:NSUTF8StringEncoding]);
		va_end(argptr);
	}
}

void BKLogTODO(NSString *formatString, ...) {
	va_list argptr;
	va_start(argptr, formatString);
	BKLog(LogFlagWarn, LogCategoryTODO, formatString, argptr);
	va_end(argptr);
}

void BKLogSetLogLevel(int loglevel) {
	CurrentLogLevel = loglevel;
}