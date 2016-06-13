//
//  BusinessRequestBodyUtils.m
//  
//
//  Created by born on 16/4/12.
//
//

#import "BusinessRequestBodyUtils.h"
#import "SSKeychain.h"
#import "QUDefines.h"
#import "NSData+des.h"
#import "FtNetworkDetector.h"
#import "AppDelegateExten.h"

@implementation BusinessRequestBodyUtils

#define MAP_SAFE_SET_VAL(a,b,c)    if(c){[a setObject:c forKey:b];} else { NSLog(@"setObject forKey:%@ failed! val is nil.\n",b); }


//创建业务头信息
+(NSDictionary*)creatHeaderParamaters{
    /**
     header
     　	serviceId	业务线ID	yes	string
     　	serviceVersion	业务线版本	yes	string
     　	serviceType	业务线类型(0 Web端,1 移动端， 2 Wap端)	yes	string
     　	state	回溯信息	no	string
     　	encrypt	是否加密	yes	string
     　	version	服务版本号(默认当前版本号)	yes	string
     */
    

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    //header
    NSDictionary *parameters;
    parameters = @{ @"serviceId":@"11",
                    @"serviceVersion":@"",
                    @"serviceType":@1,
                    //@"state":1,
                    @"encrypt":@NO,
                    @"version":@"1",
                    };
    
    [dict addEntriesFromDictionary:parameters];
    //[dict setObject:[self getKey] forKey:@"sercertKey"];
    
    //device
    NSMutableDictionary *deviceDic = [self creatDeviceParamaters];
    NSString *deviceString = [self dictionaryToJson:deviceDic];
    [dict setObject:deviceString forKey:@"device"];
    
    return dict;
    
}

//创建设备参数
+(NSMutableDictionary*)creatDeviceParamaters{
    /**
     参数名称    是否必须	备注
     deviceId   Y	设备名称
     os         Y	客户端操作系统的类型:
     0--Android
     1--IOS
     2--WP
     3--Others
     
     osVer      Y	设备系统版本
     netType	Y	设备网络类型:
     0--wifi
     1--3G
     2--4G
     3--GPRS
     
     netServer	N	运营商名称:
     cnyd:中国移动
     cnlt:中国联通
     cndx:中国电信
     others:其他
     
     screen	Y	屏幕尺寸
     imsi	N	手机码
     userAgent	N	浏览器
     active_screenX	Y	激活相对于屏幕的X轴坐标
     active_screenY	Y	激活相对于屏幕的Y轴坐标
     active_longitude	N	激活经度
     active_latitude	N	激活纬度
     version	Y	SDK版本号
     imei	N	用户终端的IMEI，15位数字
     mac	N	用户终端的eth0 接口的 MAC 地址（大写且保留冒号分隔符）
     保留分隔符":"，（保持大写）
     openudid	N	ios设备唯一识别码
     androidid	N	用户终端的AndroidID
     duid	N	Windows Phone 用户终端的DUID，md5加密
     guid	Y	手动生成唯一id，用于确定设备唯一性。
     ip	N	获取的用户终端的公网IP地址
     如 12.34.56.78
     abi	N	abi
     
     OS=0时，IMEI/MAC/GUID/至少一项必填；
     OS=1时，OpenUDID/MAC/GUID/至少一项必填；
     */
    
    

    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    MAP_SAFE_SET_VAL(dic,@"deviceId",[UIDevice currentDevice].name)
    MAP_SAFE_SET_VAL(dic,@"os",@1)
    MAP_SAFE_SET_VAL(dic,@"osVer",[UIDevice currentDevice].systemVersion)
    MAP_SAFE_SET_VAL(dic,@"netType",[NSNumber numberWithInt:[[FtNetworkDetector startNetDetect] getNetType]])
    NSString* screen = [NSString stringWithFormat:@"%dx%d",(int)FullScreenWidth,(int)FullScreenHight];
    MAP_SAFE_SET_VAL(dic,@"screen",screen)
    MAP_SAFE_SET_VAL(dic,@"active_screenX",@"0")
    MAP_SAFE_SET_VAL(dic,@"active_screenY",@"0")
    MAP_SAFE_SET_VAL(dic,@"version", [UIDevice currentDevice].systemVersion)
    MAP_SAFE_SET_VAL(dic,@"guid",[[AppDelegateBase getAppDelegateBase] getUUID])
    
    return dic;

}


