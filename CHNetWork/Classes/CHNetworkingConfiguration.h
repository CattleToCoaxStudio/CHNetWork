//
//  CHNetworkingConfiguration.h
//  CTNetworking
//
//  Created by ba on 16/6/25.
//  Copyright © 2016年 Long Fan. All rights reserved.
//

#ifndef CHNetworkingConfiguration_h
#define CHNetworkingConfiguration_h
typedef NS_ENUM(NSUInteger, CHURLResponseStatus)
{
    CHURLResponseStatusSuccess, //请求成功
    CHURLResponseStatusErrorTimeout,//请求超时
    CHURLResponseStatusCancelled,//用户取消
    
    CHURLResponseStatusErrorNoNetwork,// 默认除了超时以外的错误都是无网络错误。
    CHURLResponseErrorTypeNoContent,     //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    
    CHURLResponseErrorTypeDefault,       //没有产生过API请求，这个是manager的默认状态。
    
    CHURLResponseErrorTypeNoNetWork      //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
};

#endif /* CHNetworkingConfiguration_h */
