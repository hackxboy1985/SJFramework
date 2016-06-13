//
//  ViewModelBase.m
//  
//
//  Created by born on 16/4/11.
//
//  Copyright (c) 2016年 Hkzr All rights reserved.

#import "ViewModelBase.h"
#import "AFNetworking.h"
#import "FtNetworkDetector.h"
#import "BusinessRequestBodyUtils.h"

#import "NSDictionary+ZRExt.h"
#import "SSKeychain.h"
#import "NSString+ZRExt.h"



static NSMutableDictionary* cbDictionary;
static NSMutableDictionary* businessCbDictionary;




@interface ViewModelBase(){
    NSMutableArray* _uiListenerArray;
}
@end


@implementation ViewModelBase


+(void)debugMemoryLeaks{
    
}


-(id)init
{
    self = [super init];
    
    if(self)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            cbDictionary = [[NSMutableDictionary alloc] init];
            businessCbDictionary = [[NSMutableDictionary alloc] init];
        });
        
        _uiListenerArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark - IViewModelManager接口方法实现

/**
 * @brief 应用进入后台
 */
-(void)didEnterBackground{
    
}

/**
 * @brief 应用进入前台
 */
-(void)didEnterForeground{
    
}

/**
 * @brief 登录成功
 */
-(void)loginSuccessful{
    
}

/**
 * @brief 登出成功
 */
-(void)logout{
    
}
#pragma mark - HTTP请求相关接口

/**
 * @brief 创建key
 */
-(NSString*)productIdentKey:(id)ident withUrl:(NSString*)url{
    NSString* key = [NSString stringWithFormat:@"<%p>:%@",ident,url];
    return key;
}

/**
 * @brief 注册Http回调.
 */
-(void)registerCallbackBlock:(HttpRequestCB)cb ident:(id)ident withUrl:(NSString*)url
{
    if([cbDictionary objectForKey:ident]){
        NSLog(@"Already register callback.");
        return;
    }
    NSString* key = [self productIdentKey:ident withUrl:url];
    [cbDictionary setObject:cb forKey:key];
}

/**
 * @brief 获得并移除Http回调缓存.
 */
-(HttpRequestCB)getCallbackBlock:(id)ident withUrl:(NSString*)url
{
    NSString* key = [self productIdentKey:ident withUrl:url];
    HttpRequestCB cb = [cbDictionary objectForKey:key];
    [cbDictionary removeObjectForKey:ident];
    return cb;
}

/**
 * @brief 注册业务回调.
 */
-(void)registerBusinessCallbackBlock:(BusinessCallback)cb ident:(id)ident withUrl:(NSString*)url
{
    if([businessCbDictionary objectForKey:ident]){
        NSLog(@"Already register callback.");
        return;
    }
    
    NSString* key = [self productIdentKey:ident withUrl:url];
    if(cb)
        [businessCbDictionary setObject:cb forKey:key];
}

/**
 * @brief 获得并移除业务回调缓存.
 */
-(BusinessCallback)getBusinessCallbackBlock:(id)ident withUrl:(NSString*)url
{
    NSString* key = [self productIdentKey:ident withUrl:url];
    BusinessCallback cb = [businessCbDictionary objectForKey:key];
    [businessCbDictionary removeObjectForKey:ident];
    return cb;
}

/**
 * @brief 处理HTTP响应.
 */
- (void)handleResponse:(NSDictionary *)result fromRequestUri:(NSString *)uri identity:(id)identity
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
    NSLog(@"请求 %@  响应\n%@",uri,[result unicodeDesc]);
//    NSLog(@"请求 %@  响应\n%@",uri,result);
    
    BusinessResponse* response = [BusinessResponseUtils handleResponseMsg:result];
    id dic = response.business;
//    if(dic)
//    {
//        NSLog(@"%@ . Return\nSuccess Decrypt:%@",uri,[dic unicodeDesc]);
//    }
    
    //获得数据字段，并解析
    HttpRequestCB block = [self getCallbackBlock:identity withUrl:uri];
    
    if ([dic isKindOfClass:[NSDictionary class]])
    {
        block(response.message,dic,[self getBusinessCallbackBlock:identity withUrl:uri]);
    }else{
        block(response.message,nil,[self getBusinessCallbackBlock:identity withUrl:uri]);
    }
}

/**
 * @brief 处理HTTP错误响应.
 */
- (void)handleResponseError:(NSString*)uri identity:(id)identity
{
    HttpRequestCB block = [self getCallbackBlock:identity withUrl:uri];
    if(block)
        block(HASERROE,nil,[self getBusinessCallbackBlock:identity withUrl:uri]);
}




/**
 *  数据请求
 *
 *  @param uri          请求地址
 *  @param senddic      发送的数据字典
 *  @param busiBlock     业务回调,统一存储
 *  @param callback     请求回调
 */
