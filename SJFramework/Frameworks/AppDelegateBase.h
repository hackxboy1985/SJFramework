//
//  AppDelegateBase.h
//  User
//
//  Created by Born on 15/8/1.
//  Copyright (c) 2015年 Hkzr All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppBusinessApi.h"
#import "IAppImBusiness.h"
#import "ViewModelManagerBase.h"
#import "Log.h"

/********************************************************
 *  AppDelegateBase抽象类+实现基础业务接口
 ********************************************************/

@interface AppDelegateBase : UIResponder <UIApplicationDelegate>
{
    //微信参数
    NSString * _wxAppName;//app名称,微信初始化时使用
    NSString * _wxAppkey;//app唯一标识
    NSString * _wxAppSecret;//app secret
    //以下3个参数主要用于支付
    NSString * _wxMchId;//商户号
    NSString * _wxPartnerID;//商户API密钥,支付使用，在微信商户平台网站上设置的API密钥
    NSString * _wxPayNotifyUr;//支付结果回调页面
    
    
    
    //QQ标识
    NSString * _qqAppkey;//app唯一标识
    NSString * _qqAppSecret;//app secret
    
    
    //支付宝
    NSString * _aliPartner;//合作伙伴id
    NSString * _aliSeller;//商户id
    NSString * _aliPrivateKey;//支付私钥 pkcs8格式
    NSString * _aliNotifyUrl;//支付结果回调页面
    NSString * _aliScheme;//应用注册scheme,在AlixPayDemo-Info.plist定义URL types, 要与plist中一致，用于支付宝完成后回调回本应用

    
    //ShareSdk
    NSString * _shareSdkKey;
    
    //友盟
    NSString * _umengKey;
}

@property (strong, nonatomic) UIWindow *window;

/**
 * @brief 初始化框架
 * @param vmManagerClass ViewModelManager的类名
 */
- (void)initFrameworkWithVmManagerClass:(NSString*)vmManagerClass;

/**
 * @brief 设置引导页图片数组
 * @param ary 图片名数组
 */
-(void)setFlashImageArray:(NSArray*)ary;

/**
 * @brief 设置微信相关参数
 * @param name app名
 * @param appId appId
 * @param secret secret
 * @param mchId 商户号
 * @param partnerId 商户API密钥
 * @param notifyUrl 支付回调地址
 */
-(void)setWeixinParamWithName:(NSString*)name appkey:(NSString*)appId secret:(NSString*)secret mchId:(NSString*)mchId partnerId:(NSString*)partnerId notifyUrl:(NSString*)notifyUrl;

/**
 * @brief 设置QQ相关参数
 * @param appkey appkey
 * @param secret secret
 */
-(void)setQQParamWithAppkey:(NSString*)appkey secret:(NSString*)secret;

/**
 * @brief 设置支付宝支付相关参数
 * @param partner partner
 * @param seller seller
 * @param privateKey 支付私钥
 * @param notifyUrl 通知回调
 * @param appScheme plist文件中定义，用于支付完成后回调回本应用时匹配用的Scheme
 */
-(void)setAliPayParamWithPartner:(NSString*)partner seller:(NSString*)seller privateKey:(NSString*)privateKey notifyUrl:(NSString*)notifyUrl  appScheme:(NSString*)appScheme;

/**
 * @brief 设置Share sdk 初始化使用的key
 * @param key key
 */
-(void)setShareSdkKey:(NSString*)key;

/**
 * @brief 设置友盟初始化使用的key
 * @param key key
 */
-(void)setUMengKey:(NSString*)key;


/**
 * @brief 设置是否显示业务log(未加密）
 */
-(void)setShowBusinessLog:(BOOL)open;

/**
 * @brief 设置是否显示完整log(关键数据可能加密，根据不同项目而定）
 */
-(void)setShowTotalLog:(BOOL)open;

/**
 * @brief 获得AppDelegateBase实例
 */
+(AppDelegateBase*)getAppDelegateBase;


////////////////////////////////////////////////
#pragma mark - AppBusinessApi 业务基础类
////////////////////////////////////////////////

/**
 * @brief 注册基础业务代理对象
 * @param inter 实现了AppBusinessApi接口的对象
 */
-(void)registerBusinessApi:(id<AppBusinessApi>)inter;


/**
 * @brief 获得基础业务接口
 * @return AppBusinessApi业务对象
 */
-(id<AppBusinessApi>)getBusinessApi;


////////////////////////////////////////////////
#pragma mark - IViewModelManager 模块管理代理
////////////////////////////////////////////////


/**
 * @brief 注册模块管理代理对象
 * @param inter 实现了IViewModelManager接口的对象
 */
-(void)registerViewModelManager:(id<IViewModelManager>)inter;

/**
 * @brief 获得模块管理代理对象
 */
-(id<IViewModelManager>)getViewModelManager;

////////////////////////////////////////////////
#pragma mark - Style
////////////////////////////////////////////////

/**
 * @brief 设置Tabbar风格
 */
- (void)setTabBarStyle;

/**
 * @brief 设置NavBar风格
 */
- (void)setNavigationBarStyle;


////////////////////////////////////////////////
#pragma mark - 将要显示到windows的主界面.
////////////////////////////////////////////////



/**
 * @brief 在Windows显示页面
 * @param   vc 将要显示到windows的主界面.
 */
-(void)showView2Windows:(UIViewController*)vc;

@end











