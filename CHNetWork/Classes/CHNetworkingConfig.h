//
//  CHNetworkingConfig.h
//  Pods
//
//  Created by yangchengyou on 17/3/23.
//
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,CHRequestType){
    CHJsonRequest = 1,
    CHHttpRequest = 2
};

typedef NS_ENUM(NSInteger,CHEncryptType){
    CHEncryptType3DES = 1,
    CHEncryptTypeAES = 2
};

@interface CHNetworkingConfig : NSObject

+(instancetype)shardInstance;

/**
 1 json 2http
 */
@property (nonatomic, assign) CHRequestType requestType;

/**
 加密算法  默认不加密
 */
@property (nonatomic, assign) CHEncryptType encryptType;
/**
 模型转换时取的键(默认@"data")
 */
@property (nonatomic, copy) NSString *dataKey;

/**
 域名  该版本不用设置
 */
@property (nonatomic, copy) NSString *baseUrl;

/**
 设置数据缓存的时间 （秒） 默认1800秒
 */
@property (nonatomic, assign) NSTimeInterval cacheTime;

/**
  往request header 里面添加的键值对
 */
@property (nonatomic, retain) NSDictionary *headerDic;

/**
 公共参数
 */
@property (nonatomic, retain) NSDictionary *commonParams;

@property (nonatomic, copy) NSString *token;

/**
 加密秘钥
 */
@property (nonatomic, copy) NSString *secretKey;

/**
 加密偏移量
 */
@property (nonatomic, copy) NSString *offset;



@end
