//
//  Utility.h
//  BirdKit
//
//  Created by Cameron Saul on 4/9/13.
//  Copyright (c) 2013 FiveBy. All rights reserved.
//

@import UIKit;
@import CoreLocation;

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

BOOL coordinate_is_valid(CLLocationCoordinate2D coordinate);
BOOL latitude_is_valid(double lat);
BOOL longitude_is_valid(double lon);
float distance_between_coordinates(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2);
float latitude_span_to_meters(float latitudeSpan);
float meters_to_miles(float meters);
int meters_to_minutes_walk(int meters);

/**
 * Simple way to show an alert with a formattible string as a TODO reminder. Logs the TODO as well.
 *
 * BROKEN!
 */
// void TodoAlert(NSString *formatString, ...);