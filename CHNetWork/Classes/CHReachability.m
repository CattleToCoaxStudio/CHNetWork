//
//  CHNetworkingConfig.h
//  Pods

#import "CHReachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>


@implementation CHReachability

/**
 *  判断网络状态：包含2G,Edge,3G,4G可用和wifi可用和网络不可用
 *
 *  @return 网络状态
 */
+(CHNetWorkStatus)networkStatus
{
    //wifi可用
    if([self isWifiEnable])
        return CHNetWorkStatusWifi;
    //蜂窝移动网络可用,再具体细分(2G,3G,4G,2.75G(Edge))
    else if([self isCarrierConnectEnable])
        //运营商网络判断
        return [self carrierStatus];
    //网络不可用
    else
        return CHNetWorkStatusNotReachable;
}
//wifi是否可用
+(BOOL)isWifiEnable
{
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus]==ReachableViaWiFi);
}
//蜂窝移动网络是否可用
+(BOOL)isCarrierConnectEnable
{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]==ReachableViaWWAN);
}
/**
 *  运营商网络状态
 *
 *  @return 网络状态
 */
+(CHNetWorkStatus)carrierStatus
{
    CTTelephonyNetworkInfo *info=[CTTelephonyNetworkInfo new];
    NSString *status=info.currentRadioAccessTechnology;
    
    if([status isEqualToString:CTRadioAccessTechnologyCDMA1x]||[status isEqualToString:CTRadioAccessTechnologyGPRS])
        return CHNetWorkStatus2G;
    else if([status isEqualToString:CTRadioAccessTechnologyEdge])
        return CHNetWorkStatusEdge;
    else if([status isEqualToString:CTRadioAccessTechnologyLTE])
        return CHNetWorkStatus4G;
    else
        return CHNetWorkStatus3G;
}
@end
