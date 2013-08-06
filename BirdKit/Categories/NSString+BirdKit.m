//
//  NSString+BirdKit.m
//  BirdKit
//
//  Created by Cameron Saul on 2/21/12.
//  Copyright (c) 2013 Lucky Bird, Inc. All rights reserved.
//

#import "NSString+BirdKit.h"

@implementation NSString (BirdKit)

- (NSString *)stringByDecodingHTML {
	NSString *newStr = [self stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
	newStr = [newStr stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
	newStr = [newStr stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
	newStr = [newStr stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
	newStr = [newStr stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
	newStr = [newStr stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
	newStr = [newStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
	newStr = [newStr stringByReplacingOccurrencesOfString:@"&#10;" withString:@" "]; // not sure why I'm seeing this, but seems to work
	
	return newStr;
}

- (NSString *)stringByEncodingHTML {
	return [self stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}

- (NSString *)stringByRemovingHTMLTags {
	NSError *error = nil;
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<[^>]+>" options:NSRegularExpressionAnchorsMatchLines error:&error];
	return [[regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:@" "] stringByReplacingOccurrencesOfString:@"  " withString:@" "];
}

- (BOOL)containsString:(NSString *)otherString {
	if (!otherString) {
		return NO;
	}
	
	NSRange range = [self rangeOfString:otherString];
	return !NSEqualRanges(NSMakeRange(NSNotFound, 0), range);
}

- (NSInteger)distanceFromString:(NSString *)otherString {
	static int gain = 0;
	static int cost = 1;
	
	if (!otherString.length) return self.length;
	
	// normalize strings
	NSString *stringA = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
	NSString *stringB = [[otherString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
	
	// Step 1
	NSInteger k, i, j, change, *d, distance;
	
	NSUInteger n = [stringA length];
	NSUInteger m = [stringB length];
	
	if( n++ != 0 && m++ != 0 ) {
		d = malloc( sizeof(NSInteger) * m * n );
		
		// Step 2
		for( k = 0; k < n; k++)
			d[k] = k;
		
		for( k = 0; k < m; k++)
			d[ k * n ] = k;
		
		// Step 3 and 4
		for( i = 1; i < n; i++ ) {
			for( j = 1; j < m; j++ ) {
				
				// Step 5
				if([stringA characterAtIndex: i-1] == [stringB characterAtIndex: j-1]) {
					change = -gain;
				} else {
					change = cost;
				}
				
				// Step 6
				d[ j * n + i ] = MIN(d [ (j - 1) * n + i ] + 1, MIN(d[ j * n + i - 1 ] +  1, d[ (j - 1) * n + i -1 ] + change));
			}
		}
		
		distance = d[ n * m - 1 ];
		free( d );
		return distance;
	}
	
	return 0;
}

@end
