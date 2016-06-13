//
//  AppDelegateBase.m
//  
//
//  Created by born on 16/4/5.
//
//

#import "AppDelegateBase.h"
#import "AppDelegateExten.h"
#import "AppDelegate+pay.h"
#import "Log.h"

int kLogShowBusinessReq = 1;/**< 打印业务请求log*/
int kLogShowTotalReq = 0;/**< 打印完整请求log*/

@interface AppDelegateBase()<UIScrollViewDelegate>
{
    //基础业务接口
    id<AppBusinessApi> _appBussiness;
    
    
    //模块管理器,当登录成功后/注销成功/进入前台/进入后台，会调用模块管理器的方法
    //其实现方法会遍历每个模块，调用相应的方法
    id<IViewModelManager> _appViewModelManager;

    //引导页使用
    UIScrollView * _introduceView;
    NSArray* _flashImageAry;//引导页文件名数组
    
    

    
}
@property (nonatomic,assign)BOOL isshow;

@end

AppDelegateBase* s_singleton;

@implementation AppDelegateBase


/**
 * @brief 初始化框架
 * @param vmManagerClass ViewModelManager的类名
 */
- (void)initFrameworkWithVmManagerClass:(NSString*)vmManagerClass{
    DebugLog(">>[框架]初始化...");
    s_singleton = self;
    
    [NSClassFromString(vmManagerClass) initialize];
    if(_appViewModelManager == nil){
        DebugLog(">>[框架]初始化模块管理器失败，请检查参数:%s.", [vmManagerClass UTF8String]);
    }
}

/**
 * @brief 设置引导页图片数组
 * @param ary 图片名数组
 */
-(void)setFlashImageArray:(NSArray*)ary{
    _flashImageAry = ary;
}

/**
 * @brief 设置微信相关参数
 * @param appkey appkey
 */
-(void)setWeixinParamWithName:(NSString*)name appkey:(NSString*)appId secret:(NSString*)secret mchId:(NSString*)mchId partnerId:(NSString*)partnerId notifyUrl:(NSString*)notifyUrl{
    //微信参数
    _wxAppName = name;
    _wxAppkey = appId;//app唯一标识
    _wxAppSecret = secret;//app secret
    
    //以下3个参数主要用于支付
    _wxMchId = mchId;//商户号
    _wxPartnerID = partnerId;//商户API密钥,支付使用，在微信商户平台网站上设置的API密钥
    _wxPayNotifyUr = notifyUrl;//支付结果回调页面
}


-(void)setQQParamWithAppkey:(NSString*)appkey secret:(NSString*)secret{
    _qqAppkey = appkey;
    _qqAppSecret = secret;
}


-(void)setAliPayParamWithPartner:(NSString*)partner seller:(NSString*)seller privateKey:(NSString*)privateKey notifyUrl:(NSString*)notifyUrl appScheme:(NSString*)appScheme{
    _aliPartner = partner;//合作伙伴id
    _aliSeller = seller;//商户id
    _aliPrivateKey = privateKey;//支付私钥 pkcs8格式
    _aliNotifyUrl = notifyUrl;//支付结果回调页面
    _aliScheme = appScheme;
}

/**
 * @brief 设置Share sdk 初始化使用的key
 */
-(void)setShareSdkKey:(NSString*)key{
    _shareSdkKey = key;
}

/**
 * @brief 设置友盟初始化使用的key
 * @param key key
 */
-(void)setUMengKey:(NSString*)key{
    _umengKey = key;
}



/**
 * @brief 设置是否显示业务log(未加密）
 */
-(void)setShowBusinessLog:(BOOL)open{
    kLogShowBusinessReq = open;
}

/**
 * @brief 设置是否显示完整log(关键数据可能加密，根据不同项目而定）
 */
-(void)setShowTotalLog:(BOOL)open{
    kLogShowTotalReq = open;
}


+(AppDelegateBase*)getAppDelegateBase{
    return s_singleton;
}


/////////////////////////////////////////////////////////////////////////////
#pragma mark - 业务类
/////////////////////////////////////////////////////////////////////////////

/**
 * @brief 获得基础业务接口
 * @return AppBusinessApi业务对象
 */
-(id<AppBusinessApi>)getBusinessApi{
    return _appBussiness;
}

/**
 * @brief 注册基础业务代理对象
 * @param inter 实现了AppBusinessApi接口的对象
 */
-(void)registerBusinessApi:(id<AppBusinessApi>)inter
{
    _appBussiness = inter;
}



////////////////////////////////////////////////
#pragma mark - IViewModelManager 模块管理代理
////////////////////////////////////////////////

/**
 * @brief 注册模块管理代理对象
 */
-(void)registerViewModelManager:(id<IViewModelManager>)inter{
    
    _appViewModelManager = inter;
}

/**
 * @brief 获得模块管理代理对象
 */
-(id<IViewModelManager>)getViewModelManager{
    return _appViewModelManager;
}


/////////////////////////////////////////////////////////////////////////////
#pragma mark - Style
/////////////////////////////////////////////////////////////////////////////


- (void)setTabBarStyle
{
    if (IOS7_Later) {
        
        //设置tabbarItem文字颜色和位置
        [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:34/255.0 green:204.0/255.0 blue:197.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                          nil] forState:UIControlStateSelected];
        
        
        [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                          [UIFont systemFontOfSize:12.0], NSFontAttributeName,
                                                          nil] forState:UIControlStateNormal];
        
        [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    }
}

