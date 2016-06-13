//
//  LoginViewModel.h
//  Doctor
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 ViewHigh. All rights reserved.
//

#import "ViewModelBase.h"
@class ShieldVersionDto;


/********************************************************
 * @brief 登录模块逻辑类
 ********************************************************/

@interface LoginViewModel : ViewModelBase
@property (strong) ShieldVersionDto *shield;/**< 屏蔽项对象*/

/**
 *  @brief 处理用户登录请求
 *
 *  @param block 回调的 block
 *  @param user  用户输入的手机号码
 *  @param pwd   用户输入的密码
 */
-(void)loginWithBlock:(BusinessCallback) block withUser:(NSString*)user withPwd:(NSString*)pwd;


/**
 *  @brief 绑定上传jpush注册标识,服务器根据此标识进行极光推送
 *
 *  @param registrationId  jpush推送的注册标识
 */
-(void)bindPushRegistration:(NSString*)registrationId;

/**
 *  @brief 请求获得版本信息及屏蔽项
 */
-(void)versionAndShield;



/**
 * @brief 是否屏蔽日程
 */
-(BOOL)isShieldSchedule;

/**
 * @brief 是否屏蔽随访
 */
-(BOOL)isShieldFollowPlan;

/**
 * @brief 是否屏蔽电子处方
 */
-(BOOL)isShieldPrescribe;

/**
 * @brief 是否屏蔽版本更新提示
 */
-(BOOL)isShieldVersionUpdates;



@end








/********************************************************
 * @brief 版本更新相关类
 ********************************************************/
@interface VersionUpdatesDto : NSObject
@property (assign) NSInteger platformType;//平台类型 1安卓 2IOS
@property (copy)NSString* channel;      //渠道
@property (copy)NSString* appVersion;   //APP版本号
@property (assign)NSInteger isCall;     //是否提醒:1提示 2强制提示 3不提示 (因变量默认值是0,因此也不提示)
@property (copy)NSString* downLoadUrl;  //下载地址（isCall为1，2 时有效）
@property (copy)NSString* content;      //更新内容描述（isCall为1，2 时有效）

@end

/********************************************************
 * @brief 屏蔽项&版本更新相关类
 ********************************************************/
@interface ShieldVersionDto : NSObject
@property (strong) NSArray *restList;                   //屏蔽项列表rest数组
@property (strong) VersionUpdatesDto *versionUpdatesDto;//版本更新DTO

-(void)save;
+(ShieldVersionDto*)load;


/**
 * @brief 是否屏蔽日程
 */
-(BOOL)isShieldSchedule;

/**
 * @brief 是否屏蔽随访
 */
-(BOOL)isShieldFollowPlan;

/**
 * @brief 是否屏蔽随访
 */
-(BOOL)isShieldPrescribe;

/**
 * @brief 是否屏蔽版本更新提示
 */
-(BOOL)isShieldVersionUpdates;

@end
