//
//  AppDelegateExten.h
//  User
//
//  Created by Born on 15/8/1.
//  Copyright (c) 2015年 Hkzr All rights reserved.
//

#import "AppDelegateBase.h"
#import "APService.h"

//jpush相关定义
#define PUSH_MESSAGE @"PushMessage"



/********************************************************
 *  AppDelgate(基本登录相关逻辑扩展分类)
 ********************************************************/
@interface AppDelegateBase (Login)

/**
 * @brief 业务登录成功后调用，主要用于注册环信、极光alias等第三方库
 */
- (void)notifyModelLoginSuccessful;

/**
 * @brief 业务退出账号后调用，主要用于注销环信、极光alias等第三方库
 */
- (void)notifyModelLogout;

/**
 * @brief 业务重新登录时调用
 */
//-(void)relogin;


@end









/********************************************************
 *  AppDelgate(jpush分类)
 ********************************************************/
@interface AppDelegateBase (jpush)

/**
 * @brief 注册jpush,初始化jpush
 */
- (void)registerJPushWithOptions:(NSDictionary *)launchOptions withApp:(UIApplication*)application;


/**
 * @brief 注册alias
 */
- (void)registerAlias;

/**
 * @brief 反注册alias
 */
- (void)unregisterAlias;

/**
 * @brief 收到消息
 * @param userInfo push附加信息
 */
- (void)handlePush:(NSDictionary *)userInfo identifier:(NSString*)identifier;
@end








/********************************************************
 *  AppDelgate(友盟分类)
 ********************************************************/
@interface AppDelegateBase (umeng)

/**
 * @brief 初始化友盟
 */
- (void)initUmengTrack;

@end


/********************************************************
 *  AppDelgate(网络监听分类)
 ********************************************************/
@interface AppDelegateBase (NetworkType)

/**
 * @brief 初始化网络状态监听
 */
- (void)initNetworkMonitor;

@end



/********************************************************
 *  AppDelgate(UUID分类)
 ********************************************************/
@interface AppDelegateBase (UUID)

/**
 * @brief 初始化UUID
 */
- (void)initUUID;

/**
 * @brief 获得UUID
 */
-(NSString*)getUUID;

@end




