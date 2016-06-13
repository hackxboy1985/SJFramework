
//
//  AppDelegate_Exten.m
//  User
//
//  Created by Born on 15/8/1.
//  Copyright (c) 2015年 Hkzr All rights reserved.
//
#import "AppDelegateExten.h"


//jpush极光推送相关头文件
#ifdef JPHSN_SDK
#import "APService.h"
#endif


//友盟
#ifdef UMENG_SDK
#import "MobClick.h"
#endif

//监听网络类型
#import "FtNetworkDetector.h"


//UUID
#import "SSKeychain.h"
#import "QUCommon.h"

//log
#import "Log.h"

/////////////////////////////////////////////////////////////////////////////
#pragma mark - 登录
/////////////////////////////////////////////////////////////////////////////
@implementation AppDelegateBase(Login)

// 登录成功后调用此方法
- (void)notifyModelLoginSuccessful
{
    DebugLog(">>[框架]登录成功. 执行其它逻辑，通知所有模块登录成功、第三方登录(im/push)...");
    
    //注册极光jpush－alias
//    [self registerAlias];
    
    if([self getViewModelManager]){
        [[self getViewModelManager] loginSuccessful];
    }else{
        DebugLog("模块管理器未注册.通知模块登录成功失败!");
    }
}

//退出当前账号
- (void)notifyModelLogout
{
    DebugLog(">>[框架]注销成功. 执行其它逻辑，通知所有模块登出成功、登出第三方(im/push)...");

//    [self unregisterAlias];
    
    if([self getViewModelManager]){
        [[self getViewModelManager] logout];
    }else{
        DebugLog("模块管理器未注册.通知模块登出失败!");
    }
}

//重新登录
//-(void)relogin
//{
//}



@end



/////////////////////////////////////////////////////////////////////////////
#pragma mark - jpush
/////////////////////////////////////////////////////////////////////////////
@implementation AppDelegateBase(jpush)

- (void)registerJPushWithOptions:(NSDictionary *)launchOptions withApp:(UIApplication*)application
{
//#if !TARGET_IPHONE_SIMULATOR
    
#ifdef JPHSN_SDK
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [self registerCategory];
    }
    else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    
    // Required
    [APService setupWithOption:launchOptions];
#if DEBUG
    [APService setDebugMode];
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpushLoginSuccessful) name:kJPFNetworkDidLoginNotification object:nil];
    
    
    
    
#endif//JPHSN_SDK
    

    
//#endif
    
    //iOS8 注册APNS
//    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
//        [application registerForRemoteNotifications];
//        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
//        UIUserNotificationTypeSound |
//        UIUserNotificationTypeAlert;
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
//        [application registerUserNotificationSettings:settings];
//    }
//    else{
//        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
//        UIRemoteNotificationTypeSound |
//        UIRemoteNotificationTypeAlert;
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
//    }
}


-(void)registerCategory{
    
    //        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
    //                                                       UIUserNotificationTypeSound |
    //                                                       UIUserNotificationTypeAlert)
    //                                           categories:nil];
    
    NSMutableSet *categories = [NSMutableSet set];
    
    
    UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
    action.identifier = @"agree";
    action.title = @"同意";
    action.activationMode = UIUserNotificationActivationModeBackground;
    action.authenticationRequired = NO;
    //YES显示为红色，NO显示为蓝色
    action.destructive = NO;
    
//    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
//    action2.identifier = @"ignore";
//    action2.title = @"忽略";
//    action2.activationMode = UIUserNotificationActivationModeBackground;
//    action2.authenticationRequired = NO;
//    //YES显示为红色，NO显示为蓝色
//    action2.destructive = NO;
    
    
    NSArray *actions = @[ action ];
    
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = @"friendRequest";
    [category setActions:actions forContext:UIUserNotificationActionContextMinimal];
    [categories addObject:category];
    
    
    
#ifdef __IPHONE_9_0
    if(IOS9_Later){
        
        UIMutableUserNotificationAction *replyAction = [[UIMutableUserNotificationAction alloc]init];
        replyAction.title = @"回复";
        replyAction.identifier = @"reply";
        replyAction.activationMode = UIUserNotificationActivationModeBackground;
        replyAction.behavior = UIUserNotificationActionBehaviorTextInput;
        replyAction.destructive = NO;
        replyAction.authenticationRequired = NO;

        UIMutableUserNotificationCategory *categoryReply = [[UIMutableUserNotificationCategory alloc]init];
        categoryReply.identifier = @"reply";
        [categoryReply setActions:@[replyAction] forContext:UIUserNotificationActionContextDefault];
        
        [categories addObject:categoryReply];
    }
    
#endif
    
    //可以添加自定义categories
    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                   UIUserNotificationTypeSound |
                                                   UIUserNotificationTypeAlert)
                                       categories:categories];

}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    NSLog(@"push click:%@,userInfo:%@",identifier,userInfo);
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [self handlePush:dict identifier:identifier];
    completionHandler();
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler{
    NSLog(@"push click:%@,userInfo:%@,responseInfo:%@",identifier,userInfo,responseInfo);
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [dict addEntriesFromDictionary:responseInfo];
    [self handlePush:dict identifier:identifier];
    completionHandler();
}

