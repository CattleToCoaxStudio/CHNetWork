//
//  CHApiProxy.h
//  
//
//  Created by ba on 16/6/24.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHURLResponse.h"
typedef void(^ApiCallBack)(CHURLResponse *response);
@interface CHApiProxy : NSObject
+(instancetype)shardInstance;
-(NSURLSessionDataTask*)callGETwithParams:(NSDictionary*)params success:(ApiCallBack)success fail:(ApiCallBack)fail;
-(NSURLSessionDataTask*)callPOSTwithParams:(NSDictionary*)params success:(ApiCallBack)success fail:(ApiCallBack)fail;
-(NSURLSessionDataTask*)callPUTwithParams:(NSDictionary*)params success:(ApiCallBack)success fail:(ApiCallBack)fail;
-(NSURLSessionDataTask*)callDELETEwithParams:(NSDictionary*)params success:(ApiCallBack)success fail:(ApiCallBack)fail;
-(void)cancelRequestWithRequesID:(NSNumber*)requestID;
-(void)cancelRequestWithRequestList:(NSArray *)requestIDList;
@end
