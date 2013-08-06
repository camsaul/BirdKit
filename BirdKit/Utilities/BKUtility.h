//
//  Utility.h
//  BirdKit
//
//  Created by Cameron Saul on 4/9/13.
//  Copyright (c) 2013 FiveBy. All rights reserved.
//

#import <MapKit/MapKit.h>

BOOL is_ipad();
BOOL is_iphone();
BOOL is_iphone_5();
BOOL is_landscape();
BOOL is_portrait();
BOOL is_ipad_landscape();
BOOL is_ipad_portrait();
BOOL is_retina();
BOOL is_ios7();

CGSize current_screen_size();

void dispatch_next_run_loop(dispatch_block_t block);

float distance_between_coordinates(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2);
float latitude_span_to_meters(float latitudeSpan);
float meters_to_miles(float meters);
int meters_to_minutes_walk(int meters);

/// returns a MKCoordinate region centered between the two coordinates, large enough to display both coordinates.
MKCoordinateRegion MKCoordinateRegionForCoordinates(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2);

/// returns YES if the coordinates are equal
BOOL CLLocationCoordinatesEqual(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2);

/// Simple way to show an alert with a formattible string as a TODO reminder. Logs the TODO as well.
///
/// BROKEN!
void TodoAlert(NSString *formatString, ...);