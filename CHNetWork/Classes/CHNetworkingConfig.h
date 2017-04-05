//
//  CHNetworkingConfig.h
//  Pods
//
//  Created by yangchengyou on 17/3/23.
//
//

#import <Foundation/Foundation.h>

@interface CHNetworkingConfig : NSObject

+(instancetype)shardInstance;

/**
 域名  该版本不用设置
 */
@property (nonatomic, copy) NSString *baseUrl;

/**
 设置数据缓存的时间 （秒） 默认1800秒
 */
@property (nonatomic, assign) NSTimeInterval cacheTime;


/**
 加入请求头 键
 */
@property (nonatomic, copy) NSString *headerKey;

/**
 加入请求头 值
 */
@property (nonatomic, copy) NSString *headerValue;

/**
 设置请求头(和上面的属性配置选一种)

 @param headerValue 值
 @param headerKey 键
 */
- (void)httpRequestSetValue:(NSString *)headerValue forHTTPHeaderField:(NSString *)headerKey;

@end
