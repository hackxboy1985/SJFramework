//
//  QURegex.h
//
//  Created by ZR on 14-8-20.
//  Copyright (c) 2014年 ZR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QURegex : NSObject

/**
 *  手机号是否有效
 *
 *  @param mobile 电话号码
 *
 *  @return 是否有效（true有效，false无效）
 */
+ (BOOL) isValidateMobile:(NSString *)mobile;
/**
 *  密码是否有效
 *
 *  @param pass 密码
 *
 *  @return 是否有效（true有效，false无效）
 */
+ (BOOL)judgePassWordLegal:(NSString *)pass;
/**
 *  手机号是否有效（只判断1开头的11位，因为很多虚拟号码上面的方法判断不出来）
 *
 *  @param mobile 电话号码
 *
 *  @return 是否有效（true有效，false无效）
 */
+ (BOOL) isValidatePhoneNumber:(NSString *)mobile;


/**
 *  邮箱是否有效
 *
 *  @param email 邮箱
 *
 *  @return 是否有效（true有效，false无效）
 */
+ (BOOL) isValidateEmail:(NSString *)email;


/**
 *  一个字符是否为汉字
 *
 *  @param name 需要判断是否为汉字的一个字符
 *
 *  @return 是否为汉字（true为汉字，false非汉字）
 */
+ (BOOL) isValidateChinese:(NSString *)name;


/**
 *	检查密码有效性
 *
 *	@param 	password 密码
 *
 *	@return	是否有效（true有效，false无效）
 */
+ (BOOL)isValidatePassWord:(NSString *)password;

/**
 *  简单手机号是否有效
 *
 *  @param mobile 电话号码
 *
 *  @return 是否有效（true有效，false无效）
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;


@end
