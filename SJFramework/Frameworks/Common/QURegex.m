//
//  QURegex.m
//
//  Created by ZR on 14-8-20.
//  Copyright (c) 2014年 ZR. All rights reserved.
//

#import "QURegex.h"

@implementation QURegex

+ (BOOL) isValidateMobile:(NSString *)mobile
{
    //  前三位为以下数值组合开头：130、131、132、133、134、135、136、137、138、139、150、151、152、153、155、156、157、158、159、170、176、180、181、182、183、184、185、186、187、188、189
    NSString* regex = @"^((13|15|18)[0-9]|170|176)\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:mobile];
}

+ (BOOL)judgePassWordLegal:(NSString *)pass{
    BOOL result = false;
    if ([pass length] >= 6){
        // 判断长度大于6位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
}


+ (BOOL) isValidatePhoneNumber:(NSString *)mobile
{
    NSString* regex = @"^(1)\\d{10}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:mobile];
}


+ (BOOL) isValidateEmail:(NSString *)email
{
    NSString* regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:email];
}


+ (BOOL) isValidateChinese:(NSString *)name
{
    NSString* regex = @"[\u4e00-\u9fa5]";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:name];
}


+ (BOOL)isValidatePassWord:(NSString *)password
{
    NSString* regex = @"^.{6,16}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:password];
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    // 简单判断
    if ([mobileNum hasPrefix:@"1"] && mobileNum.length == 11)
    {
        unichar c;
        for (int i = 0; i < mobileNum.length; i++)
        {
            c = [mobileNum characterAtIndex:i];
            if (!isdigit(c))
            {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}



@end
