//
//  NSDictionary+JSON.m
//  PFCloud+Cache
//
//  Created by Martin Rybak on 1/8/14.
//  Copyright (c) 2014 UpdateZen. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)

- (NSString*)JSON
{
	NSError* error;
	NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
	if (error) {
		[NSException raise:@"Dictionary could not be serialzed" format:nil];
		return nil;
	}
	NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
	return jsonString;
}

@end