/**
 * @brief 字典转化为标准json
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


+(BOOL)encryptEnable{
    return true;
}

//获得加密解密key
+(NSString*) getKey{
    return @"0XLdH89mwM9in043h4tq3DvJ";
}

//加密数据
+(NSData*)encryptData:(NSString*)string
{
    return [NSData des3Data:[string dataUsingEncoding:NSUTF8StringEncoding] key:[self getKey] CCOperation:kCCEncrypt];
}

//解密数据
+(NSData*)decryptData:(NSData*)data
{
    return [NSData des3Data:data key:[self getKey] CCOperation:kCCDecrypt];
}

//加密数据
+(NSString*)encryptData2String:(NSData*)encryptData
{
    //使用base64
    NSString *lastData = [encryptData base64EncodedStringWithOptions:0];
    
    //使用16进制
    //NSString *lastData = binToHexWithData(encryptData).lowercaseString;
    return lastData;
}

//解密数据
+(NSString*)decryptEncryptString2String:(NSString*)encryptString
{
    // NSData from the Base64 encoded str
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:encryptString options:0];
    
    NSData *rawdata = [self decryptData:nsdataFromBase64String];
    // Decoded NSString from the NSData
    NSString *base64Decoded = [[NSString alloc]
                               initWithData:rawdata encoding:NSUTF8StringEncoding];
    return base64Decoded;

}

+(NSDictionary*)creatBodyWithParamaters:(NSDictionary*)senddic WithUri:(NSString*)uri{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[BusinessRequestBodyUtils creatHeaderParamaters]];
    
    if (senddic)
    {
        NSString *string = [self dictionaryToJson:senddic];
        
        if(kLogShowBusinessReq)
            NSLog(@"请求业务参数:%@\n%@",uri,string);
        
        if([self encryptEnable]){
            
            NSData *data = [self encryptData:string];//@"123456"
            
            if(data){
                
                //将加密数据转换成字符串
                NSString *lastData = [self encryptData2String:data];
                {
                    //测试解密
                    [self decryptEncryptString2String:lastData];
                }
                
                [parameters setObject:lastData forKey:@"data"];
            }else{
                ErrorLog("加解data为nil.");
            }
        }else{
            [parameters setObject:string forKey:@"data"];
        }
    }else{
        [parameters setObject:@"" forKey:@"data"];
    }
    
    return parameters;
}






@end




////////////////////////////////////////////////
#pragma mark - BusinessResponse
////////////////////////////////////////////////
@implementation BusinessResponse

@end




////////////////////////////////////////////////
#pragma mark - BusinessResponseUtils
////////////////////////////////////////////////

@implementation BusinessResponseUtils

// 解析，获取数据
+ (id)getReturnData:(NSString *)sourceString
{
    NSData *data = NULL;//调用解析工厂获得解析对象
    //    NSData *data = [NSData desData:hexToBinWithString(sourceString) key:ENCODEKEY CCOperation:kCCDecrypt ];
    
    //NSLog(@"Result:%@\n",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    id dic = [NSJSONSerialization JSONObjectWithData:data?data:[NSData data] options:NSJSONReadingMutableContainers error:&error];
    return dic;
}

// 解析，获取数据,不解密
+ (id)getUnDecryptReturnData:(NSString *)sourceString
{
    
    NSData *data = [sourceString dataUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"Result:%@\n",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    id dic = [NSJSONSerialization JSONObjectWithData:data?data:[NSData data] options:NSJSONReadingMutableContainers error:&error];
    return dic;
}

+(BusinessResponse*)handleResponseMsg:(NSDictionary*)result
{
    
    /**
     返回示例:
     {
     "code":10000,
     "msg":"操作成功",
     "encrypt":false,
     "state":"19871225",
     "timestamp":1460368627014,
     "data":"1",
     "success":false
     }
     */
    BusinessResponse* response = [[BusinessResponse alloc] init];
    NSNumber *code = [result valueForKey:@"code"];
    NSNumber *success = [result valueForKey:@"success"];
    NSString *message = [result valueForKey:@"msg"];
    response.message = message;

    if ([success boolValue] || [code intValue] == 10000)
    {
        NSNumber * encrypt = [result valueForKey:@"encrypt"];
        NSString * returnString = [result valueForKey:@"data"];
        
        if (![returnString isKindOfClass:[NSNull class]])
        {
            //获得数据字段，并解析
            id dic = NULL;
            if([encrypt boolValue] == false){
                dic = [self getUnDecryptReturnData:returnString];
            }else{
                dic = [self getReturnData:returnString];
            }
            
            //消息
            if ([dic isKindOfClass:[NSDictionary class]]){
                response.business = dic;
            }else{
                response.message = HASERROE;
                response.business = nil;
            }
        }else{
            response.business = [NSDictionary dictionary];
        }
    }
    else{
        if(message == nil)
            response.message = HASERROE;
        
        response.business = nil;
    }
    
    return response;
}


@end