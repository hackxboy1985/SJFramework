//
//  IAppImBusiness.h
//  Doctor
//
//  Created by born on 16/4/5.
//  Copyright (c) 2016年 ViewHigh. All rights reserved.
//


@class EaseBubbleView;
@protocol IMessageModel;

/********************************************************
 *  App-IM基础业务接口: 将业务相关抽离到框架之外实现.
    将与IM相关业务抽象成接口,具体业务实现此方法
 ********************************************************/
@protocol IAppImBusiness <NSObject>


/**
 * 初始化Im
 */
-(void)initImWithApp:(UIApplication *)application Options:(NSDictionary *)launchOptions;

/**
 * @brief IM注册
 *  @param userAccount 账号
 *  @param password 密码
 */
-(void)imRegister:(NSString*)userAccount password:(NSString*)password;

/**
 * @brief IM登录
 *  @param userAccount 账号
 *  @param password 密码
 *  @param userName 昵称
 */
-(void)imLogin:(NSString*)userAccount password:(NSString*)password userName:(NSString*)userName;

/**
 * @brief IM注销
 * @return N/A
 */
- (void)imLogout;

/**
 * @brief IM收到本地通知
 * @param notification 通知
 * @return N/A
 */
- (void)imDidReceiveLocalNotification:(UILocalNotification *)notification;

/**
 * @brief 收到deviceToken
 * @param notification 通知
 * @return N/A
 */
- (void)imApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

////////////////////////////////////////////////
#pragma mark - IM消息接口,将业务相关抽离到框架之外实现
////////////////////////////////////////////////

/**
 * @brief 与服务器约定的业务扩展字段key值
 */
//-(NSString*)getImExtendKey;

/**
 * @brief IM消息扩展时，文本类型的消息扩展到此接口中
 */
//- (EaseBubbleView *)bubbleView:(EaseBubbleView*)bv forMessageModel:(id<IMessageModel>)messageModel;


/**
 *  发送一个路由器消息, 对eventName感兴趣的 UIResponsder 可以对消息进行处理
 *
 *  @param eventName 发生的事件名称
 *  @param userInfo  传递消息时, 携带的数据, 数据传递过程中, 会有新的数据添加
 *
 */
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;



@end



