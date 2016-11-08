//
//  CHApiProxy.m
//  
//
//  Created by ba on 16/6/24.
//  Copyright © 2016年 YCheng. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>
#import "CHApiProxy.h"
#import "CHRequestGenerator.h"

@interface CHApiProxy()
@property(nonatomic,strong)AFHTTPSessionManager *sessionManager;
@property(nonatomic,strong)NSMutableDictionary *TaskTable;
@end
@implementation CHApiProxy
-(AFHTTPSessionManager *)sessionManager
{
    if (!_sessionManager) {
       _sessionManager = [AFHTTPSessionManager manager];
       _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
       _sessionManager.securityPolicy.allowInvalidCertificates = NO;
       _sessionManager.securityPolicy.validatesDomainName = NO;
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
    }
    return _sessionManager;
}
-(NSMutableDictionary *)TaskTable
{
    if (!_TaskTable) {
        _TaskTable = [[NSMutableDictionary alloc]init];
    }
    return _TaskTable;
}
+(instancetype)shardInstance
{
    static CHApiProxy *shardInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shardInstance = [[CHApiProxy alloc]init];
    });
    return shardInstance;

}
-(NSURLSessionDataTask*)callGETwithParams:(NSDictionary *)params success:(ApiCallBack)success fail:(ApiCallBack)fail
{
    NSURLRequest *request = [[CHRequestGenerator shardInstance] generatorGETRequestWithParams:params];
    return  [self callApiWithRequest:request success:success fail:fail];

    
}

-(NSURLSessionDataTask*)callPOSTwithParams:(NSDictionary *)params success:(ApiCallBack)success fail:(ApiCallBack)fail
{
    NSURLRequest *request = [[CHRequestGenerator shardInstance]generatorPOSTRequestWithParams:params];
    return  [self callApiWithRequest:request success:success fail:fail];
    
   

}
-(NSURLSessionDataTask*)callPUTwithParams:(NSDictionary *)params success:(ApiCallBack)success fail:(ApiCallBack)fail
{
    NSURLRequest *request = [[CHRequestGenerator shardInstance]generatorPUTRequestWithParams:params];
   return  [self callApiWithRequest:request success:success fail:fail];
    
    

}
-(NSURLSessionDataTask*)callDELETEwithParams:(NSDictionary *)params success:(ApiCallBack)success fail:(ApiCallBack)fail
{
    NSURLRequest *request = [[CHRequestGenerator shardInstance]generatorGETRequestWithParams:params];
     return  [self callApiWithRequest:request success:success fail:fail];
    

}
-(void)cancelRequestWithRequesID:(NSNumber *)requestID
{
    NSURLSessionDataTask *requestOperation = self.TaskTable[requestID];
    [requestOperation cancel];
    [self.TaskTable removeObjectForKey:requestID];
}
-(void)cancelRequestWithRequestList:(NSArray *)requestIDList
{
    for (NSNumber *requestID in requestIDList) {
        
        [self cancelRequestWithRequesID:requestID];
    }

}

-(NSURLSessionDataTask*)callApiWithRequest:(NSURLRequest*)request success:(ApiCallBack)success fail:(ApiCallBack)fail
{

    __block NSURLSessionDataTask *dataTask =nil;
  dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
      
      NSNumber *requestID = @([dataTask taskIdentifier]);
      [self.TaskTable removeObjectForKey:requestID];
      NSData *responseData = responseObject;
      
      NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject ? responseObject : [NSData data] options:NSJSONReadingMutableContainers error:nil];
      
      NSString *responseString = [[NSString alloc]initWithData:responseObject ? responseObject : [NSData data] encoding:NSUTF8StringEncoding];
      if (error) {
          CHURLResponse *CHRrsponse = [[CHURLResponse alloc]initWithResponseString:responseString requestId:requestID request:request responseData:responseData error:error];
          NSLog(@"错误信息---->%@",error);
          fail ? fail(CHRrsponse) : nil;
      }else{
          CHURLResponse *CHResponse = [[CHURLResponse alloc]initWithResponseString:responseString requestId:requestID request:request responseData:responseData status:CHURLResponseStatusSuccess];
          NSLog(@"返回数据---->%@",responseDic);
          success ? success(CHResponse) : nil;
         }
      }];

   NSNumber *requestID = @([dataTask taskIdentifier]);
    self.TaskTable[requestID] = dataTask;
     [dataTask resume];
    return dataTask;
}

@end
