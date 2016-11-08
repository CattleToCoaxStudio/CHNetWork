 //
//  NetWorking.m
//  五粮特曲(经销商)
//
//  Created by ba on 16/5/23.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "NetWorking.h"
#import "CHApiProxy.h"
#import <MJExtension/MJExtension.h>
#import "CTCache.h"
#import "NSDictionary+AXNetworkingMethods.h"
#import "AFNetworkReachabilityManager.h"
#import "CHPresistence.h"
#import "FGGReachability.h"
/* (1)这个宏里面用sefl而没用weakSelf是因为，Controller里用的类方法调用，而不是实例在调。
 * (2)因为在调[CHApiProxy shardInstance]这里面的方法时，是这里[self alloc]创建的一个实例在调用
 * 当这个方法调用完返回一个ID值用就没有强引用在指向[self alloc]它了，它就会被释放掉。在DataTask
 * 任务里面Blok就回调不了，所在要在下面这个宏的Blok里对[self alloc]这个实例，使用self对它强引用
 * 当[CHApiProxy shardInstance]里的请求任务回来了后才能成功的掉用Blok。
 */
#define CHCallAPI(REQUEST_MEHOD,PARAMS)\
    [[CHApiProxy shardInstance] call##REQUEST_MEHOD##withParams:PARAMS success:^(CHURLResponse *response){ \
                                           \
                [self successedOnCallingAPI:response];\
       \
\
    }fail:^(CHURLResponse *response){                                                        \
                                   \
               [self failOnCallingAPI:response withErrorType:CHURLResponseErrorTypeDefault];\
           \
    }];




@interface NetWorking()
@property(nonatomic,strong)NSMutableArray *requestIdList;
@property(nonatomic,assign)BOOL isNativeDataEmpty;
@property(nonatomic,strong)CTCache *cache;
@end
@implementation NetWorking

-(void)dealloc
{
    [self cancelAllRequest];
    self.requestIdList = nil;
}

