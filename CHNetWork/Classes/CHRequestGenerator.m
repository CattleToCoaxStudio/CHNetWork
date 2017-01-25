//
//  CHRequestGenerator.m
//  
//
//  Created by ba on 16/6/24.
//  Copyright © 2016年 YCheng. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>
#import "CHRequestGenerator.h"
#import "NSURLRequest+CTNetworkingMethods.h"
@interface CHRequestGenerator()
@property(nonatomic,strong)AFHTTPRequestSerializer *httpRequestSerializer;
@end
@implementation CHRequestGenerator
+(instancetype)shardInstance
{
    static CHRequestGenerator *shardInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shardInstance = [[CHRequestGenerator alloc]init];
    });
    return shardInstance;
}
-(NSURLRequest *)generatorGETRequestWithParams:(NSDictionary *)params
{
    [self.httpRequestSerializer setValue:[[NSUUID UUID]UUIDString] forHTTPHeaderField:@"xx"];
    
    NSString *urlString = params[@"url"];
    NSDictionary *paramsdic = params[@"params"];
    NSLog(@"请求URL---->%@",urlString);
    NSLog(@"请求参数---->%@",paramsdic);
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:paramsdic error:nil];
    NSLog(@"请求URL+请求参数-------%@",request.URL.absoluteString);
    request.requestParams = params;
   
    return request;

}
-(NSURLRequest *)generatorPOSTRequestWithParams:(NSDictionary *)params
{
    [self.httpRequestSerializer setValue:[[NSUUID UUID]UUIDString] forHTTPHeaderField:@"xxx"];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:params[@"url"] parameters:params[@"params"] error:nil];
    NSLog(@"请求URL---->%@",params[@"url"]);
    NSLog(@"请求参数---->%@",params[@"params"]);
    NSLog(@"请求URL+请求参数-------%@",request.URL.absoluteString);
//    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params[@"params"] options:0 error:nil];
    request.requestParams = params;

    return request;
}
-(NSURLRequest *)generatorPUTRequestWithParams:(NSDictionary *)params
{
    [self.httpRequestSerializer setValue:[[NSUUID UUID]UUIDString] forHTTPHeaderField:@"xxx"];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"PUT" URLString:params[@"url"] parameters:params[@"params"] error:nil];
    
//    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params[@"params"] options:0 error:nil];
    request.requestParams = params[@"params"];
    
    return request;

}
-(NSURLRequest *)generatorDELETERequestWithParams:(NSDictionary *)params
{
    [self.httpRequestSerializer setValue:[[NSUUID UUID]UUIDString] forHTTPHeaderField:@"xxx"];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"DELETE" URLString:params[@"url"] parameters:params[@"params"] error:nil];
    
//    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params[@"params"] options:0 error:nil];
    request.requestParams = params[@"params"];
    
    return request;


}
-(AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (!_httpRequestSerializer) {
        _httpRequestSerializer = [[AFHTTPRequestSerializer alloc]init];
        _httpRequestSerializer.timeoutInterval = 20.0f;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;

}
@end
