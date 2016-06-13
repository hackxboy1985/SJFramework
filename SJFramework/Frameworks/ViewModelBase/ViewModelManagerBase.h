//
//  ViewModelManagerBase.h
//  Doctor
//
//  Created by born on 16/4/14.
//  Copyright © 2016年 Hkzr All rights reserved.
//

@protocol LogicToUICallback;

/********************************************************
 *  统一模块管理协议，每个ViewModel要实现此协议，用于统一管理
 ********************************************************/
@protocol IViewModelManager <NSObject>

/**
 * @brief 应用进入后台
 */
-(void)didEnterBackground;

/**
 * @brief 应用进入前台
 */
-(void)didEnterForeground;

/**
 * @brief 登录成功
 */
-(void)loginSuccessful;

/**
 * @brief 登出成功
 */
-(void)logout;

/**
 * @brief 反注册UI监听对象
 * @param uiproxy 监听对象
 */
-(void)unregisterUIListener:(id<LogicToUICallback>)uiproxy;
@end



/********************************************************
 *  模块管理类基类
 ********************************************************/
@interface ViewModelManagerBase : NSObject<IViewModelManager>


/**
 *  @brief 注册模块
 *  @param viewModelClass 模块类名
 *  @param modelName 模块名
 */
-(void)registerViewModel:(NSString*)viewModelClass withName:(NSString*)modelName;

/**
 *  @brief 获得模块
 *  @param modelName 模块名
 *  @return 返回模块
 */
-(id)obtainViewModelWithName:(NSString*)modelName;

/**
 * @brief 反注册UI监听对象
 * @param uiproxy 监听对象
 */
-(void)unregisterUIListener:(id<LogicToUICallback>)uiproxy;
@end