-(void)cancelAllRequest
{   //这里写的这个取消请求逻辑， 是另外一种写法， 就是在在外写创建实例，用实例方法来
    //做网络请求，当外面的网络请求还在进行中，  但外面的控制器以经dealloc了的话就会来
    //来到这里取消请求
    //但现在，改成了用类方法来做网络请求，所以这里意义基本不大
    //用类方法做网络请求，我返回了一个DataTask回去， 可以通个这个，任务对象做网络的取消。
    [[CHApiProxy shardInstance]cancelRequestWithRequestList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}
+(NSURLSessionDataTask *)ch_GetRequestWithDeleagteTarget:(id)delegate
                     andRequestType:(NetWorkingRequestType)type
                           andClass:(Class)modelClass
                   andIsPersistence:(BOOL)Persistence
                          andNumber:(NSInteger)requestNumber
                        
{
    [self initNativeDataBase];
    
   return  [[self alloc] ch_GetRequestWithDeleagteTarget:delegate
                                andRequestType:type
                                      andClass:modelClass
                              andIsPersistence:Persistence
                                     andNumber:requestNumber];

}

-(NSURLSessionDataTask *)ch_GetRequestWithDeleagteTarget:(id)delegate
                      andRequestType:(NetWorkingRequestType)type
                            andClass:(Class)modelClass
                    andIsPersistence:(BOOL)Persistence
                           andNumber:(NSInteger)requestNumber {
    
    self.delegate = delegate;
    self.isPersistence = Persistence;
    self.requestNumber = requestNumber;
    self.modeClass = modelClass;
    self.requestType = type;
    self.isCache = Persistence;
    
    NSDictionary *param = [self.delegate ch_paramWith:self];
   
    if (self.isCache && self.requestType == CHAPIManagerRequestTypeGet && [self hasCacheWithParams:param]) {
        
        return nil;
    }
    if (self.isPersistence && self.requestType == CHAPIManagerRequestTypeGet) {
        [self loadDataFromNative:param];
        if (!self.isNativeDataEmpty) {
            return nil;
        } 
    }
    if ([self isReachable]) {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        //和网络菊花
        NSURLSessionDataTask *requestTask = nil;
    switch (type) {
        case CHAPIManagerRequestTypeGet:
        {
           requestTask  =  CHCallAPI(GET, param);
            
        }
            break;
        case CHAPIManagerRequestTypePost:
        {
            requestTask =  CHCallAPI(POST, param);
        }
            break;
        case CHAPIManagerRequestTypePut:
        {
            requestTask =   CHCallAPI(PUT, param);
        }
            break;
        case CHAPIManagerRequestTypeDelete:
        {
            requestTask = CHCallAPI(DELETE, param);
        }
            break;
          
    }

        [self.requestIdList addObject:@([requestTask taskIdentifier])];
        return requestTask;
  
    }else{
        
        [self failOnCallingAPI:nil withErrorType:CHURLResponseErrorTypeNoNetWork];
        return nil;
    }
                       
    return nil;

}
-(void)successedOnCallingAPI:(CHURLResponse*)response
{
    //这里取消网络菊花
   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.response = response;
    [self removeRequestIdWithRequestID:response.requestId];
    if ([self isCorrectWithCallBackDic:response.content]) {
        if (self.isPersistence && self.requestType == CHAPIManagerRequestTypeGet) {
            if (response.isCache == NO) {
                NSString *key = [self keyWithURL:response.requestParams[@"url"] andRequestParams:response.requestParams[@"params"]];
                [[CHPresistence shardInstance] insertWiht:key andData:response.responseData];
                
            }
        }
        if (self.isCache && self.requestType == CHAPIManagerRequestTypeGet && !response.isCache) {
            NSString *key = [self keyWithURL:response.requestParams[@"url"] andRequestParams:response.requestParams[@"params"]];
            [self.cache saveCacheWithData:response.responseData key:key];
        }
        
        if (self.isPersistence) {
            if (response.isCache == YES) {
                
                [self modelWithDic:response.content];
            }
            if (self.isNativeDataEmpty) {
                
                [self modelWithDic:response.content];
            }
        }else{
            
            [self modelWithDic:response.content];
        }
    }else{
        
        [self failOnCallingAPI:response withErrorType:CHURLResponseErrorTypeNoContent];
    }
    
    

}
-(void)failOnCallingAPI:(CHURLResponse*)response withErrorType:(CHURLResponseStatus)errorType

{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.response = response;
    [self removeRequestIdWithRequestID:response.requestId];
    if (self.delegate && [self.delegate respondsToSelector:@selector(ch_requestCallApiFail:)]) {
         [self.delegate ch_requestCallApiFail:self];
    }
   
   
}

-(void)modelWithDic:(id)data
{
    
    if (self.modeClass == nil) {
        if ([self.delegate respondsToSelector:@selector(ch_requestCallAPISuccess:)]) {
            [self.delegate ch_requestCallAPISuccess:self];
        }
            }else{
                
                if ([self.delegate respondsToSelector:@selector(ch_requestCallAPISuccess:)]) {
                    id model = [self.modeClass mj_objectWithKeyValues:data];
                    self.model = model;
                    [self.delegate ch_requestCallAPISuccess:self];
                }

    }
}


#pragma mark - private methods
-(BOOL)isCorrectWithCallBackDic:(NSDictionary *)dic
{
    //这里写 返回的数据验证
    
    if ([dic[@"status"] isEqualToString:@"0"]) {
             return NO;
            }

    return YES;
}
-(NSString *)keyWithURL:(NSString *)url andRequestParams:(NSDictionary *)params
{
    return [NSString stringWithFormat:@"%@%@",url,[params CT_urlParamsStringSignature:NO]];
}
-(void)loadDataFromNative:(NSDictionary *)params
{
    NSString *key = [self keyWithURL:params[@"url"] andRequestParams:params[@"params"]];
    NSData *resutl = [[CHPresistence shardInstance]selectWithKey:key];
    if (resutl) {
        self.isNativeDataEmpty = NO;
       
        dispatch_async(dispatch_get_main_queue(), ^{
            CHURLResponse *response = [[CHURLResponse alloc]initWithData:resutl];
            
            [self successedOnCallingAPI:response];
        });
          }else{
    
        self.isNativeDataEmpty = YES;
    }
}
-(BOOL)hasCacheWithParams:(NSDictionary *)params
{
    NSString *key = [self keyWithURL:params[@"url"] andRequestParams:params[@"params"]];
    NSData *data = [self.cache fetchCachedDataWithKey:key];
    if (data == nil) {
        return NO;
    }
        dispatch_async(dispatch_get_main_queue(), ^{
        CHURLResponse *respoues = [[CHURLResponse alloc]initWithData:data];
        [self successedOnCallingAPI:respoues];
        
    });
    return YES;
}
- (void)removeRequestIdWithRequestID:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}
/*
 *这里只里初始化一次本地数据库
 */
+(void)initNativeDataBase
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[CHPresistence shardInstance] creaeTable];
    });

}
-(NSMutableArray *)requestIdList
{
    if (!_requestIdList) {
        _requestIdList = [[NSMutableArray alloc]init];
    }
    return _requestIdList;
}
-(CTCache *)cache
{
    if (!_cache) {
        _cache = [CTCache sharedInstance];
    }
    return _cache;
}
-(BOOL)isReachable
{
    FGGNetWorkStatus _Reachability = [FGGReachability networkStatus];
    
    return _Reachability == FGGNetWorkStatusNotReachable ? NO : YES;

}

@end
