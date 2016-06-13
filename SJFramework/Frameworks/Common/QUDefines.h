//
//  QUDefines.h
//
//  Created by born on 14-1-10.
//  Copyright (c) 2014年 ZR. All rights reserved.
//

////////////////////////////////////////////////////////
#pragma mark 预编译宏,此头文件要加到pch中.
#define SHARE_SDK //打开将开启share sdk  分享
#define WX_SDK  //打开将启用wx支付
#define ALI_ADK  //打开将启用ali支付
#define UMENG_SDK //打开友盟
#define JPHSN_SDK  //打开将启用jpush
////////////////////////////////////////////////////////


#pragma mark - 屏幕尺寸
//设备全屏尺寸
#define FullScreenSize        [UIScreen mainScreen].bounds.size
//设备全屏宽度
#define FullScreenWidth       [UIScreen mainScreen].bounds.size.width
//设备全屏高度
#define FullScreenHight       [UIScreen mainScreen].bounds.size.height
//应用程序高度
#define AppFrameHeight        [UIScreen mainScreen].applicationFrame.size.height

//Vc可操作的高度
#define ViewControllHight       [UIScreen mainScreen].bounds.size.height - 64


#pragma mark - 颜色转换
//十进制颜色转换
#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//十六进制颜色转换（0xFFFFFF）
#define HEXRGBCOLOR(hex)        [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

//#define KMainColor_Orange            RGBCOLOR(245, 64, 21)
//#define KMainColor_lightGrayColor    RGBCOLOR(214, 214, 214)
//#define KMainColor_TableViewSection    RGBCOLOR(197, 197, 197)
#define KMainColor_Orange            RGBCOLOR(245, 64, 21)
#define KMainColor_lightGrayColor    RGBCOLOR(237, 237, 237)
#define KMainColor_TableViewSection    RGBCOLOR(88, 88, 88)
#define KMainColor_darkGrayColor     RGBCOLOR(88, 88, 88)
#define KMainTextColor_GrayColor    RGBCOLOR(159, 159, 159)
#define KMainColor_ViewBackgroundColor     RGBCOLOR(230, 230, 230)


#pragma mark - 适配
#define  SYSTEM_VERSION  [[[UIDevice currentDevice] systemVersion] floatValue]

#define  IOS7_Later      ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0)
#define  IOS8_Later      ([[[UIDevice currentDevice] systemVersion]floatValue] >= 8.0)
#define  IOS9_Later      ([[[UIDevice currentDevice] systemVersion]floatValue] >= 9.0)

#define isIPad (iPad768 || iPad1536)

#define iPad768 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(768, 1024), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPad1536 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1536, 2048), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)


#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#ifdef HX_SDK

#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"

#define CHATVIEWBACKGROUNDCOLOR [UIColor colorWithRed:0.936 green:0.932 blue:0.907 alpha:1]

#endif



//tabBae高
#define TABBARVIEW_HEIGHT 49

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//适用于16进制直接6位颜色
#define UICOLORFROMRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define ScreenWidthSacle [UIScreen mainScreen].bounds.size.width/375
#define ScreenHeightSacle [UIScreen mainScreen].bounds.size.height/667
//#define BACKVIEWCOROR  RGBA(240, 240, 240, 1.0)
#define NAV_COLOR  RGBCOLOR(34, 204, 197) // 导航栏颜色

#define BACKVIEW_COROR  RGBCOLOR(239, 240, 241) // 背景色

#define SECTION_COLOR RGBACOLOR(239, 240, 241, 1) //section颜色(header或footer) 首页、患者、我的等等

//system:0.783922 0.780392 0.8 1  weixin:217,217,217

#define SEPARATOR_COLOR RGB(229, 229, 229) // 分隔线颜色, 首页、患者、我的等等

//#define BREAKFAST_APP_DELEGATE ((BreakFastAppDelegate *)[UIApplication sharedApplication].delegate)

#define PLUS_SUB_BUT_WIDTH (32*Hproportion) // 加减按钮宽高



#pragma mark - 通知命名常量
static NSString *const kNotificationXX = @"kNotificationXX";


#pragma mark - 常用与通用字符串
static NSString *const kStringNetError = @"数据加载失败，请检查您的手机是否连网";
static NSString *const kStringGetDataError  =   @"数据获取失败";
static NSString *const kStringLoading = @"加载中...";



