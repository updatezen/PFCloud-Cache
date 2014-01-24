PFCloud-Cache
=============

iOS library for caching cloud function calls in Parse.

This category adds an additional **cachePolicy** parameter to Parse's existing asynchronous (background) cloud function call methods. The **cachePolicy** parameter is of type **PFCachePolicy** and exactly replicates the [existing caching behavior] used with the **PFQuery** object.  It creates a record in the cache for every unique combination of function name + parameters.

```
+ (void)callFunctionInBackground:(NSString*)function
                  withParameters:(NSDictionary*)parameters
                     cachePolicy:(PFCachePolicy)cachePolicy
                           block:(PFIdResultBlock)block;
```
```
+ (void)callFunctionInBackground:(NSString*)function
                  withParameters:(NSDictionary*)parameters
                     cachePolicy:(PFCachePolicy)cachePolicy
                          target:(id)target
                        selector:(SEL)selector;
```

##Sample Usage

```
#import "PFCloud+Cache.h"

[PFCloud callFunctionInBackground:function
                   withParameters:params
                      cachePolicy:kPFCachePolicyCacheThenNetwork
                            block:^(id object, NSError* error) {
		//Because we are using kPFCachePolicyCacheThenNetwork as our cache policy,
		//this block will be invoked twice (if a cached result exists). 
}];
```

##Cache Management

Caching is performed on disk and persists between app restarts until it expires. By default the cache never expires. To change the cache age call the ```setMaxCacheAge``` method. The cache can also be explicity cleared for a particular cloud function call using the ```clearCachedResult:``` method, or for all calls using the ```clearAllCachedResults``` method. Thanks to those libraries for their great work!

##How it Works

This library concatenates the function name with a JSON-serialized string of the parameters dictionary. It then takes an MD5 of this string using the [RSCategories] library and uses this as the unique key in the cache. Actual caching is performed using the [TMCache] library.

##Installation

Easiest installation is using CocoaPods to resolve all dependencies. Otherwise you must manually copy the .h and .m files from this repo as well as from [RSCategories] and [TMCache]. Obviously you must also have the [Parse SDK] installed.

[existing caching behavior]: https://parse.com/docs/ios_guide#queries-caching/iOS
[RSCategories]: https://github.com/reejosamuel/RSCategories
[TMCache]:https://github.com/tumblr/TMCache
[Parse SDK]:https://parse.com/downloads/ios/parse-osx-library/latest
