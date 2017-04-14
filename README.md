# CHNetWork

[![CI Status](http://img.shields.io/travis/chengyou.yang/CHNetWork.svg?style=flat)](https://travis-ci.org/chengyou.yang/CHNetWork)
[![Version](https://img.shields.io/cocoapods/v/CHNetWork.svg?style=flat)](http://cocoapods.org/pods/CHNetWork)
[![License](https://img.shields.io/cocoapods/l/CHNetWork.svg?style=flat)](http://cocoapods.org/pods/CHNetWork)
[![Platform](https://img.shields.io/cocoapods/p/CHNetWork.svg?style=flat)](http://cocoapods.org/pods/CHNetWork)

## CHNetwork提供的功能
CHNetwork是基于AFNetworking二次封装的，CHNetwork提供了以下功能：
- 支持按时间缓存网络请求内容
    ```
    设置缓存时间 单位秒（s），加到appdelegate里面：
    [CHNetworkingConfig shardInstance].cacheTime = 1800;不设置默认是1800秒
    ```
- 支持设置httpRequest header
    ```
    在请求头里加入token：
    [[CHNetworkingConfig shardInstance] httpRequestSetValue:@"token" forHTTPHeaderField:@"token"];
    ```
- 暂只支持delegate回调的方式
    ```
    block方式：对于小型项目逻辑不复杂 控制器调用接口只有一个时 更直观更方便（需要注意循环引用的问题）
    delegate：对于逻辑比较复杂 在一个控制器调用多次接口和需要对同一状态做处理时 让数据走同一方法返回，更增强代码可读性和可维护性（不用处理循环引用的问题）
    ```
- 支持网络状态判断（在网络请求失败的情况，可以根据返回状态提示用户）
- 支持在统一的方法里设置loading页面（如果不实现该方法将加载默认loading页面）
    ```
    回调方法如下：

    配置请求参数
    -(NSDictionary *)ch_paramWith:(CHNetWorking *)manager;
    请求成功回调
    -(void)ch_requestCallAPISuccess:(CHNetWorking *)manager;
        manager.response.content 获取服务器返回内容
        manager.model  转换后的模型
    失败请求回调
    -(void)ch_requestCallApiFail:(CHNetWorking *)manager;
        manager.response.status 根据此状态（枚举）提示用户
    
    下面两个代理可以不实现，将使用该库默认的提示样式。可以在你的BaseViewController实现这两个方法，加入自定义样式。如果不要加载提示，提供了两个只有方法的宏定义  
    CHNetworkingStart  
    CHNetworkingEnd

    开始请求回调
    - (void)ch_startAccessTheNetwork:(CHNetWorking *)manager;
    结束请求回调
    - (void)ch_endAccessTheNetwork:(CHNetWorking *)manager;
    ```
- 支持模型转换（传入class返回对应的模型）
    使用如下：
    ```
    这里模型转换对服务器返回格式有要求，如：
    {
        msg:@"这是服务器返回的提示信息",
        data:@{}/@[]/@"",
        status:@"返回的状态码"
    }

    在CHNetWorking类里，在成功拿到数据后，取的data字段进行模型转换。
    如果data是数组：传入的模型是它里面的对象模型，返回的就是一个该模型的数组

    [CHNetWorking ch_GetRequestWithDeleagteTarget:self andRequestType:CHAPIManagerRequestTypeGet andClass:[CoreObject_PostsTip class] andIsPersistence:NO andNumber:1];
    ```

- 支持对get请求参数编码
## Example
```
发起网络请求
[CHNetWorking ch_GetRequestWithDeleagteTarget:self andRequestType:CHAPIManagerRequestTypeGet andClass:[CoreObject_PostsTip class] andIsPersistence:NO andNumber:1];

/**
网络请求 参数配置代理

@param manager manager
@return 参数配置回调方法
*/
- (NSDictionary *)ch_paramWith:(CHNetWorking *)manager{

if (manager.requestNumber == 1) {
    //获取首页数据
    return @{@"url":LoadTipList,@"params":@{@"appId":DEVICEUUID,@"page":StringValue(_startIndex),@"rows":StringValue(_pageSize)}};
}else if (manager.requestNumber == 2){
    //更新读取状态
    return @{@"url":UpdateReadStatu,@"params":@{@"tipId":_tipId}};
}
    return nil;
}

/**
网络请求成功回调

@param manager manager
*/
- (void)ch_requestCallAPISuccess:(CHNetWorking *)manager{

    if ([manager.response.content[@"status"] intValue] != 1) {
        [XHToast showCenterWithText:manager.response.content[@"msg"]];
    }else{
        if (manager.requestNumber == 1) {
            
        }else if(manager.requestNumber == 2){
            
        }
        //往数据源添加模型数组
        [_dataSource addObjectsFromArray:manager.model];
        [self.tableView reloadData];
    }
}


/**
网络请求失败回调

@param manager manager
*/
- (void)ch_requestCallApiFail:(CHNetWorking *)manager{
    //此处可以根据状态提示
    [XHToast showBottomWithText:@"网络错误!"];
}

//网络请求 开始和结束回调
CHNetworkingStart  
CHNetworkingEnd

```

## Requirements

ios8+

## Installation

CHNetWork is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CHNetWork'
```

## Author

chengyou.yang, 864390553@qq.com

## License

CHNetWork is available under the MIT license. See the LICENSE file for more info.
