//
//  AppBusinessApiImplement.m
//  
//
//  Created by born on 16/4/5.
//
//

#import "AppBusinessApiImplement.h"
#import "BaseViewController.h"
#import "BaseNavigationViewController.h"
#import "AppDelegateExten.h"
#import "ViewModelManager.h"
#import "LoginViewModel.h"
#import "UserAccount.h"
#import "SSKeychain.h"

#import "MainViewController.h"

@interface AppBusinessApiImplement()
{
    BOOL _login;            /**< 是否登录成功*/
    BOOL _imLogin;          /**< Im是否登录成功*/
    BOOL _isAutoLogin;      /**< 是否自动登录*/
    BOOL _isMainViewShow;   /**< 是否显示主界面*/
    
    
    NSString* _RegistrationID;/**< jpush极光id */
}
@end

#define kUserAccount @"UserAccount"
#define kUserName @"UserName"


@implementation AppBusinessApiImplement

/********************************************************
 *  app基础业务接口实现
 ********************************************************/

//app启动
-(void)appLaunching
{
    //自动登录
    NSString* UserNum = [self getUserAccount];
    NSString* UserPWD = [self getUserPwd];
    
#if DEBUG //测试
    if(UserNum == nil)
        UserNum = @"aa";
    if(UserPWD.length == 0)
        UserPWD = @"bb";
#endif

    if(UserNum.length && UserPWD.length)
    {
        _isAutoLogin = true;
        NSLog(@">>自动登录，应该检测是否在其它地方登录\n\n");
        
        [self appLoginSuccessful];

    }else{
        _isAutoLogin = false;
        NSLog(@">>无可用账号，非登录状态\n\n");
        [self showLoginViewController];
    }
}


// 登录成功后调用此方法
- (void)appLoginSuccessful
{
    if(_isAutoLogin == false){
        NSLog(@"App 登录成功\n");
    }
    
    //设置登录状态
    [self setLoginStatus:true];

    //检测上传jpush唯一标识
    [self uploadJpushRegistrationId];
    
    //通知所有模块登录成功
    [[AppDelegateBase getAppDelegateBase] notifyModelLoginSuccessful];
    
    //自动登录逻辑
    if(_isAutoLogin){
        
        [self showMainViewController];
    }
}

//退出当前账号
- (void)appLogout
{
    //设置业务当前登录状态为false
    [self setLoginStatus:false];
    
    [self unbindRegistrationId];
    
    [self resetUserPwd];
    
    //通知所有模块注销
    [[AppDelegateBase getAppDelegateBase] notifyModelLogout];
    
    [self showLoginViewController];
}

//重新登录
-(void)appRelogin
{
}



/**
 * @brief 设置登录状态
 * @param isLogin 登录状态
 * @return N/A
 */
-(void)setLoginStatus:(BOOL)isLogin{
    
    _login = isLogin;
}

/**
 * @breif 获得登录状态
 * @return bool 登录状态 true/false
 */
-(BOOL)getLoginStatus{
    
    return _login;
}


/**
 * @brief 获得登户名（用于第三方登录时使用，如：分享、环信等)
 * @return NSString* 名称(通常为姓名或昵称)
 */
-(NSString*)getUserName{
    
    NSUserDefaults * userDefaulte = [NSUserDefaults standardUserDefaults];
    NSString* UserName = [userDefaulte objectForKey:kUserName];
    
    return [UserName length]>0 ? UserName: @"";
}


/**
 * @brief 获得登户账号
 * @return NSString* 登录名(通常为手机号)
 */
-(NSString*)getUserAccount{
    
    return [UserAccount getAccount].userName;
}

/**
 * @brief 获得密码
 * @return NSString* 密码(通常与密码保持一致，也可不一致)
 */
-(NSString*)getUserPwd{

    NSString* UserPWD = [UserAccount getUserPWDWithuserName:[self getUserAccount]];
    
    return [UserPWD length]>0 ? UserPWD: @"";
}


