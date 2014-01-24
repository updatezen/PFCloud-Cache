//
//  PFCloud+Cache.h
//  PFCloud+Cache
//
//  Created by Martin Rybak on 1/23/14.
//  Copyright (c) 2014 UpdateZen. All rights reserved.
//

#import <Parse/Parse.h>

@interface PFCloud (Cache)

/*
 Calls the given cloud function with the parameters provided asynchronously and runs the callback when it is done.
 @param function The function name to call.
 @param parameters The parameters to send to the function.
 @param cachePolicy  The cache policy to use for the function.
 @param block The block to execute. The block should have the following argument signature:(id result, NSError *error).
 */
+ (void)callFunctionInBackground:(NSString*)function withParameters:(NSDictionary*)parameters cachePolicy:(PFCachePolicy)cachePolicy block:(PFIdResultBlock)block;

/*
 Calls the given cloud function with the parameters provided asynchronously and runs the callback when it is done.
 @param function The function name to call.
 @param parameters The parameters to send to the function.
 @param cachePolicy  The cache policy to use for the function.
 @param target The object to call the selector on.
 @param selector The selector to call. It should have the following signature: (void)callbackWithResult:(id) result error:(NSError *)error. result will be nil if error is set and vice versa.
 */
+ (void)callFunctionInBackground:(NSString*)function withParameters:(NSDictionary*)parameters cachePolicy:(PFCachePolicy)cachePolicy target:(id)target selector:(SEL)selector;

/*
 Clears the cache for the given cloud function and parameters.
 @param function The function name to call.
 @param parameters The parameters to send to the function.
 */
+ (void)clearCachedResult:(NSString*)function withParameters:(NSDictionary*)parameters;

/*
 Clears the cache for the all cloud functions and parameters.
 */
+ (void)clearAllCachedResults;

/*
 Returns whether a cached result exists for the given cloud function and parameters.
 @param function The function name to call.
 @param parameters The parameters to send to the function.
 @result Whether or not the cached result exists.
 */
+ (BOOL)hasCachedResult:(NSString*)function params:(NSDictionary*)parameters;

/*
 Sets the maximum age for all items in the cache.
 @param maxCacheAge The cache age in seconds.
 */
+ (void)setMaxCacheAge:(NSTimeInterval)maxCacheAge;

@end
