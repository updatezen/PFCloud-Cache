//
//  PFCloud+Cache.m
//  PFCloud+Cache
//
//  Created by Martin Rybak on 1/23/14.
//  Copyright (c) 2014 UpdateZen. All rights reserved.
//

#import "PFCloud+Cache.h"
#import <Parse/Parse.h>
#import "TMCache.h"
#import "NSString+Helpers.h"
#import "NSDictionary+JSON.h"

@implementation PFCloud (Cache)

#pragma mark - Public

/*
 Calls the given cloud function with the parameters provided asynchronously and runs the callback when it is done.
 @param function The function name to call.
 @param parameters The parameters to send to the function.
 @param cachePolicy  The cache policy to use for the function.
 @param block The block to execute. The block should have the following argument signature:(id result, NSError *error).
 */
+ (void)callFunctionInBackground:(NSString *)function withParameters:(NSDictionary *)parameters cachePolicy:(PFCachePolicy)cachePolicy block:(PFIdResultBlock)block
{
	if (!block) {
		[NSException raise:@"No completion block set" format:nil];
		return;
	}

	switch (cachePolicy)
	{
		//The call does not load from the cache or save results to the cache.
		case kPFCachePolicyIgnoreCache:
		{
			[self callFunctionInBackground:function withParameters:parameters block:block];
			break;
		}
		//The call only loads from the cache, ignoring the network. If there are no cached results, that causes a PFError.
		case kPFCachePolicyCacheOnly:
		{
			id cachedResponse = [self fetchFromCache:function params:parameters];
			if (cachedResponse) {
				block(cachedResponse, nil);
			} else {
				block(nil, [self noCacheError]);
			}
			break;
		}
		//The call first tries to load from the cache, but if that fails, it loads results from the network. If neither cache nor network succeed, there is a PFError.
		case kPFCachePolicyCacheElseNetwork:
		{
			id cachedResponse = [self fetchFromCache:function params:parameters];
			if (cachedResponse)
				block(cachedResponse, nil);
			else {
				[self callFunctionInBackgroundAndCache:function withParameters:parameters block:block];
			}
			break;
		}
		//The call does not load from the cache, but it will save results to the cache.
		case kPFCachePolicyNetworkOnly:
		{
			[self callFunctionInBackgroundAndCache:function withParameters:parameters block:block];
			break;
		}
		//The call first tries to load from the network, but if that fails, it loads results from the cache. If neither network nor cache succeed, there is a PFError.
		case kPFCachePolicyNetworkElseCache:
		{
			[self callFunctionInBackgroundAndCache:function withParameters:parameters block:^(id object, NSError* error) {
				if (error) {
					id cachedResponse = [self fetchFromCache:function params:parameters];
					if (cachedResponse) {
						block(cachedResponse, nil);
					} else {
						block(nil, error);
					}
				} else {
					block(object, nil);
				}
			}];
			break;
		}
		//The call first loads from the cache, then loads from the network. In this case, the callback will actually be called twice - first with the cached results, then with the network results.
		case kPFCachePolicyCacheThenNetwork:
		{
			id cachedResponse = [self fetchFromCache:function params:parameters];
			if (cachedResponse) {
				block(cachedResponse, nil);
			}
			[self callFunctionInBackgroundAndCache:function withParameters:parameters block:block];
			break;
		}
	}
}

+ (void)clearCachedResult:(NSString*)function withParameters:(NSDictionary*)parameters
{
	[[TMDiskCache sharedCache] removeObjectForKey:[self cacheKey:function params:parameters]];
}

+ (void)clearAllCachedResults
{
	[[TMDiskCache sharedCache] removeAllObjects];
}

+ (BOOL)hasCachedResult:(NSString*)function params:(NSDictionary*)parameters
{
	id cachedResult = [self fetchFromCache:function params:parameters];
	return cachedResult != nil;
}

+ (void)setMaxCacheAge:(NSTimeInterval)maxCacheAge
{
	[TMDiskCache sharedCache].ageLimit = maxCacheAge;
}

#pragma mark - Private

+ (void)callFunctionInBackgroundAndCache:(NSString*)function withParameters:(NSDictionary*)parameters block:(PFIdResultBlock)block
{
   [self callFunctionInBackground:function withParameters:parameters block:^(NSDictionary* object, NSError* error) {
	   if (error) {
		   block(nil, error);
	   } else {
		   [self saveToCache:object function:function params:parameters];
		   block(object, nil);
	   }
   }];
}

+ (NSString*)cacheKey:(NSString*)function params:(NSDictionary*)params
{
	NSString* contents = [function stringByAppendingString:[params JSON]];
	return [contents MD5];
}

+ (void)saveToCache:(id)object function:(NSString*)function params:(NSDictionary*)params
{
	[[TMDiskCache sharedCache] setObject:object forKey:[self cacheKey:function params:params]];
}

+ (id)fetchFromCache:(NSString*)function params:(NSDictionary*)params
{
	return [[TMDiskCache sharedCache] objectForKey:[self cacheKey:function params:params]];
}

+ (NSError*)noCacheError
{
	return [NSError errorWithDomain:@"PFCloud+Cache" code:120 userInfo:@{ NSLocalizedDescriptionKey : @"cache miss" }];
}

@end
