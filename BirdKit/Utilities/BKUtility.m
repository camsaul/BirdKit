//
//  Utility.m
//  BirdKit
//
//  Created by Cameron Saul on 4/9/13.
//  Copyright (c) 2013 FiveBy. All rights reserved.
//

#import "BKUtility.h"

static int isIpad = -1;

BOOL is_ipad() {
	if (isIpad == -1) {
		isIpad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 1 : 0;
	}
	return (BOOL)isIpad;
}

BOOL is_iphone() {
	return !is_ipad();
}

BOOL is_iphone_5() {
	return is_iphone() && [UIScreen mainScreen].bounds.size.height > 500.0f;
}

BOOL is_landscape() {
	return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].delegate.window.rootViewController.interfaceOrientation);
	//	if (is_iphone()) return YES; // iphone is always in landscape for this version of the app.
	//
	//	// device orientation seems to be the most accurate and up-to-date, but since face up / face down are considered valid orientations we can't always rely on device orientation.
	//	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	//	if (UIDeviceOrientationIsLandscape(orientation)) {
	//		return YES;
	//	} else if (UIDeviceOrientationIsPortrait(orientation)) {
	//		return NO;
	//	}
	//
	//	// inspect the toInterfaceOrientation of the modal view controller if it exists and it implements the ToInterfaceOrientation property
	//	UIViewController *presentedViewController = APP_DELEGATE.rootViewController.presentedViewController;
	//	if (presentedViewController && [presentedViewController conformsToProtocol:@protocol(ToInterfaceOrientation)]) {
	//		UIViewController<ToInterfaceOrientation> *presentedVC = (UIViewController<ToInterfaceOrientation> *)presentedViewController;
	//		if ([presentedVC toInterfaceOrientation] != NSNotFound) {
	//			return UIInterfaceOrientationIsLandscape([presentedVC toInterfaceOrientation]);
	//		}
	//	}
	//
	//	return UIDeviceOrientationIsLandscape([(UIViewController<ToInterfaceOrientation> *)(APP_DELEGATE.rootViewController) toInterfaceOrientation]);
}

BOOL is_portrait() {
	return !is_landscape();
}

BOOL is_ipad_landscape() {
	return is_ipad() && is_landscape();
}

BOOL is_ipad_portrait() {
	return is_ipad() && is_portrait();
}

BOOL is_retina() {
	return [UIScreen mainScreen].scale > 1;
}

BOOL is_ios7() {
	NSString *versionStr = [[UIDevice currentDevice] systemVersion];
	return [versionStr floatValue] >= 7.0;
}

CGSize current_screen_size() {
	return [UIApplication sharedApplication].delegate.window.rootViewController.view.bounds.size;
}

void dispatch_next_run_loop(dispatch_block_t block) {
	double delayInSeconds = 0.001;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), block);
}

inline float distance_between_coordinates(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2) {
	assert(CLLocationCoordinate2DIsValid(coordinate1));
	assert(CLLocationCoordinate2DIsValid(coordinate2));
	
	const int RADIUS = 6371000; // Earth's radius in meters
	const float RAD_PER_DEG = 0.017453293;
	
	float lat1 = coordinate1.latitude;
	float lat2 = coordinate2.latitude;
	float lon1 = coordinate1.longitude;
	float lon2 = coordinate2.longitude;
	
	float dlat = lat2 - lat1;
	float dlon = lon2 - lon1;
	
	float dlon_rad = dlon * RAD_PER_DEG;
	float dlat_rad = dlat * RAD_PER_DEG;
	float lat1_rad = lat1 * RAD_PER_DEG;
	float lon1_rad = lon1 * RAD_PER_DEG;
	float lat2_rad = lat2 * RAD_PER_DEG;
	float lon2_rad = lon2 * RAD_PER_DEG;
	
	float a = pow((sinf(dlat_rad/2)), 2) + cosf(lat1_rad) * cosf(lat2_rad) * pow(sinf(dlon_rad/2),2);
	float c = 2 * atan2f( sqrt(a), sqrt(1-a));
	float d = RADIUS * c;
	
	if (isnan(d)) {
		// for some reason Haversine formula failed, let's do Spherical Law of Cosines
		d = acosf(sinf(lat1_rad)*sinf(lat2_rad) + cosf(lat1_rad)*cosf(lat2_rad) * cosf(lon2_rad-lon1_rad)) * RADIUS;
	}
    return d; // Return our calculated distance
}

float latitude_span_to_meters(float latitudeSpan) {
	const float metersPerLatitudeDegree = 111000; // 1 degree lat is always 111km
	return metersPerLatitudeDegree * latitudeSpan;
}

float meters_to_miles(float meters) {
	return meters * 0.000621371192;
}

inline int meters_to_minutes_walk(int meters) {
	static const int AverageHumanWalkingSpeedMetersPerMinute = 2.7 * 1600.0 / 60.0; // 2.7mph * 1600 meters/mile ÷ minutes per hour
	return meters / AverageHumanWalkingSpeedMetersPerMinute;
}

MKCoordinateRegion MKCoordinateRegionForCoordinates(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2) {
	float lat1 = coordinate1.latitude, lat2 = coordinate2.latitude, lon1 = coordinate1.longitude, lon2 = coordinate2.longitude;
	float minLat = MIN(lat1, lat2);
	float maxLat = MAX(lat1, lat2);
	float minLon = MIN(lon1, lon2);
	float maxLon = MAX(lon1, lon2);
	
	CLLocationCoordinate2D center = CLLocationCoordinate2DMake((lat1 + lat2) / 2.0, (lon1 + lon2) / 2.0);

	return MKCoordinateRegionMake(center, MKCoordinateSpanMake(maxLat - minLat, maxLon - minLon));
}

BOOL CLLocationCoordinatesEqual(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2) {
	return coordinate1.latitude == coordinate2.latitude && coordinate1.longitude == coordinate2.longitude;
}

extern void BKLogTODO(NSString *,...);

void TodoAlert(NSString *formatString, ...) {
	va_list argptr;
	va_start(argptr, formatString);
	NSString *message = [[NSString alloc] initWithFormat:formatString arguments:argptr];
	[[[UIAlertView alloc] initWithTitle:@"TODO" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
	
//	BKLogTODO(formatString, argptr);
	
	va_end(argptr);
}