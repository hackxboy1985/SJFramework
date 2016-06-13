//
//  Header.h
//  Doctor
//
//  Created by born on 16/4/5.
//  Copyright (c) 2016年 Hkzr All rights reserved.
//
#import <Foundation/Foundation.h>

/********************************************************
 *  需要每个项目自己实现的App基础业务接口
 *  基础业务接口主要是框架无法抽象，比如启动后要做的逻辑(appLaunching)、注销逻辑(appLogout)
 ********************************************************/
@protocol AppBusinessApi <NSObject>


////////////////////////////////////////////////
#pragma mark - 登录状态管理
////////////////////////////////////////////////

/**
 *  启动时调用,可以在该方法实现里根据业务判断调用：是否自动登录、显示主页、登录页面等功能.
 */
-(void)appLaunching;

/**
 * @brief 登录成功后调用此方法
 */
- (void)appLoginSuccessful;

/*
 * @brief 退出账号时或被IM踢下线时调用此方法
 */
-(void)appLogout;

/**
 * @brief 重新登录(修改密码场景调用)
 */
-(void)appRelogin;

/**
 * @brief 存储账号密码
 * @param account 账号
 * @param pwd 密码
 */
-(void)saveUserAccount:(NSString*)account pwd:(NSString*)pwd;


/**
 * @brief 设置登录状态
 * @param isLogin 登录状态
 * @return N/A
 */
-(void)setLoginStatus:(BOOL)isLogin;

/**
 * @breif 获得登录状态
 * @return bool 登录状态 true/false
 */
-(BOOL)getLoginStatus;


/**
 * @brief 获得登户名（用于第三方登录时使用，如：分享、环信等)
 * @return NSString* 名称(通常为姓名或昵称)
 */
-(NSString*)getUserName;


/**
 * @brief 获得登户账号（用于第三方登录时使用，如：分享、环信等)
 * @return NSString* 登录名(通常为手机号)
 */
-(NSString*)getUserAccount;


/**
 * @brief 获得密码
 * @return NSString* 密码(通常与密码保持一致，也可不一致)
 */
-(NSString*)getUserPwd;

/**
 * @brief 获得登户账号（用于第三方登录时使用，如：分享、环信等)
 * @return NSString* 登录名(通常为手机号)
 */
-(NSString*)getImAccount;

/**
 * @brief 获得密码（用于第三方登录时使用，如：分享、环信等)
 * @return NSString* 密码(通常与密码保持一致，也可不一致)
 */
-(NSString*)getImPwd;

////////////////////////////////////////////////
#pragma mark - jpush消息回调
////////////////////////////////////////////////

/**
 * @brief 收到jpush注册id
 */
-(void)rcvJpushRegistrationID:(NSString*)RegistrationID;

/**
 * @brief 处理收到的推送消息
 */
-(void)handleJpush:(NSDictionary*)userInfo identifier:(NSString*)identifier;


@end



