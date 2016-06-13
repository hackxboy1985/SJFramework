//
//  ViewModelBase.h
//  
//
//  Created by born on 16/4/11.
//
//  Copyright (c) 2016年 Hkzr All rights reserved.

#import "ViewModelManagerBase.h"

#define IP @"http://192.168.4.52:8085"


/**
 * @brief 业务回调
 */
typedef void (^BusinessCallback)(bool success, NSString* msg);

/**
 * @brief 请求回调
 */
typedef void (^HttpRequestCB)(NSString*errorTips, NSDictionary*responsDict, BusinessCallback callback);


/******************************************************************************
 * @brief MVVM框架补充-逻辑模块主动通知界面的协议(不需要主动通知界面刷新，可不用)
 * 使用场景:
 * 1、当逻辑模块数据发生改变时，通过此协议回调至UI层刷新数据
 * 2、当登录成功后，有些模块可以在loginSuccessful方法中请求获取最新数据，数据回来后，通知相关界面刷新
 * 
 * 注意:
 * 1)、以命令标识cmd为匹配，每个模块自定义，可携带参数，但建议不携带，而是回调后，界面主动获取.
 * 2)、避免模块的cmd重复，可能会导致1个vc监听多个模块的相同的cmd，这样逻辑会出错
 *
 * 使用步骤:
 * 1)ViewController实现此协议，并调用模块注册方法registerUIListener注册监听
 * 2)模块要通知界面时，调用notifyUIListener方法
 ******************************************************************************/
@protocol LogicToUICallback <NSObject>
/**
 * @brief 逻辑层通知UI层回调方法
 * @param cmd 命令标识,各模块自定义
 * @param param 参数,可为null
 */
-(void)notifyUICallback:(int)cmd paramater:(id)param;
@end











/********************************************************
 * @brief MVVM框架-ViewModel基类
 * 1、封装HTTP请求的报文格式
 * 2、约束子类，实现IViewModelBase接口协议.
 ********************************************************/
@interface ViewModelBase : NSObject<IViewModelManager>


/**
 *  @brief 数据请求
 *
 *  @param uri          请求地址
 *  @param senddic      发送的数据字典
 *  @param busiBlock    业务回调,统一存储
 *  @param callback     请求回调
 *  @return N/A
 */
-(void)HttpRequestForUri:(NSString *)uri  andSendDic:(NSDictionary *)senddic businessBlock:(BusinessCallback)busiBlock callback:(HttpRequestCB)callback;

/**
 *  @brief 上传图片
 *
 *  @param uri        请求地址
 *  @param senddic    发送的字典
 *  @param imageArray 图片数组
 *  @param busiBlock  业务回调,统一存储
 *  @param callback   请求回调
 */
-(void)uploadImageForUri:(NSString *)uri andSendDic:(NSDictionary *)senddic imageArray:(NSArray *)imageArray businessBlock:(BusinessCallback)busiBlock callback:(HttpRequestCB)callback;


#pragma mark - 配合LogicToUICallback，用于通知UI层


/**
 * @brief 注册UI监听对象
 * @param uiproxy 监听对象
 */
-(void)registerUIListener:(id<LogicToUICallback>)uiproxy;

/**
 * @brief 反注册UI监听对象
 * @param uiproxy 监听对象
 */
-(void)unregisterUIListener:(id<LogicToUICallback>)uiproxy;

/**
 * @brief 通知UI层回调
 * @param cmd 命令标识
 * @param param 参数
 */
-(void)notifyUIListener:(int)cmd paramater:(id)param;
@end