/////////////////////////////////////////////////////////////////////////////
#pragma mark - jpush业务通用方法
/////////////////////////////////////////////////////////////////////////////

- (void)jpushLoginSuccessful{
    //jpush登录成功后，设置注册id
    [[self getBusinessApi] rcvJpushRegistrationID:[APService registrationID]];

}

//收到消息
- (void)handlePush:(NSDictionary *)userInfo identifier:(NSString*)identifier
{
    [[self getBusinessApi] handleJpush:userInfo identifier:identifier];
}

// 注册alias
- (void)registerAlias
{
    if([[self getBusinessApi] getLoginStatus] == false)
        return;

    NSString *registerAlias = [[self getBusinessApi] getUserAccount];
    if (registerAlias.length > 0)
    {
        NSString* val = [[NSUserDefaults standardUserDefaults] objectForKey:registerAlias];
        if(val != NULL){
            NSLog(@"Have Already Register alias.");
        }else{
            //PICA_INFO("注册alias:%s",[registerAlias UTF8String]);
            
#ifdef JPHSN_SDK
            [APService setAlias:registerAlias
               callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                         object:self];
#endif
        }
    }

}

// 注销alias
- (void)unregisterAlias
{
    NSString *registerAlias = [[self getBusinessApi] getUserAccount];
    if (registerAlias.length > 0){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:registerAlias];
    }

#ifdef JPHSN_SDK
    [APService setAlias:@"0"
       callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                 object:self];
#endif
    
}

// 注册alias回调
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"Jpush Alias rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    
    // 延迟 60 秒来调用 Handler 设置别名
    switch (iResCode) {
        case 6002://超时
        {
            __weak typeof(self)_self = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_self registerAlias];
            });
        }
            break;
            
        case 0:
        {
            //成功后标记，以后该账号不用再注册.
//            NSString * userPath = [HKFileManage getPlistPathByName:@"user.plist"];
//            NSDictionary *userDic = [NSDictionary dictionaryWithContentsOfFile:userPath];
//            NSString *userCode  = [userDic objectForKey:@"UserCode"];
            
//            NSString *userCode = [[self getBusinessApi] getUserName];
//            if (userCode.length > 0)
//            {
//                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:userCode];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            }
        }
            break;
        default:
            break;
    }
    
}

@end




/////////////////////////////////////////////////////////////////////////////
#pragma mark - 友盟
/////////////////////////////////////////////////////////////////////////////
@implementation AppDelegateBase (umeng)

- (void)initUmengTrack {
    
    if(_umengKey){
#ifdef UMENG_SDK
        //#if !TARGET_IPHONE_SIMULATOR
        NSLog(@"UMengTrack init\n");
        //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
#ifdef DEBUG
        [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
#endif
        [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
        //
        [MobClick startWithAppkey:_umengKey reportPolicy:(ReportPolicy) REALTIME channelId:nil];
        
        //#endif
#endif
    }
}


@end


@implementation AppDelegateBase (NetworkType)


- (void)initNetworkMonitor
{
    [FtNetworkDetector startNetDetect];
}


@end



@implementation AppDelegateBase (UUID)

#define UUID_SERVICE @"uuid"
- (void)initUUID{
    
    NSString* bunldId = [NSBundle mainBundle].bundleIdentifier;
    NSString* uuid = [SSKeychain passwordForService:UUID_SERVICE account:bunldId];
    if(uuid==NULL){
        uuid = [QUCommon stringWithUUID];
        BOOL ret = [SSKeychain setPassword:uuid forService:UUID_SERVICE account:bunldId];
        if(ret == false){
            ErrorLog(">>Product UUID Failed!!!\n");
        }
    }
}

-(NSString*)getUUID{
    NSString* bunldId = [NSBundle mainBundle].bundleIdentifier;
    NSString* uuid = [SSKeychain passwordForService:UUID_SERVICE account:bunldId];
    return uuid;
}

@end