- (void)setNavigationBarStyle
{
    //电池栏背景色，与底
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //设置电池栏前景色 白字UIBarStyleBlack 或 黑字UIBarStyleDefault
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    //设置背景颜色或背景图片
    if (IOS7_Later) {
//        [[UINavigationBar appearance] setBarTintColor:HEXRGBCOLOR(0x21ccc5)];
        [[UINavigationBar appearance] setBarTintColor:RGBACOLOR(5,197,189,0.9)];
//        [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];//白色
    }
    
    // 设置标题样式
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:20.0], NSFontAttributeName, nil]];
    
    //设置返回按钮颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    // 去掉返回键带的title
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}


/////////////////////////////////////////////////////////////////////////////
#pragma mark - 生命周期
/////////////////////////////////////////////////////////////////////////////

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];//去处需要的路径
    NSLog(@"Path:%@",libraryDirectory);
    
    if(s_singleton==NULL)
        DebugLog(">>[框架]未初始化框架，请先调用initFramework:方法.");
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    //初始化网络监测
    [self initNetworkMonitor];
    
    //tabbar
    [self setTabBarStyle];
    
    //navigationBar
    [self setNavigationBarStyle];
    
    //jpush
    [self registerJPushWithOptions:launchOptions withApp:application];

    //分享
    [self initializePlat];
    
    //友盟统计
    [self initUmengTrack];
    
    //初始化uuid
    [self initUUID];

    //引导页
    [self onlyOneAddIntroduceView];
    
    DebugLog(">>[框架]初始化完成. 通知业务模块，应用启动...");

    //通知具体业务，启动
    [[self getBusinessApi] appLaunching];

    return YES;
}


- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification
{
#ifdef JPHSN_SDK
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
#endif
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
#ifdef JPHSN_SDK
    // Required
    [APService registerDeviceToken:deviceToken];
#endif

}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"注册push token error -- %@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
#ifdef JPHSN_SDK
    // Required
    [APService handleRemoteNotification:userInfo];
    [self handlePush:userInfo identifier:nil];
#endif
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
#ifdef JPHSN_SDK
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    
    [self handlePush:userInfo identifier:nil];
#endif
    
    completionHandler(UIBackgroundFetchResultNewData);

}


- (BOOL)application:(UIApplication *)application handleOpenURL: (NSURL *)url
{
    return [self applicationSharePay:application handleOpenURL:url];
}

- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication annotation: (id)annotation
{
    
    return [self applicationSharePay:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [_appViewModelManager didEnterBackground];

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [_appViewModelManager didEnterForeground];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



/////////////////////////////////////////////////////////////////////////////
#pragma mark - ShowMainView
/////////////////////////////////////////////////////////////////////////////

-(void)showView2Windows:(UIViewController*)vc{
    //self.tabbarViewController = tabbar;
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
}


/////////////////////////////////////////////////////////////////////////////
#pragma mark - 引导页相关代码
/////////////////////////////////////////////////////////////////////////////


#define SCREEN_FRAME [UIScreen mainScreen ].bounds
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

/**
 *  引导页
 */
#pragma mark - 引导页只执行一次

- (void)onlyOneAddIntroduceView
{
    if(_flashImageAry){
        _isshow = NO;
        NSString *key = (NSString *)kCFBundleVersionKey;
        NSString *version = [NSBundle mainBundle].infoDictionary[key];
        NSString *saveVersion = [[NSUserDefaults  standardUserDefaults] objectForKey:key];
        if(![version  isEqualToString:saveVersion])
        {
            _isshow = YES;
            [self addIntroduceView];
            [[NSUserDefaults  standardUserDefaults] setObject:version forKey:key];
            [[NSUserDefaults  standardUserDefaults] synchronize];
        }
    }else{
        NSLog(@">>未设置引导页图片.");
    }
}


#pragma mark - 添加引导页效果

- (void)addIntroduceView
{
    _introduceView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _introduceView.showsHorizontalScrollIndicator = NO;
    _introduceView.pagingEnabled = YES;
    _introduceView.bounces = NO;
    _introduceView.delegate = self;
    
    for(int i = 0; i < _flashImageAry.count; i++){
        //page4
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight)];
        imageView.image = [UIImage imageNamed:_flashImageAry[i]];
        imageView.userInteractionEnabled = YES;
        if(imageView.image)
            [_introduceView addSubview:imageView];
        
        if( i == _flashImageAry.count - 1){
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
            [tapGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
            [tapGestureRecognizer setNumberOfTapsRequired:1];
            [tapGestureRecognizer setNumberOfTouchesRequired:1];
            [imageView addGestureRecognizer:tapGestureRecognizer];
        }
    }
    
    _introduceView.contentSize = CGSizeMake(kScreenWidth * _introduceView.subviews.count, 0);
    [self.window addSubview:_introduceView];
}

- (void)gestureRecognizerHandle:(UITapGestureRecognizer *)gesture
{
    __weak UIImageView* fIv = (UIImageView*)gesture.view;
    __weak UIView* iV = _introduceView;
    [UIView animateWithDuration:1.0 animations:^{
        
        fIv.alpha = 0.0;
        fIv.transform = CGAffineTransformScale(fIv.transform, 1, 1);
        fIv.frame = CGRectMake(2*kScreenWidth-kScreenWidth/2, -kScreenHeight, kScreenWidth*4, kScreenHeight*4);
        
    } completion:^(BOOL finished) {
        
        [iV removeFromSuperview];
        
    }];
    
    _isshow = NO;
}

@end