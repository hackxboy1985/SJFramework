//
//  RegisterViewModel.m
//  Doctor
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 ViewHigh. All rights reserved.
//

#import "RegisterViewModel.h"
#import "UserAccount.h"
#import "AppDelegateBase.h"
#define userImprove IP@"/api/v1/udoctor/updateDoctor" //完善资料
#define userRegister IP@"/api/v1/user/register" //用户注册
#define uploadIconImage IP@"/api/v1/udoctor/uploadDoctorAvatar" //上传图片
#define getVerifyCode IP@"/api/v1/user/sendVerifyCode" //获取验证码
#define resetCode IP@"/api/v1/user/resetPassword" //忘记密码
#define uploadCetifiImage IP@"/api/v1/udoctor/uploadDoctorAuthPic" //上传认证图片

#define getProvice IP@"/api/v1/comm/findProvinceList" //获取省列表
#define getCity IP@"/api/v1/comm/findCityList" //获取市列表
#define getHospital IP@"/api/v1/comm/findHospitalList" //获取医院列表
#define searchHospital IP@"/api/v1/comm/findHospatailByName" //搜索医院
#define departmentList IP@"/api/v1/comm/findDepartmentList" //科室分类列表
#define getDepartment IP@"/api/v1/comm/findDepartmentList" //科室列表
#define geTtitleName IP@"/api/v1/comm/findtitleNameList" //获取职称列表


@interface RegisterViewModel ()
@property (nonatomic,strong) NSMutableArray *ProviceArray; //省模型数组
@property (nonatomic,strong) NSMutableArray *CityArray; //市模型数组
@property (nonatomic,strong) NSMutableArray *HospitalArray;//医院模型数组
@property (nonatomic,strong) NSMutableArray *DepartmentArray;//科室分类模型数组
@property (nonatomic,strong) NSMutableArray *DepartmentListArray;//科室列表数组
@property (nonatomic,strong) NSMutableArray *TitleNameArray;//职称列表数组
@property (nonatomic,strong) NSMutableArray *SearchHospitalArray;//搜索医院数组
@end

@implementation RegisterViewModel

//用户注册
-(void)registerRequestWithBlock:(BusinessCallback)block phoneNumber:(NSString *)phoneNumber cetificationCode:(NSString *)cetificationCode userPWD:(NSString *)userPWD regType:(int)regType{
    NSDictionary *dict = @{@"userName":phoneNumber,@"verifyCode":cetificationCode,@"password":userPWD,@"accountType":@1};
    [super HttpRequestForUri:userRegister andSendDic:dict businessBlock:block callback:^(NSString *errorTips, NSDictionary *responsDict, BusinessCallback callback) {
        if (responsDict) {
            NSLog(@"注册--->%@",responsDict);
            
            UserAccount *userAccount = [UserAccount mj_objectWithKeyValues:responsDict];
            [UserAccount saveAccount:userAccount];
            //保存密码
            [UserAccount saveUserPWDWithPWD:userPWD userName:phoneNumber];
            
            if(block)//判断 block 是否有值
                block(true,@"");
        } else{
            if(block)
                block(false,errorTips);
        }
    }];
}

//完善资料
-(void)improveRequestWithBlock:(BusinessCallback)block trueName:(NSString *)truename Hospital:(NSString *)Hospital Department:(NSString *)Department TitleName:(NSString *)TitleName Province:(NSString *)Province City:(NSString *)City Province_code:(NSString *)Province_code CityCode:(NSString *)CityCode hospitalId:(NSString *)hospitalId departmentId:(NSString *)departmentId titleId:(NSString *)titleId sex:(NSInteger)sex birthday:(NSString *)birthday email:(NSString *)email{
    
    UserAccount *account = [UserAccount getAccount];
    NSDictionary *dict = @{@"did":account.did,@"trueName":truename,@"hospital":Hospital,@"department":Department,@"titleName":TitleName,@"province":Province,@"city":City,@"provinceCode":Province_code,@"cityCode":CityCode,@"hospitalId":hospitalId,@"departmentId":departmentId,@"titleId":titleId,@"sex":@(sex),@"birthday":birthday,@"email":email};

    [super HttpRequestForUri:userImprove andSendDic:dict businessBlock:block callback:^(NSString *errorTips, NSDictionary *responsDict, BusinessCallback callback) {
        if (responsDict) {
            NSLog(@"完善资料------>%@",responsDict);
            
            //block回调(控制器传入的block在此回调)
            if(block)//判断 block 是否有值
                block(true,@"");
        } else{
            
            if(block)
                block(false,errorTips);
        }
    }];
    
}

//上传头像
-(void)uploadImageWithBlock:(BusinessCallback)block imageArray:(NSArray *)imageArray{
    
    UserAccount *account = [UserAccount getAccount];
    NSDictionary *dict = @{@"did":account.did};
    [super uploadImageForUri:uploadIconImage andSendDic:dict imageArray:imageArray businessBlock:block callback:^(NSString *errorTips, NSDictionary *responsDict, BusinessCallback callback) {
        if (responsDict) {
            NSLog(@"上传头像------>%@",responsDict);
            
            if(block)
                block(true,@"");
        }else{
            
            if(block)
                block(false,errorTips);
        }
    }];
}


//上传认证图片
-(void)uploadCetifiImageWithBlock:(BusinessCallback)block imageArray:(NSArray *)imageArray{

    UserAccount *account = [UserAccount getAccount];
    NSDictionary *dict = @{@"did":account.did};
    [super uploadImageForUri:uploadCetifiImage andSendDic:dict imageArray:imageArray businessBlock:block callback:^(NSString *errorTips, NSDictionary *responsDict, BusinessCallback callback) {
        if (responsDict) {
            NSLog(@"上传认证图片------>%@",responsDict);
            
            if(block)
                block(true,@"");
        }else{
            
            if(block)
                block(false,errorTips);
        }
    }];

}


//获取短信验证码
-(void)getVerifyCodeWithBlock:(BusinessCallback)block telePhoneNumber:(NSString *)telePhoneNumber{
    
    NSDictionary *dict = @{@"telephone":telePhoneNumber,@"smsType":@"1"};
    [super HttpRequestForUri:getVerifyCode andSendDic:dict businessBlock:block callback:^(NSString *errorTips, NSDictionary *responsDict, BusinessCallback callback) {
        if (responsDict) {
            
            if(block)
                block(true,@"");
        } else{
            
            if(block)
                block(false,errorTips);
        }
    }];

}

//重置密码
-(void)resetCodeWithBlock:(BusinessCallback)block phoneNumber:(NSString *)phoneNumber pwd:(NSString *)pwd code:(NSString *)code{

    NSDictionary *dict = @{@"userName":phoneNumber,@"password":pwd,@"verifyCode":code};
    [super HttpRequestForUri:resetCode andSendDic:dict businessBlock:block callback:^(NSString *errorTips, NSDictionary *responsDict, BusinessCallback callback) {
        if (responsDict) {
            
           
            if(block)
                block(true,@"");
        } else{
            
            if(block)
                block(false,errorTips);
        }
    }];
}

@end
