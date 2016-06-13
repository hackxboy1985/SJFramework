//
//  FtNetworkDetector.m
//  FetionLogic
//
//  Created by hexingang on 14-10-9.
//  Copyright (c) 2014年 Chinasofti. All rights reserved.
//

#import "FtNetworkDetector.h"
#import "NetWorkReachability.h"

@interface FtNetworkDetector()<NetworkReachabilityDelegate>

@property (nonatomic, strong) NetworkReachability * netWorkReach;

@end

@implementation FtNetworkDetector


static FtNetworkDetector* networkDetector = nil;
+(FtNetworkDetector*)startNetDetect
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkDetector = [[FtNetworkDetector alloc] init];
    });
    return networkDetector;
}

- (id)init
{
    //NSLog(@"网络监测开启");
    self.netWorkReach = [[NetworkReachability alloc] initWithZeroAddress];
    self.netWorkReach.delegate = self;
    
    //当前网络状态通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNetChanged object:[NSNumber numberWithInteger:self.netWorkReach.status]];
    
    return self;
}

/**
 *	@brief	网络变化通知
 *	@param 	reachability    NetworkReachability实体
 */
- (void) networkReachabilityDidUpdate:(NetworkReachability*)reachability{
    switch (reachability.status) {
        case eNotReachable:
        {
            NSLog(@"网络监测 无网络连接");
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNetChanged object:[NSNumber numberWithInteger:reachability.status]];
        }
            break;
        case eReachableViaWiFi:{
            NSLog(@"网络监测 网络连接通过WiFi");
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNetChanged object:[NSNumber numberWithInteger:reachability.status]];

        }
            break;
        case eReachableVia3G:{//4G同样调用
            NSLog(@"网络监测 网络连接通过 3G or 4G");
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNetChanged object:[NSNumber numberWithInteger:reachability.status]];

        }
            break;
        case eReachableVia2G:{
            NSLog(@"网络监测 网络连接通过 2G");
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNetChanged object:[NSNumber numberWithInteger:reachability.status]];

        }
            break;
        default:
            NSLog(@"[网络监测] 检测到网络结果%d ",reachability.status);
            break;
    }
}

-(bool)isWifi
{
    return self.netWorkReach.status == eReachableViaWiFi;
}

-(bool)is3G_4G
{
    return self.netWorkReach.status == eReachableVia3G;
}

-(bool)is2G
{
    return self.netWorkReach.status == eReachableVia2G;
}

-(bool)isNotReachable
{
    return self.netWorkReach.status == eNotReachable;
}

-(bool)isReachable
{
    return self.netWorkReach.status != eNotReachable;
}

-(int)getNetType{
    /*
    0--wifi
    1--3G
    2--4G
    3--GPRS
     */
    if([self isWifi])
        return 0;
    if([self is3G_4G])
        return 1;
    if([self is2G])
        return 3;
    
    return -1;
}

@end





