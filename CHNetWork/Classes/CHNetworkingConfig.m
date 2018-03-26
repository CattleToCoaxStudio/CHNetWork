//
//  CHNetworkingConfig.m
//  Pods
//
//  Created by yangchengyou on 17/3/23.
//
//

#import "CHNetworkingConfig.h"

@implementation CHNetworkingConfig


+(instancetype)shardInstance
{
    static CHNetworkingConfig *shardInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shardInstance = [[CHNetworkingConfig alloc]init];
    });
    return shardInstance;
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _baseUrl = @"";
        _cacheTime = 1800;
        _headerKey = @"";
        _headerValue = @"";
        _dataKey = @"data";
        _requestType = 1;
    }
    return self;
}

- (void)httpRequestSetValue:(NSString *)headerValue forHTTPHeaderField:(NSString *)headerKey{
    _headerKey = headerKey;
    _headerValue = headerValue;
}

@end
