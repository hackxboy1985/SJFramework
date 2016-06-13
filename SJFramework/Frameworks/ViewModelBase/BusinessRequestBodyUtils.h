//
//  BusinessRequestBodyUtils.h
//  
//
//  Created by born on 16/4/12.
//
//  Copyright (c) 2016年 Hkzr All rights reserved.



/********************************************************
 *  业务相关请求体封装工具,抽离此类,只因不同项目有不同的协议格式
 ********************************************************/
@interface BusinessRequestBodyUtils : NSObject


/**
 * @brief 创建业务请求信息
 */
+(NSDictionary*)creatBodyWithParamaters:(NSDictionary*)senddic WithUri:(NSString*)uri;


@end






#define HASERROE  @"请求失败，请稍后重试"

/********************************************************
 *  响应数据对象模型
 ********************************************************/
@interface BusinessResponse : NSObject
@property(nonatomic)int code;//
@property(nonatomic,copy)NSString *message;//
@property(nonatomic,strong)NSDictionary *business;//

@end




/********************************************************
 *  业务相关返回体处理的封装工具,抽离此类,只因不同项目有不同的协议格式
 ********************************************************/
@interface BusinessResponseUtils : NSObject

+(BusinessResponse*)handleResponseMsg:(NSDictionary*)result;

@end