/**
 * @brief 获得登户账号（用于第三方登录时使用，如：分享、环信等)
 * @return NSString* 登录名(通常为手机号)
 */
-(NSString*)getImAccount{
    
    if([UserAccount getAccount].userId == NULL)
        return @"0000";
    
    return [UserAccount getAccount].userId;
}

/**
 * @brief 获得密码（用于第三方登录时使用，如：分享、环信等)
 * @return NSString* 密码(通常与密码保持一致，也可不一致)
 */
-(NSString*)getImPwd{
    return @"123456";
}


/**
 * @brief 存储账号密码
 * @param account 账号
 * @param pwd 密码
 */
-(void)saveUserAccount:(NSString*)account pwd:(NSString*)pwd{
    
    if(pwd.length == 0 || account.length == 0){
        ErrorLog("账号存储异常! account:%s, pwd:%s",[account UTF8String],[pwd UTF8String]);
        return;
    }
    
    NSUserDefaults * userDefaulte = [NSUserDefaults standardUserDefaults];
    [userDefaulte setObject:account forKey:kUserAccount];
    BOOL ret = [userDefaulte synchronize];
    if(ret == false){
        ErrorLog("账号存储失败! account:%s",[account UTF8String]);
    }

    //存储密钥到keychain.
    [UserAccount saveUserPWDWithPWD:pwd userName:account];
}

/**
 * @brief 重置账号密码，删除密码
 * @param account 账号
 * @param pwd 密码
 */
-(void)resetUserPwd{
    
    NSString* bunldId = [NSBundle mainBundle].bundleIdentifier;
    [SSKeychain deletePasswordForService:bunldId account:[self getUserAccount]];
}

////////////////////////////////////////////////
#pragma mark - jpush消息回调 根据业务定制
////////////////////////////////////////////////

#define JPUSH_TYPE_ADD_FRIEND          1//定制添加好友
#define JPUSH_TYPE_ORDERCONTRIM      15//定制

/**
 * @brief 重置registrationId
 */
-(void)unbindRegistrationId{
    _RegistrationID = @"";
    //上传无效 jpush register
    [[[ViewModelManager getSingleton] getLoginViewModel] bindPushRegistration:_RegistrationID];
}

/**
 * @brief 上传获得的推送使用的唯一标识registrationId,服务器记录每个用户唯一对应此标识
 *        userId : registrationId 唯一对应，同1个registrationId不能出现在服务器数据库的2个userId中
 *        服务器根据此registrationId进行推送(适用于极光推送)
 *        注意:每次启动时都应该调用(从后台进入前台，不算启动)
 */
-(void)uploadJpushRegistrationId{
    
    //必须登录成功能够获得userId以及registrationId才能上传registrationId
    if([self getLoginStatus] && _RegistrationID.length){
        NSLog(@"jpush RegistrationID:%@",_RegistrationID);
        //上传jpush register
        [[[ViewModelManager getSingleton] getLoginViewModel] bindPushRegistration:_RegistrationID];
    }
}

/**
 * @brief 收到jpush注册id
 */
-(void)rcvJpushRegistrationID:(NSString*)RegistrationID{
    
    _RegistrationID = RegistrationID;
    
    [self uploadJpushRegistrationId];
}

