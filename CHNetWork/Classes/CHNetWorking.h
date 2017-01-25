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

#define CHNetWorkingRequest(delegate,requestType,mdoelClass,isCache,requestNumber) [CHNetWorking ch_GetRequestWithDeleagteTarget:delegate andRequestType:requestType andClass:mdoelClass andIsPersistence:isCache andNumber:requestNumber]

@class CHNetWorking;

typedef NS_ENUM(NSInteger,NetWorkingRequestType)
{
    CHAPIManagerRequestTypeGet = 1,
    CHAPIManagerRequestTypePost,
    CHAPIManagerRequestTypePut,
    CHAPIManagerRequestTypeDelete

};
@protocol NetWorkingDelegate <NSObject>

-(NSDictionary *)ch_paramWith:(CHNetWorking *)manager;
-(void)ch_requestCallAPISuccess:(CHNetWorking *)manager;
-(void)ch_requestCallApiFail:(CHNetWorking *)manager;

@end


@interface CHNetWorking : NSObject
@property(nonatomic,weak)id<NetWorkingDelegate> delegate;
@property(nonatomic,strong)CHURLResponse *response;
@property(nonatomic,assign)NSInteger requestNumber;
@property(nonatomic,assign)Class modeClass;
@property(nonatomic,strong) id model;
@property(nonatomic,assign)NetWorkingRequestType requestType;
@property(nonatomic,assign)BOOL isPersistence;
@property(nonatomic,assign)BOOL isCache;
@property(nonatomic,assign,readonly)BOOL isReachable;


+(NSURLSessionDataTask *)ch_GetRequestWithDeleagteTarget:(id)delegate
                     andRequestType:(NetWorkingRequestType)type
                           andClass:(Class)modelClass
                   andIsPersistence:(BOOL)Persistence
                          andNumber:(NSInteger)requestNumber;

@end
