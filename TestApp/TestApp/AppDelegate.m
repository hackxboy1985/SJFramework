//
//  AppDelegate.m
//  TestApp
//
//  Created by born on 16/6/2.
//  Copyright © 2016年 born. All rights reserved.
//

#import "AppDelegate.h"


#define NOTIFY_IP @"http://112.126.83.5:8066"
//////////////////////////////////////////////////////////////
//微信参数
//////////////////////////////////////////////////////////////

#define WX_APP_ID          @"wxd4441e563bb9129"         //惠APPID

#define WX_APP_SECRET         @"f56762db56b77e4480220bb89e141e"//惠appsecret

//商户号，填写商户对应参数
#define WX_MCH_ID         @"127010750"//惠mch_id

//商户API密钥，填写相应参数
#define WX_PARTNER_ID      @"A9680B1131E4dc319019d6Eba3123"//

//支付结果回调页面
#define WX_NOTIFY_URL      NOTIFY_IP@"/WxPaymentNotify.html" //惠回调

//////////////////////////////////////////////////////////////
//QQ参数
//////////////////////////////////////////////////////////////

#define QQ_SHARE_TEST 0//1、测试，使用乐助理；0､正式,应该改成惠的

#if QQ_SHARE_TEST

#else//应该改成惠的

#define QQ_APP_ID @"110532971"//惠
#define QQ_MOB_APP_Secret @"T07n0wj3BbTou4k"//惠

#endif

//////////////////////////////////////////////////////////////
//支付宝参数
//////////////////////////////////////////////////////////////

NSString *partner = @"20880219781399";//partner.
NSString *seller = @"huibowl@sina.com";//
//pkcs8私钥
NSString *privateKey= @"";


NSString *notify_url = NOTIFY_IP@"/AliPaymentNotify.html"; // 8066


#define UMENG_APPKEY @"5744178b67e58edd3c00326"

@implementation AppDelegate






- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //初始化框架，设置模块管理类
    [self initFrameworkWithVmManagerClass:@"ViewModelManager"];

    //以下大括号中，可根据实际情况配置使用, 另外请参考QUDefines.h头文件中的几个宏定义，注释相关宏，则不会编译相关代码
    {
        //设置微信参数
        [self setWeixinParamWithName:@"惠" appkey:WX_APP_ID secret:WX_APP_SECRET mchId:WX_MCH_ID partnerId:WX_PARTNER_ID notifyUrl:WX_NOTIFY_URL];
        
        //设置支付宝参数
        [self setAliPayParamWithPartner:partner seller:seller privateKey:privateKey notifyUrl:notify_url appScheme:@"huiAli"];
        
        //设置QQ参数
        [self setQQParamWithAppkey:QQ_APP_ID secret:QQ_MOB_APP_Secret];
        
        //设置share sdk
        [self setShareSdkKey:@"8430e2ab8f78"];
        
        //设置友盟key
        [self setUMengKey:UMENG_APPKEY];
        
        //设置业务请求log
        [self setShowBusinessLog:true];
        
        //设置完整业务请求log
        [self setShowTotalLog:true];
    }

    //注册业务类,此框架将会在此业务类的appLaunching方法中处理第1个逻辑
    [self registerBusinessApi:[[NSClassFromString(@"AppBusinessApiImplement") alloc] init]];
    
    [super application:application didFinishLaunchingWithOptions:launchOptions];

    
    
    return YES;
}

@end
