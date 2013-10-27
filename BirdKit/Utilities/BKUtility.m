//
//  Utility.m
//  BirdKit
//
//  Created by Cameron Saul on 4/9/13.
//  Copyright (c) 2013 Cam Saul. All rights reserved.
//

#import "BKUtility.h"

BOOL is_ipad() {
	static int isIpad = -1;
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
	//	UIViewController *presentedViewController = App_Delegate().rootViewController.presentedViewController;
	//	if (presentedViewController && [presentedViewController conformsToProtocol:@protocol(ToInterfaceOrientation)]) {
	//		UIViewController<ToInterfaceOrientation> *presentedVC = (UIViewController<ToInterfaceOrientation> *)presentedViewController;
	//		if ([presentedVC toInterfaceOrientation] != NSNotFound) {
	//			return UIInterfaceOrientationIsLandscape([presentedVC toInterfaceOrientation]);
	//		}
	//	}
	//
	//	return UIDeviceOrientationIsLandscape([(UIViewController<ToInterfaceOrientation> *)(App_Delegate().rootViewController) toInterfaceOrientation]);
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
	static BOOL _is_ios7 = -1;
	if (_is_ios7 == -1) {
		_is_ios7 = [[UIDevice currentDevice] systemVersion].floatValue >= 7.0f;
	}
	return _is_ios7;
}

inline CGSize current_screen_size() {
	return [UIApplication sharedApplication].delegate.window.rootViewController.view.bounds.size;
}

inline void dispatch_after_seconds(const float delayInSeconds, dispatch_block_t block) {
	const dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), block);
}

void dispatch_after_seconds_background(const float delayInSeconds, dispatch_block_t block) {
	const dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}

inline void dispatch_next_run_loop(dispatch_block_t block) {
	dispatch_after_seconds(0.001f, block);
}

inline float distance_between_coordinates(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2) {
	static const int RADIUS = 6371000; // Earth's radius in meters
	static const float RAD_PER_DEG = 0.017453293f;
	
	const float lat1 = coordinate1.latitude;
	const float lat2 = coordinate2.latitude;
	const float lon1 = coordinate1.longitude;
	const float lon2 = coordinate2.longitude;
	
	const float dlat = lat2 - lat1;
	const float dlon = lon2 - lon1;
	
	const float dlon_rad = dlon * RAD_PER_DEG;
	const float dlat_rad = dlat * RAD_PER_DEG;
	const float lat1_rad = lat1 * RAD_PER_DEG;
	const float lon1_rad = lon1 * RAD_PER_DEG;
	const float lat2_rad = lat2 * RAD_PER_DEG;
	const float lon2_rad = lon2 * RAD_PER_DEG;

	const float a = pow((sinf(dlat_rad/2.0f)), 2.0f) + cosf(lat1_rad) * cosf(lat2_rad) * pow(sinf(dlon_rad/2.0f),2.0f);
	const float c = 2.0f * atan2f( sqrt(a), sqrt(1.0f-a));
	float d = RADIUS * c;
	
	if (isnan(d)) {
		// for some reason Haversine formula failed, let's do Spherical Law of Cosines
		d = acosf(sinf(lat1_rad)*sinf(lat2_rad) + cosf(lat1_rad)*cosf(lat2_rad) * cosf(lon2_rad-lon1_rad)) * RADIUS;
	}
    return d; // Return our calculated distance
}

inline float latitude_span_to_meters(float latitudeSpan) {
	const float metersPerLatitudeDegree = 111000; // 1 degree lat is always 111km
	return metersPerLatitudeDegree * latitudeSpan;
}

inline float meters_to_latitude_span(float meters) {
	const float metersPerLatitudeDegree = 111000; // 1 degree lat is always 111km
	return meters / metersPerLatitudeDegree;
}

float meters_to_miles(float meters) {
	return meters * 0.000621371192;
}

inline int meters_to_minutes_walk(int meters) {
	static const int AverageHumanWalkingSpeedMetersPerMinute = 2.7 * 1600.0 / 60.0; // 2.7mph * 1600 meters/mile ÷ minutes per hour
	return meters / AverageHumanWalkingSpeedMetersPerMinute;
}

MKCoordinateRegion MKCoordinateRegionForCoordinates(CLLocationCoordinate2D c1, CLLocationCoordinate2D c2) {
	const CLLocationCoordinate2D center = CLLocationCoordinate2DMake((c1.latitude + c2.latitude) / 2.0, (c1.longitude + c2.longitude) / 2.0);
	const float dist = distance_between_coordinates(c1, c2) * 1.25f; // zoom out a little bit so they both fit on screen
	return MKCoordinateRegionMakeWithDistance(center, dist, dist);
}

BOOL CLLocationCoordinatesEqual(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2) {
	return coordinate1.latitude == coordinate2.latitude && coordinate1.longitude == coordinate2.longitude;
}

extern void DBKLogTODO(NSString *,...);

void TodoAlert(NSString *formatString, ...) {
	va_list argptr;
	va_start(argptr, formatString);
	NSString *message = [[NSString alloc] initWithFormat:formatString arguments:argptr];
	[[[UIAlertView alloc] initWithTitle:@"TODO" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
	
	va_end(argptr);
}
