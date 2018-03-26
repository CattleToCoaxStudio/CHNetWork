//
//  CHRequestGenerator.m
//  
//
//  Created by ba on 16/6/24.
//  Copyright © 2016年 YCheng. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>
#import "CHRequestGenerator.h"
#import "CHNetworkingConfig.h"
#import "NSURLRequest+CTNetworkingMethods.h"
@interface CHRequestGenerator()
@property(nonatomic,strong) AFHTTPRequestSerializer *httpRequestSerializer;
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
    
    //    [[self httpRequestSerializer] setValue:[CHNetworkingConfig shardInstance].headerValue forHTTPHeaderField:[CHNetworkingConfig shardInstance].headerKey];
    //    NSLog(@"---%@==%@",[CHNetworkingConfig shardInstance].headerKey,[CHNetworkingConfig shardInstance].headerValue);
    
    NSString *urlString = params[@"url"];
    id paramsdic = params[@"params"];
    NSLog(@"请求URL---->%@",urlString);
    NSLog(@"请求参数---->%@",paramsdic);
    NSMutableURLRequest *request = [[self httpRequestSerializer] requestWithMethod:@"GET" URLString:urlString parameters:params[@"params"] error:nil];
    [request setValue:[CHNetworkingConfig shardInstance].headerValue forHTTPHeaderField:[CHNetworkingConfig shardInstance].headerKey];
    NSLog(@"请求URL+请求参数-------%@",request.URL.absoluteString);
    request.requestParams = params;
    
    return request;
    
}
-(NSURLRequest *)generatorPOSTRequestWithParams:(NSDictionary *)params
{
    
    NSMutableURLRequest *request = [[self httpRequestSerializer] requestWithMethod:@"POST" URLString:params[@"url"] parameters:params[@"params"] error:nil];
    [request setValue:[CHNetworkingConfig shardInstance].headerValue forHTTPHeaderField:[CHNetworkingConfig shardInstance].headerKey];
    NSLog(@"请求URL---->%@",params[@"url"]);
    NSLog(@"请求参数---->%@",params[@"params"]);
    NSLog(@"请求URL+请求参数-------%@",request.URL.absoluteString);
    request.requestParams = params;
    
    return request;
}
-(NSURLRequest *)generatorPUTRequestWithParams:(NSDictionary *)params
{
    
    NSMutableURLRequest *request = [[self httpRequestSerializer] requestWithMethod:@"PUT" URLString:params[@"url"] parameters:params[@"params"] error:nil];
    [request setValue:[CHNetworkingConfig shardInstance].headerValue forHTTPHeaderField:[CHNetworkingConfig shardInstance].headerKey];
    request.requestParams = params[@"params"];
    return request;
    
}
-(NSURLRequest *)generatorDELETERequestWithParams:(NSDictionary *)params
{
    NSMutableURLRequest *request = [[self httpRequestSerializer] requestWithMethod:@"DELETE" URLString:params[@"url"] parameters:params[@"params"] error:nil];
    [request setValue:[CHNetworkingConfig shardInstance].headerValue forHTTPHeaderField:[CHNetworkingConfig shardInstance].headerKey];
    request.requestParams = params[@"params"];
    
    return request;
    
    
}

- (NSURLRequest *)generatorUploadRequestWithParams:(NSDictionary *)params{
    [[self httpRequestSerializer] setValue:[CHNetworkingConfig shardInstance].headerValue forHTTPHeaderField:[CHNetworkingConfig shardInstance].headerKey];
    NSMutableURLRequest *request = [[self httpRequestSerializer] multipartFormRequestWithMethod:@"POST" URLString:params[@"url"] parameters:params[@"params"] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSArray *images = params[@"images"];
        for (int i = 0;i < images.count;i++) {
            UIImage *image = images[i];
            NSString *name = [NSString stringWithFormat:@"file%d",i];
            NSData * data = UIImageJPEGRepresentation(image,1); //将拍下的图片转化成
            [formData appendPartWithFileData:data name:name fileName:@".jpg" mimeType:@"jpg"];
        }
    } error:nil];
    NSLog(@"请求URL---->%@",params[@"url"]);
    NSLog(@"请求参数---->%@",params[@"params"]);
    NSLog(@"请求URL+请求参数-------%@",request.URL.absoluteString);
    request.requestParams = params;
    [request setValue:[CHNetworkingConfig shardInstance].headerValue forHTTPHeaderField:[CHNetworkingConfig shardInstance].headerKey];
    return request;
}

-(AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (!_httpRequestSerializer) {
        
        _httpRequestSerializer = [AFJSONRequestSerializer serializer];
        if ([CHNetworkingConfig shardInstance].requestType == 2) {
            _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        }
        _httpRequestSerializer.timeoutInterval = 20.0f;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    
    if ([CHNetworkingConfig shardInstance].requestType == 2) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
    }else{
        _httpRequestSerializer = [AFJSONRequestSerializer serializer];
    }
    return _httpRequestSerializer;
}

@end
