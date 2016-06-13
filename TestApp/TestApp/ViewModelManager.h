//
//  ViewModelManager.h
//  Doctor
//
//  Created by born on 16/4/14.
//  Copyright © 2016年 ViewHigh. All rights reserved.
//

#import "ViewModelManagerBase.h"


@class HomeViewModel;
@class LoginViewModel;
@class RegisterViewModel;


/********************************************************
 *  ViewModel模块管理器,单例提供获得各个模块的接口
 ********************************************************/
@interface ViewModelManager : ViewModelManagerBase

/**
 *	@brief	获取逻辑管理对象单例
 *
 *	@return	逻辑管理对象单例
 */
+(ViewModelManager *)getSingleton;


/**
 *  @brief 获得用户登录处理模块
 */
-(LoginViewModel *)getLoginViewModel;

/**
 *  @brief 获得用户注册处理模块
 */
-(RegisterViewModel *)getRegisterViewModel;

/**
 * @brief   获得首页模块
 */
-(HomeViewModel *)getHomeViewModel;

@end


