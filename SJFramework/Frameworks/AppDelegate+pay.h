//
//  AppDelegateExten.h
//  User
//
//  Created by Born on 15/8/1.
//  Copyright (c) 2015年 Hkzr All rights reserved.
//

#import "AppDelegateBase.h"


//分享头文件
#ifdef SHARE_SDK

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#endif

#define PAY_RESULT @"PAY_RESULT"//支付结果,携带一个NSNumber:0失败，1成功，2取消
#define SHARE_2_WX @"SHARE_2_WX"//分享到微信

#define PAY_SUCC 1 //支付成功
#define PAY_CANCEL 2 //支付取消
#define PAY_FAIL 0 //支付失败




/********************************************************
 *  AppDelgate(分享及支付分类)
 ********************************************************/
@interface AppDelegateBase (share_pay)

//处理openUrl
- (BOOL)applicationSharePay:(UIApplication *)application handleOpenURL: (NSURL *)url;

//处理openUrl
- (BOOL)applicationSharePay: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication annotation: (id)annotation;


////////////////////////////////////////////////
#pragma mark - 分享
////////////////////////////////////////////////

//初始化社交平台
- (void)initializePlat;

#ifdef SHARE_SDK

//qq分享
- (void)shareButtonPressed:(ShareType)type content:(NSString*)content defaultContent:(NSString*)defaultContent imageName:(NSString*)imageName url:(NSString*)url;

#endif

#ifdef WX_SDK

//wx会话,选择好友
-(void)wxSessionScene:(NSString*)content;

//wx朋友圈 分享到朋友圈
-(void)wxTimelineScene:(NSString*)content;

#endif

////////////////////////////////////////////////
#pragma mark - 支付
////////////////////////////////////////////////

//微信支付
- (void)wxSendPay:(NSString *)TradeNO price:(float)price;

//支付宝支付
- (void)alipay:(NSString *)TradeNO price:(float)price;


@end

