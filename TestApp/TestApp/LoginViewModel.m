//
//  LoginViewModel.m
//  Doctor
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 ViewHigh. All rights reserved.
//

#import "LoginViewModel.h"
#import "AppDelegateExten.h"
#import "UserAccount.h"


#define userLogin IP@"/api/v1/user/login"
#define bindPushUser IP@"/api/v1/upush/bindPushUser"
#define versionShield IP@"/api/v1/upush/versionShield"

@implementation LoginViewModel
{
    BusinessCallback _block;
}

-(id)init
{
    if(self = [super init]){

    }
    return self;
}

-(void)loginSuccessful{
    
    [self versionAndShield];
    
    self.shield = [ShieldVersionDto load];
}

-(void)imLoginResult:(NSNotification*)note{
    //block 回调
    NSNumber * retVal = note.object;
    if(retVal.boolValue && _block)
        _block(true,@"");
    else if (_block)
        _block(false,@"登录失败");
    
    _block = nil;
}

-(void)loginWithBlock:(BusinessCallback)block withUser:(NSString*)user withPwd:(NSString*)pwd{
    
    _block = [block copy];
  
    NSDictionary* dict = nil;
    if(user.length && pwd.length)
        dict = @{@"userName":user,@"password":pwd,@"accountType":@1};
    else
        dict = @{@"userName":@"18866708700",@"password":@"www1234",@"accountType":@1};
    
    [super HttpRequestForUri:userLogin andSendDic:dict businessBlock:block callback:^(NSString *errorTips, NSDictionary *responsDict, BusinessCallback callback) {
        
        if(responsDict){
            
            NSLog(@"登陆--->%@",responsDict);
            
            UserAccount *userAccount = [UserAccount mj_objectWithKeyValues:responsDict];
            
            //归档
            [UserAccount saveAccount:userAccount];

            //存储密码
            [UserAccount  saveUserPWDWithPWD:pwd userName:user];
            
            //调用登录成功方法
            if (userAccount.authStatus == 1) {
                //已经通过认证的用户--直接进入首页,并通知逻辑登录成功
                [[[AppDelegateBase getAppDelegateBase] getBusinessApi] appLoginSuccessful];
            }
            else{
                //调用登录成功方法
                if(block)
                    block(true,@"");
                
                //模拟账号未审核通过时，也认为登录成功，用于方便前期开发阶段的测试
                [[[AppDelegateBase getAppDelegateBase] getBusinessApi] appLoginSuccessful];
            }
            
        }else{
            
#if TARGET_IPHONE_SIMULATOR
            //此处用于测试
            [[[AppDelegateBase getAppDelegateBase] getBusinessApi] appLoginSuccessful];
#endif
            //block 回调
            if(block)
                block(false,errorTips);
        }
    }];
}


/**
 *  @brief 上传jpush注册标识
 *
 *  @param registrationId  jpush推送的注册标识
 */
-(void)bindPushRegistration:(NSString*)registrationId/* WithBlock:(BusinessCallback)block */
{
    UserAccount *userAccount = [UserAccount getAccount];

    NSDictionary* dict = @{@"uid":userAccount.userId,@"sid":userAccount.sid,@"userId":userAccount.userId};
    if(registrationId!=nil)
        dict = @{@"uid":userAccount.userId,@"sid":userAccount.sid,@"userId":userAccount.userId,@"regId":registrationId};
    
    [super HttpRequestForUri:bindPushUser andSendDic:dict businessBlock:nil/*block*/ callback:^(NSString *errorTips, NSDictionary *responsDict, BusinessCallback callback) {
        
        if(responsDict){
            
            if(registrationId.length)
                NSLog(@"绑定jpush id success : %@",responsDict);
            else
                NSLog(@"解除绑定jpush id success : %@",responsDict);
        }else{
            if(registrationId.length)
                NSLog(@"绑定jpush id faile : %@", errorTips);
            else
                NSLog(@"解除绑定jpush id faile : %@", errorTips);
        }
    }];
}


/**
 *  @brief 获得版本信息及屏蔽项
 */
-(void)versionAndShield{
    UserAccount *userAccount = [UserAccount getAccount];
    
    NSDictionary* dict = @{@"uid":userAccount.userId,@"sid":userAccount.sid,@"userId":userAccount.userId,};
    
    [super HttpRequestForUri:versionShield andSendDic:dict businessBlock:nil/*block*/ callback:^(NSString *errorTips, NSDictionary *responsDict, BusinessCallback callback) {
        
        if(responsDict){
            
            ShieldVersionDto * shield = [ShieldVersionDto mj_objectWithKeyValues:responsDict];
            [shield save];
            
            self.shield = shield;
            
        }else{
            
        }
    }];

}



/**
 * @brief 是否屏蔽日程
 */
-(BOOL)isShieldSchedule{
    return [self.shield isShieldSchedule];
}

/**
 * @brief 是否屏蔽随访
 */
-(BOOL)isShieldFollowPlan{
    return [self.shield isShieldFollowPlan];
}

/**
 * @brief 是否屏蔽随访
 */
-(BOOL)isShieldPrescribe{
    return [self.shield isShieldPrescribe];
}

/**
 * @brief 是否屏蔽版本更新提示
 */
-(BOOL)isShieldVersionUpdates{
    return [self.shield isShieldVersionUpdates];
}



@end














/********************************************************
 * @brief 版本更新相关类
 ********************************************************/
@implementation VersionUpdatesDto
//归档
MJExtensionCodingImplementation
@end


/********************************************************
 * @brief 屏蔽项&版本更新相关类
 ********************************************************/
@implementation ShieldVersionDto
//归档
MJExtensionCodingImplementation

-(void)save{
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ShieldVersionDto"];
    [NSKeyedArchiver archiveRootObject:self toFile:path];
}

+(ShieldVersionDto*)load{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ShieldVersionDto"];
    ShieldVersionDto *resp = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return resp;
}


/**
 * @brief 是否屏蔽日程
 */
-(BOOL)isShieldSchedule{
    for(NSString * shield in _restList){
        if([shield isEqualToString:@"schedule"]){
            return YES;
        }
    }
    return NO;
}

/**
 * @brief 是否屏蔽随访
 */
-(BOOL)isShieldFollowPlan{
    for(NSString * shield in _restList){
        if([shield isEqualToString:@"follow"]){
            return YES;
        }
    }
    return NO;
}

/**
 * @brief 是否屏蔽电子处方
 */
-(BOOL)isShieldPrescribe{
    for(NSString * shield in _restList){
        if([shield isEqualToString:@""]){
            return YES;
        }
    }
    return NO;
}

/**
 * @brief 是否屏蔽版本更新提示
 */
-(BOOL)isShieldVersionUpdates{
    return _versionUpdatesDto == NULL || _versionUpdatesDto.isCall == 3;
}

@end