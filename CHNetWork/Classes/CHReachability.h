//
//  CHNetworkingConfig.h
//  Pods
/*
 ----------------------------------------------------
 CHReachability用法简介：
 1.导入CoreTelephony.framework框架
 2.导入#import <CoreTelephony/CTTelephonyNetworkInfo.h>
 3.导入#import <CoreTelephony/CTCarrier.h>
 4.导入#import "CHReachability.h"头文件
 5.获取当前网络状态：CHNetWorkStatus status=[CHReachability networkStatus];
 6.作出判断
 ==>若status==CHNetWorkStatus2G，则当前网络状态为2G；
 ==>若status==CHNetWorkStatusEdge，则当前网络状态为2.75G(Edge)；
 ==>若status==CHNetWorkStatus3G，则当前网络状态为3G；
 ==>若status==CHNetWorkStatus4G，则当前网络状态为4G；
 ==>若status==CHNetWorkStatusWifi，则当前网络状态为wifi；
 ==>若status==CHNetWorkStatusNotReachable，则当前网络状态为不可用；
 ==>若status!=CHNetWorkStatusNotReachable,则当前网络状态可用(包含wifi和蜂窝移动网络)。
 */
#import <Foundation/Foundation.h>
#import "Reachability.h"

//定义网络状态
typedef NS_ENUM(NSInteger, CHNetWorkStatus){
    CHNetWorkStatusNotReachable=0,
    CHNetWorkStatus2G,
    CHNetWorkStatusEdge,
    CHNetWorkStatus3G,
    CHNetWorkStatus4G,
    CHNetWorkStatusWifi,
};

@interface CHReachability : NSObject

@property(nonatomic,strong) Reachability *reachability;

/**判断网络是否可用*/
+(CHNetWorkStatus)networkStatus;

@end
