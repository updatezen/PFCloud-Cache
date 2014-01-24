//
//  PFCloud+Cache.h
//  PFCloud+Cache
//
//  Created by Martin Rybak on 1/23/14.
//  Copyright (c) 2014 UpdateZen. All rights reserved.
//

#import <Parse/Parse.h>

@interface PFCloud (Cache)

+ (void)callFunctionInBackground:(NSString*)function withParameters:(NSDictionary*)parameters cachePolicy:(PFCachePolicy)cachePolicy block:(PFIdResultBlock)block;
+ (void)clearCachedResult:(NSString*)function withParameters:(NSDictionary*)parameters;
+ (void)clearAllCachedResults;
+ (BOOL)hasCachedResult:(NSString*)function params:(NSDictionary*)parameters;
+ (void)setMaxCacheAge:(NSTimeInterval)maxCacheAge;

@end
