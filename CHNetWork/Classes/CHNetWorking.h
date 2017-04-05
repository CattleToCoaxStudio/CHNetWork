//
//  NetWorking.h
//  
//
//  Created by ba on 16/5/23.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHURLResponse.h"
#import <UIKit/UIKit.h>
#import "CHNetworkingConfig.h"
//#import "CoatingView.h"

#define CHNetWorkingRequest(delegate,requestType,mdoelClass,isCache,requestNumber) [CHNetWorking ch_GetRequestWithDeleagteTarget:delegate andRequestType:requestType andClass:mdoelClass andIsPersistence:isCache andNumber:requestNumber]

#define CHNetworkingStart - (void)ch_startAccessTheNetwork:(CHNetWorking *)manager{}
#define CHNetworkingEnd - (void)ch_endAccessTheNetwork:(CHNetWorking *)manager{}

@class CHNetWorking;

typedef NS_ENUM(NSInteger,NetWorkingRequestType)
{
    CHAPIManagerRequestTypeGet = 1,
    CHAPIManagerRequestTypePost,
    CHAPIManagerRequestTypePut,
    CHAPIManagerRequestTypeDelete

};
@protocol CHNetWorkingDelegate <NSObject>

/**
 获取参数
 普通请求ex:@{@"url":@"...",@"params":@{@"userId":@"1"}}
 上传图片ex:@{@"url":@"...",@"images":@[image,...],@"params":@{}}
 @param manager manager
 @return 参数
 */
-(NSDictionary *)ch_paramWith:(CHNetWorking *)manager;
-(void)ch_requestCallAPISuccess:(CHNetWorking *)manager;
-(void)ch_requestCallApiFail:(CHNetWorking *)manager;

@optional

/**
 在这里可以选择加入loading页面（把代理写入BaseViewController,如果有其他controller不需要loading 重写该方法不实现内容就行了  如果没有实现该方法，该库已经默认实现一个简单的loading） 可以使用定义的两个宏：CHNetworkingStart CHNetworkingEnd

 @param manager manager
 */
- (void)ch_startAccessTheNetwork:(CHNetWorking *)manager;
- (void)ch_endAccessTheNetwork:(CHNetWorking *)manager;
@end


@interface CHNetWorking : NSObject
@property(nonatomic,weak)id<CHNetWorkingDelegate> delegate;
@property(nonatomic,strong)CHURLResponse *response;
@property(nonatomic,assign)NSInteger requestNumber;
@property(nonatomic,assign)Class modeClass;
@property(nonatomic,strong) id model;
@property(nonatomic,assign)NetWorkingRequestType requestType;
@property(nonatomic,assign)BOOL isPersistence;
@property(nonatomic,assign)BOOL isCache;
@property(nonatomic,assign,readonly)BOOL isReachable;


/**
 网络请求

 @param delegate 代理
 @param type 请求类型
 @param modelClass 模型class
 @param Persistence 是否缓存
 @param requestNumber 请求id
 @return manager
 */
+(NSURLSessionDataTask *)ch_GetRequestWithDeleagteTarget:(id)delegate
                     andRequestType:(NetWorkingRequestType)type
                           andClass:(Class)modelClass
                   andIsPersistence:(BOOL)Persistence
                          andNumber:(NSInteger)requestNumber;

/**
 文件上传

 @param delegate 代理
 @param type 类型（该版本默认post）
 @param modelClass 模型
 @param Persistence 缓存
 @param requestNumber 请求id（标识）
 @return result
 */
+(NSURLSessionDataTask *)ch_UploadTaskWithDeleagteTarget:(id)delegate
                                          andRequestType:(NetWorkingRequestType)type
                                                andClass:(Class)modelClass
                                        andIsPersistence:(BOOL)Persistence
                                               andNumber:(NSInteger)requestNumber;

@end
