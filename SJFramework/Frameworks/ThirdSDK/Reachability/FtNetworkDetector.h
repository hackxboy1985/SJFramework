//
//  FtNetworkDetector.h
//  FetionLogic
//
//  Created by hexingang on 14-10-9.
//  Copyright (c) 2014年 Chinasofti. All rights reserved.
//

#import <Foundation/Foundation.h>


//网络状态变化通知
#define kNotificationNetChanged  @"NetworkReachChanged"

//当前网络状态
#define FtNetwork_Wifi          ([[FtNetworkDetector startNetDetect] isWifi])
#define FtNetwork_3G_4G         ([[FtNetworkDetector startNetDetect] is3G_4G])
#define FtNetwork_2G            ([[FtNetworkDetector startNetDetect] is2G])
#define FtNetwork_NotReachable  ([[FtNetworkDetector startNetDetect] isNotReachable])


@interface FtNetworkDetector : NSObject

/**
 *	@brief  网络监测开启
 */
+(FtNetworkDetector*)startNetDetect;

-(bool)isWifi;
-(bool)is3G_4G;
-(bool)is2G;
-(bool)isNotReachable;
-(bool)isReachable;

//ViewHigh
-(int)getNetType;

@end
