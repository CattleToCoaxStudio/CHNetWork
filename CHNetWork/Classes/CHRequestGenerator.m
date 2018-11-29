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
#import "NSData+CHEncrypt.h"
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
    NSString *urlString = params[@"url"];
    NSLog(@"请求URL---->%@",urlString);
    
    NSMutableURLRequest *request = [[self httpRequestSerializer] requestWithMethod:@"GET" URLString:urlString parameters:[self getValidParams:params[@"params"]] error:nil];
    [self setRequestHeader:request];
    NSLog(@"请求URL+请求参数-------%@",request.URL.absoluteString);
    request.requestParams = params;
    
    return request;
    
}
-(NSURLRequest *)generatorPOSTRequestWithParams:(NSDictionary *)params
{
    
    NSMutableURLRequest *request = [[self httpRequestSerializer] requestWithMethod:@"POST" URLString:params[@"url"] parameters:[self getValidParams:params[@"params"]] error:nil];
    [self setRequestHeader:request];
    NSLog(@"请求URL---->%@",params[@"url"]);
    NSLog(@"请求URL+请求参数-------%@",request.URL.absoluteString);
    request.requestParams = params;
    
    return request;
}
-(NSURLRequest *)generatorPUTRequestWithParams:(NSDictionary *)params
{
    
    NSMutableURLRequest *request = [[self httpRequestSerializer] requestWithMethod:@"PUT" URLString:params[@"url"] parameters:[self getValidParams:params[@"params"]] error:nil];
    [self setRequestHeader:request];
    request.requestParams = params[@"params"];
    return request;
    
}
-(NSURLRequest *)generatorDELETERequestWithParams:(NSDictionary *)params
{
    NSMutableURLRequest *request = [[self httpRequestSerializer] requestWithMethod:@"DELETE" URLString:params[@"url"] parameters:[self getValidParams:params[@"params"]] error:nil];
    [self setRequestHeader:request];
    request.requestParams = params[@"params"];
    
    return request;
    
    
}

- (NSURLRequest *)generatorUploadRequestWithParams:(NSDictionary *)params{
    
    NSMutableURLRequest *request = [[self httpRequestSerializer] multipartFormRequestWithMethod:@"POST" URLString:params[@"url"] parameters:[self getValidParams:params[@"params"]] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSArray *images = params[@"images"];
        for (int i = 0;i < (int)images.count;i++) {
            UIImage *image = images[i];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            NSData * data = UIImageJPEGRepresentation(image,0.5);
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:data name:@"images[]" fileName:fileName mimeType:@"image/jpeg"];
        }
    } error:nil];
    NSLog(@"请求URL---->%@",params[@"url"]);
    NSLog(@"请求URL+请求参数-------%@",request.URL.absoluteString);
    request.requestParams = params;
    [self setRequestHeader:request];
    return request;
}

- (void)setRequestHeader:(NSMutableURLRequest *)request{
    
        NSDictionary *headerDic = [CHNetworkingConfig shardInstance].headerDic;
        for (int i= 0; i < headerDic.allKeys.count; i ++) {
            NSString *value = [headerDic valueForKey:headerDic.allKeys[i]];
            NSString *key = headerDic.allKeys[i];
            [request setValue:value forHTTPHeaderField:key];
        }
//        [request setValue:[NSString stringWithFormat:@"%.0lf",[self nowTimeInterval]] forHTTPHeaderField:@"timestamp"];
}

- (AFHTTPRequestSerializer *)httpRequestSerializer
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

- (NSTimeInterval)nowTimeInterval{
    NSDate *nowDate = [NSDate date];
    NSTimeInterval time = [nowDate timeIntervalSince1970] * 1000;
    return time;
}

- (NSDictionary *)getValidParams:(NSDictionary *)param{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    NSDictionary *commonDic = [CHNetworkingConfig shardInstance].commonParams;
    
    for (int i= 0; i < (int)commonDic.allKeys.count; i ++) {
        NSString *value = [commonDic valueForKey:commonDic.allKeys[i]];
        NSString *key = commonDic.allKeys[i];
        [dic setObject:value forKey:key];
    }
    if ([CHNetworkingConfig shardInstance].encryptType == 0) {
        return [dic copy];
    }
    NSLog(@"请求参数---->%@",dic);
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSData *encrypted = [data ch_encryptedWith3DESUsingKey:[CHNetworkingConfig shardInstance].secretKey andIV:[[CHNetworkingConfig shardInstance].offset dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *baseDESStr = [encrypted ch_base64EncodedString];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    for (int i= 0; i < (int)commonDic.allKeys.count; i ++) {
        NSString *value = [commonDic valueForKey:commonDic.allKeys[i]];
        NSString *key = commonDic.allKeys[i];
        [paramDic setObject:value forKey:key];
    }
//    if ([CHNetworkingConfig shardInstance].token) {
//        NSString *token = [CHNetworkingConfig shardInstance].token;
//        [paramDic setValue:token forKey:@"token"];
//    }
    [paramDic setObject:baseDESStr forKey:[CHNetworkingConfig shardInstance].dataKey];
    NSLog(@"加密后请求参数---->%@",paramDic);
    return [paramDic copy];
}


@end
