//  -*-ObjC-*-
//  UIImage+BirdKit.h
//  BirdKit
//
//  Created by Cameron Saul on 7/10/13.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BirdKit)

/// Creates a new UIImage by rendering the contents of a UIView.
/// The view must be present on the screen in order to be rendered.
+ (UIImage *)imageFromView:(UIView *)view;

/// Returns an image with a solid color of size.
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

#pragma mark - Resizing Methods (Credit: Trevor Harmon)

/// Returns a copy of this image that is cropped to the given bounds.
/// The bounds will be adjusted using CGRectIntegral.
/// This method ignores the image's imageOrientation setting.
- (UIImage *)croppedImage:(CGRect)bounds;

/// Returns a rescaled copy of the image, taking into account its orientation
/// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

/// Returns an image that is tinted with one or more colors
- (UIImage *)tintedWithLinearGradientColors:(NSArray *)colorsArr;

@end
