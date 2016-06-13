//
//  QUCommon.h
//
//  Created by ZR on 14-3-5.
//  Copyright (c) 2014年 ZR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface QUCommon : NSObject

/**
 *	@brief 得到一个随机数
 *	@param source 随机数的范围 比如：@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
 *	@param length 随机数的长度
 *
 *	@return 随机数
 */
+ (NSString *)getRand:(NSString *)source length:(int)length;


/**
 *  根据UUID创建一个NSString（每次返回的不一样，一般可用于生成消息的ID）
 *
 *  @return 返回一个唯一的NSString
 */
+ (NSString *)stringWithUUID;


/**
 *  打开浏览器
 *
 *  @param url 网页地址（网络）
 *
 *  @return 成功与否（true成功，false失败）
 */
+ (BOOL)openBrowser:(NSString*)url;


/**
 *  打电话
 *
 *  @param telephoneNumber 电话号码
 *
 *  @return 成功与否（true成功，false失败）
 */
+ (BOOL)openTelephone:(NSString*)telephoneNumber;


/**
 *  打开短信
 *
 *  @param smsTo 收件人
 *
 *  @return 成功与否（true成功，false失败）
 */
+ (BOOL)openSMS:(NSString*)smsTo;


/**
 *  打开邮件
 *
 *  @param mailTo 收件人 （多个收件人通过逗号分割）
 *
 *  @return 成功与否（true成功，false失败）
 */
+ (BOOL)openEmail:(NSString*)mailTo;


/**
 *  打开AppStore
 *
 *  @param appId appId
 *
 *  @return 成功与否（true成功，false失败）
 */
+ (BOOL)openAppStore:(NSString*)appId;
//判断6-16字母和数字密码是否正确
+(BOOL)judgePassWordLegal:(NSString *)pass;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (CGSize)getTextSize:(NSString*)text withFontSize:(CGFloat)font maxWidth:(CGFloat)width;

@end
