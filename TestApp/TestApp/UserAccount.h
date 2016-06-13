//
//  UserAccount.h
//  Doctor
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 ViewHigh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSKeychain.h"
/********************************************************
 *  UserAccount(用户账户模型)
 ********************************************************/
@interface UserAccount : NSObject

@property (nonatomic,assign) NSInteger authStatus; //医生认证状态1已通过2待审核3.已拒
@property (nonatomic,copy) NSString *userId;//用户ID
@property (nonatomic,copy) NSString *sid;  //tokenId
@property (nonatomic,copy) NSString *did; //医生id
@property (nonatomic,assign) NSInteger bedNum;//病床号绝
@property (nonatomic,copy) NSString *birthday;//生日
@property (nonatomic,copy) NSString *card;//身份证
@property (nonatomic,copy) NSString *city;//城市
@property (nonatomic,copy) NSString *cityCode;//市CODE
@property (nonatomic,copy) NSString *department;//科室
@property (nonatomic,copy) NSString *departmentId; //科室的ID
@property (nonatomic,copy) NSString *email;//邮箱
@property (nonatomic,copy) NSString *telephone;//手机
@property (nonatomic,assign) NSInteger haveBank;//是否绑定银行卡
@property (nonatomic,copy) NSString *hospital;//医院
@property (nonatomic,copy) NSString *hospitalId;//医院的ID
@property (nonatomic,copy) NSString *hospitalNum;//住院号
@property (nonatomic,copy) NSString *outpatientNum;//门诊号
@property (nonatomic,copy) NSString *province;//省
@property (nonatomic,copy) NSString *provinceCode;//省份编码
@property (nonatomic,copy) NSString *saveupNum;//就诊号
@property (nonatomic,assign) NSInteger sex;//性别  1男  2女
@property (nonatomic,copy) NSString *titleName;//职称
@property (nonatomic,copy) NSString *titleId; //职称的ID
@property (nonatomic,copy) NSString *trueName;//真实姓名
@property (nonatomic,assign) NSInteger utype;//用户分类 1医生 2患者
@property (nonatomic,copy) NSString *wardNum;//病房号
@property (nonatomic,copy) NSString *String;//病区
@property (nonatomic,copy) NSString *avatar;//头像
@property (nonatomic,copy) NSString *avatarSmallPics;//头像缩略图
@property (nonatomic,copy) NSString *authSmallPics;//认证图 逗号分隔2张 缩略图
@property (nonatomic,copy) NSString *authPics;//认证图 逗号分隔2张
@property (nonatomic,copy) NSString *userName;//用户名
@property (nonatomic,assign) NSInteger accountType;//账号类型
@property (nonatomic,assign) NSInteger thridId;//第三方ID
@property (nonatomic,assign) NSInteger updated;//更新时间
@property (nonatomic,assign) NSInteger created;//创建时间
@property (nonatomic,copy) NSString *authRemark;//认证备注
@property (nonatomic,copy) NSString *qrCodeUrl; //二维码地址



//保存用户密码
+(void)saveUserPWDWithPWD:(NSString *)pwd userName:(NSString *)userName;

//获取用户密码
+(NSString *)getUserPWDWithuserName:(NSString *)userName;

//保存账号信息
+(void)saveAccount:(UserAccount *)account;

//获取账号信息
+(UserAccount *)getAccount;

@end