-(void)handleJpush:(NSDictionary*)userInfo identifier:(NSString*)identifier{
    NSLog(@"rcv push:%@",userInfo);
    
    //如果identifier为nil，则为收到push，否则为按钮事件
    if(identifier == nil){
        
        int type = [[userInfo objectForKey:@"cmdType"] intValue];
        switch (type) {
                
            case JPUSH_TYPE_ORDERCONTRIM:
            {
                //重新拉取订单列表
                //[self showMainViewController];
            }
                break;
            case JPUSH_TYPE_ADD_FRIEND: //添加好友
            {
                //[[NSNotificationCenter defaultCenter] postNotificationName:PUSH_ADD_FRIEND object:userInfo];
            }
                break;
                
            default:
                break;
        }
    }else {
        
        //push上的按钮事件
        NSString* functionIdentifier = [[userInfo objectForKey:@"aps"] objectForKey:@"category"];

//        //添加好友请求
//        if([functionIdentifier isEqualToString:@"friendRequest"]){
//            NSString* uid = [userInfo objectForKey:@"friendUid"];
//            [[[ViewModelManager getSingleton] getGroupViewModel] updateStatusWithBlock:^(bool success, NSString *msg) {
//                NSLog(@"同意完成");
//            } Withid:uid];
//        }
//        else if([functionIdentifier isEqualToString:@"reply"]){
//            
//            if(IOS9_Later){
        
//                UIApplication*  application = [UIApplication sharedApplication];
//                
//                __block UIBackgroundTaskIdentifier bgTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^{
//                    
//                    NSLog(@"Starting background task with %f seconds remaining", application.backgroundTimeRemaining);
//                    
//                    if (bgTaskIdentifier != UIBackgroundTaskInvalid)
//                    {
//                        [application endBackgroundTask:bgTaskIdentifier];
//                        bgTaskIdentifier = UIBackgroundTaskInvalid;
//                    }
//                }];
        
                
//                NSString * uid = [userInfo objectForKey:@"friendUid"];
//                NSString * response = userInfo[UIUserNotificationActionResponseTypedTextKey];
//                NSString * textString = [response stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//                if (textString.length == 0) {
////                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"不能发送空白消息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
////                    [alert show];
//                    return;
//                }
//            }
//        }
        
    }
    
}




/////////////////////////////////////////////////////////////////////////////
#pragma mark - Guide & Main VC
/////////////////////////////////////////////////////////////////////////////

- (void)showGuideViewController_hx
{
}

- (void)showMainViewController
{
    if(_isMainViewShow)return;
    _isMainViewShow = true;
    
    //未选中的图标
    NSMutableArray *aunSelectedImageArray = [[NSMutableArray alloc] initWithObjects:
                                             [UIImage  imageNamed:@"tabbar_icon_1"],
                                             [UIImage imageNamed:@"tabbar_icon_1"],
                                             [UIImage imageNamed:@"tabbar_icon_1"],
                                             [UIImage imageNamed:@"tabbar_icon_4"], nil];
    
    //选中的图片
    NSMutableArray *aselectedImageArray = [[NSMutableArray alloc] initWithObjects:
                                           [UIImage imageNamed:@"tabbar_icon_1_press"],
                                           [UIImage imageNamed:@"tabbar_icon_1_press"],
                                           [UIImage imageNamed:@"tabbar_icon_1_press"],
                                           [UIImage imageNamed:@"tabbar_icon_4_press"], nil];
    
    MainViewController* main = [[MainViewController alloc] init];
    [main initAllNaviController:@[@"HomeViewController",
                                  @"HomeViewController",
                                  @"HomeViewController",
                                  @"HomeViewController"]
                     titleArray:@[@"首页",@"首页",@"工作",@"我的"]
             unSelectedImgArray:aunSelectedImageArray
               selectedImgArray:aselectedImageArray];
    
    [[AppDelegateBase getAppDelegateBase] showView2Windows:main];
}

/**
 *  显示登录界面
 */
-(void)showLoginViewController
{
    NSLog(@">>进入登录页.");
    
    NSString* loginVCClass = @"LoginAndRegisterViewController";
    BaseViewController* loginVc = [[NSClassFromString(loginVCClass) alloc] init];
    
    BaseNavigationViewController *loginNav = [[BaseNavigationViewController alloc] initWithRootViewController:loginVc];
    [[AppDelegateBase getAppDelegateBase] showView2Windows:loginNav];
    
    _isMainViewShow = false;
}






@end