-(void)HttpRequestForUri:(NSString *)uri  andSendDic:(NSDictionary *)senddic businessBlock:(BusinessCallback)busiBlock callback:(HttpRequestCB)callback
{
#ifdef DEBUG
    assert(uri);
#endif
    NSDictionary *parameters = [BusinessRequestBodyUtils creatBodyWithParamaters:senddic WithUri:uri];
    
    if(kLogShowTotalReq)
        NSLog(@"请求 %@\n%@",uri,parameters);
    
    __weak typeof(self) weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置超时时间
    //[manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];

    manager.requestSerializer.timeoutInterval = 15.0f;

    //[manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    // 加上这行代码，https ssl 验证。
    //[manager setSecurityPolicy:[self customSecurityPolicy]];
    
    AFHTTPRequestOperation * operation =[manager POST:uri parameters:parameters
                                              success:^(AFHTTPRequestOperation *operation,id responseObject) {
                                                  
                                                  //成功
                                                  if ([responseObject isKindOfClass:[NSDictionary class]]){
                                                      [weakSelf handleResponse:responseObject fromRequestUri:uri identity:operation];
                                                  }else{
                                                      NSLog(@"请求成功 格式异常 \n%@",responseObject);
                                                      [weakSelf handleResponse:nil fromRequestUri:uri identity:operation];
                                                      //[weakSelf handleResponseError:uri identity:operation];
                                                  }
                                                  
                                              }failure:^(AFHTTPRequestOperation *operation,NSError *error){
                                                  
                                                  //失败
                                                  NSLog(@"请求错误 %@ \nError:>> %@", uri, [error description]);
                                                  [weakSelf handleResponseError:uri identity:operation];
                                                  
                                              }];
    
    
    [self registerCallbackBlock:callback ident:operation withUrl:uri];
    [self registerBusinessCallbackBlock:busiBlock ident:operation withUrl:uri];
}


/**
 *  @brief 上传图片
 *
 *  @param uri        请求地址
 *  @param senddic    发送的数据字典
 *  @param imageArray 图片数组
 *  @param busiBlock  业务回调,统一存储
 *  @param callback   请求回调
 */
-(void)uploadImageForUri:(NSString *)uri andSendDic:(NSDictionary *)senddic imageArray:(NSArray *)imageArray businessBlock:(BusinessCallback)busiBlock callback:(HttpRequestCB)callback{

    assert(uri);
    NSDictionary *parameters = [BusinessRequestBodyUtils creatBodyWithParamaters:senddic WithUri:uri];
    
    __weak typeof(self) weakSelf = self;
    NSMutableString* urlparam = [[NSMutableString alloc] init];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString* val = [NSString stringWithFormat:@"%@",obj];
        [urlparam appendFormat:@"%@=%@&",key,[val URLEncodeStringByLegalCharacters]];
    }];
    
    NSString *urlString = [NSString stringWithFormat:@"%@?%@",uri,urlparam];

    if(kLogShowTotalReq)
        NSLog(@"请求 %@",urlString);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置超时时间
    //manager.requestSerializer.timeoutInterval = 45.0f;
    
   AFHTTPRequestOperation * operation = [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
       NSInteger imgCount = 0;
       for (UIImage *image in imageArray) {
           //image压缩  转为NSData
           NSData *imageData = UIImageJPEGRepresentation(image,0.3);
           
           //使用日期给图片命名
           NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
           formatter.dateFormat = @"yyyyMMddHHmmss";
           //拼接文件名称
           NSString *fileName = [NSString stringWithFormat:@"%@%@.png",[formatter stringFromDate:[NSDate date]],@(imgCount)];
           //拼接数据
           [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"uploadFile%@",@(imgCount)] fileName:fileName mimeType:@"image/jpeg"];
           imgCount++;
       }
       
   } success:^(AFHTTPRequestOperation *operation, id responseObject) {
       //成功
       if ([responseObject isKindOfClass:[NSDictionary class]]){
           [weakSelf handleResponse:responseObject fromRequestUri:uri identity:operation];
       }else{
           NSLog(@"请求成功 格式异常 \n%@",responseObject);
           [weakSelf handleResponse:nil fromRequestUri:uri identity:operation];
           //[weakSelf handleResponseError:uri identity:operation];
       }
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       //失败
       NSLog(@"请求错误 %@ \nError:>> %@", uri, [error description]);
       [weakSelf handleResponseError:uri identity:operation];
   }];
    [self registerCallbackBlock:callback ident:operation withUrl:uri];
    [self registerBusinessCallbackBlock:busiBlock ident:operation withUrl:uri];
}




/**
 * @brief HTTPS支持
 */
+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"hgcang" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    assert(certData);
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = @[certData];
    
    return securityPolicy;
}



/**
 * @brief 注册UI监听对象
 * @param uiproxy 监听对象
 */
-(void)registerUIListener:(id<LogicToUICallback>)uiproxy{
    if([_uiListenerArray containsObject:uiproxy] == false)
        [_uiListenerArray addObject:uiproxy];
}

/**
 * @brief 反注册UI监听对象
 * @param uiproxy 监听对象
 */
-(void)unregisterUIListener:(id<LogicToUICallback>)uiproxy{
    if([_uiListenerArray containsObject:uiproxy])
        [_uiListenerArray removeObject:uiproxy];
}

/**
 * @brief 通知UI层回调
 * @param cmd 命令标识
 * @param param 参数
 */
-(void)notifyUIListener:(int)cmd paramater:(id)param{
    for(id<LogicToUICallback> listener in _uiListenerArray){
        [listener notifyUICallback:cmd paramater:param];
    }
}

@end
