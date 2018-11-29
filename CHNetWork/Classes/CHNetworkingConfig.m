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
        _dataKey = @"data";
        _requestType = CHJsonRequest;
        _encryptType = 0;
        _headerDic = @{};
        _commonParams = @{};
    }
    return self;
}


@end
