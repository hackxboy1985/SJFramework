//
//  RegisterViewModel.h
//  Doctor
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 ViewHigh. All rights reserved.
//

#import "ViewModelBase.h"
//#import "ProviceModel.h"
//#import "CityModel.h"
//#import "HospitalModel.h"
//#import "DepartmentModel.h"
//#import "DepartmentListModel.h"
//#import "TitleNameModel.h"

@interface RegisterViewModel : ViewModelBase


/**
 *  @brief 处理用户的注册请求(完善资料之前的注册请求)
 *
 *  @param block            回调的 block
 *  @param phoneNumber       手机号码
 *  @param cetificationCode 短信验证码
 *  @param userPWD          密码
 */
-(void)registerRequestWithBlock:(BusinessCallback)block phoneNumber:(NSString *)phoneNumber cetificationCode:(NSString *)cetificationCode userPWD:(NSString *)userPWD regType:(int)regType;

/**
 *  @brief 处理用户完善资料请求
 */
-(void)improveRequestWithBlock:(BusinessCallback)block trueName:(NSString *)truename Hospital:(NSString *)Hospital Department:(NSString *)Department TitleName:(NSString *)TitleName Province:(NSString *)Province City:(NSString *)City Province_code:(NSString *)Province_code CityCode:(NSString *)CityCode hospitalId:(NSString *)hospitalId departmentId:(NSString *)departmentId titleId:(NSString *)titleId sex:(NSInteger)sex birthday:(NSString *)birthday email:(NSString *)email;

//上传头像图片
-(void)uploadImageWithBlock:(BusinessCallback)block imageArray:(NSArray *)imageArray;

//上传认证图片
-(void)uploadCetifiImageWithBlock:(BusinessCallback)block imageArray:(NSArray *)imageArray;

//获取短信验证码
-(void)getVerifyCodeWithBlock:(BusinessCallback)block telePhoneNumber:(NSString *)telePhoneNumber;

//重置密码
-(void)resetCodeWithBlock:(BusinessCallback)block phoneNumber:(NSString *)phoneNumber pwd:(NSString *)pwd code:(NSString *)code;




@end
