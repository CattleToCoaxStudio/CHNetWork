//
//  CHURLResponse.m
//  CTNetworking
//
//  Created by ba on 16/6/25.
//  Copyright © 2016年 Long Fan. All rights reserved.
//

#import "CHURLResponse.h"
#import "NSURLRequest+CTNetworkingMethods.h"
#import "NSObject+AXNetworkingMethods.h"
@interface CHURLResponse()
@property (nonatomic,assign,readwrite)CHURLResponseStatus status;
@property (nonatomic, copy, readwrite) NSString *contentString;
@property (nonatomic, copy, readwrite) id content;
@property (nonatomic, copy, readwrite) NSURLRequest *request;
@property (nonatomic, assign, readwrite) NSInteger requestId;
@property (nonatomic, copy, readwrite) NSData *responseData;
@property (nonatomic, assign, readwrite) BOOL isCache;

@end
@implementation CHURLResponse
-(instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error
{
    self = [super init];
    if (self) {
        if (responseData) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        } else {
            self.content = nil;
        }
    
        self.contentString = [responseString CT_defaultValue:@""];
        self.status = [self responesStatusWithErroe:error];
        self.requestId = [requestId integerValue];
        self.responseData = responseData;
        self.requestParams = request.requestParams;
        self.request = request;
        self.isCache = NO;
    }
    return self;
}
-(instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData status:(CHURLResponseStatus)status
{
    self = [super init];
    if (self) {
        self.contentString = responseString;
        if (responseData) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
            
        } else {
            self.content = nil;
        }
        self.status = status;
        self.request = request;
        self.requestId = [requestId integerValue];
        self.responseData = responseData;
        self.requestParams = request.requestParams;
        self.isCache = NO;
    }
    return self;
}
-(instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        self.contentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.status = [self responesStatusWithErroe:nil];
        self.requestId = 0;
        self.request = nil;
        self.responseData = [data copy];
        self.content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        self.isCache = YES;
    }
    return self;
}
-(CHURLResponseStatus)responesStatusWithErroe:(NSError*)error
{
    if (error) {
        CHURLResponseStatus status = CHURLResponseStatusErrorNoNetwork;
        if (error.code == NSURLErrorTimedOut) {
            status = CHURLResponseStatusErrorTimeout;
        }
        if (error.code == NSURLErrorCancelled) {
            status = CHURLResponseStatusCancelled;
        }
        return status;
    }else{
        return CHURLResponseStatusSuccess;
    }
}
@end
