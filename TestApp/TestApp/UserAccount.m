//
//  UserAccount.m
//  Doctor
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 ViewHigh. All rights reserved.
//

#import "UserAccount.h"

@implementation UserAccount

//归档
MJExtensionCodingImplementation

//设置不想归档的属性
//+ (NSArray *)mj_ignoredCodingPropertyNames
//{
//    return @[@"name"];
//}


//保存账号密码
+(void)saveUserPWDWithPWD:(NSString *)pwd userName:(NSString *)userName{
    
    // 将用户密码保存在钥匙串
    NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
    if([SSKeychain setPassword:pwd forService:bundleId account:userName]==false)
        NSLog(@">>Save Account Pwd Failed!!!\n");
}

//获取账号密码
+(NSString *)getUserPWDWithuserName:(NSString *)userName{

    NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
    return [SSKeychain passwordForService:bundleId account:userName];
}


//保存账号信息
+(void)saveAccount:(UserAccount *)account{

    UserAccount* lastAcc = [self getAccount];
    if(account.userName == nil)
        account.userName = lastAcc.userName;

    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account"];
    [NSKeyedArchiver archiveRootObject:account toFile:path];
}

//获取账号信息
+(UserAccount *)getAccount{

    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account"];
    UserAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
#if DEBUG //测试
    if(account == nil){
        account = [[UserAccount alloc] init];
        account.userName = @"aa";
    }
    
    if(account.avatar.length == 0)
//       account.avatar = @"http://ww2.sinaimg.cn/crop.80.0.800.800.1024/6a27e5d9jw8e8wa5zczwkj20qo0m875m.jpg";
        account.avatar = @"http://b.hiphotos.baidu.com/baike/c0%3Dbaike220%2C5%2C5%2C220%2C73/sign=7cfa82dff5deb48fef64a98c9176514c/a71ea8d3fd1f4134160a1dc0231f95cad1c85e4a.jpg";
#endif
    
    
    if(account.userId == nil)
        account.userId = @"";
    
    if(account.sid == nil)
        account.sid = @"";
    
    if(account.userId == nil)
        account.userId = @"";
    
    
    return account;
}

@end
