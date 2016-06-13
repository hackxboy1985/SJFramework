
//
//  AppDelegate_Exten.m
//  User
//
//  Created by Born on 15/8/1.
//  Copyright (c) 2015年 Hkzr All rights reserved.
//
#import "AppDelegateExten.h"
#import "AppDelegate+pay.h"

//#ifdef WX_SDK

//微信支付签名及分享相关头文件
#import "WXApi.h"
#import "payRequsestHandler.h"

//#endif


//阿里支付
#ifdef ALI_ADK

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "APAuthV2Info.h"

#endif


#ifdef WX_SDK
@interface AppDelegateBase (Wx)<WXApiDelegate>

-(void) onReq:(BaseReq*)req;
-(void) onResp:(BaseResp*)resp;

@end
#endif

@implementation AppDelegateBase(share_pay)

#pragma mark - 微信支付宝支付回调

- (BOOL)applicationSharePay:(UIApplication *)application handleOpenURL: (NSURL *)url
{
#ifdef WX_SDK

    if ([url.host isEqualToString:@"pay"])
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
#endif
    
#ifdef SHARE_SDK

    return [ShareSDK handleOpenURL:url wxDelegate:self];
    
#endif
    
    return YES;
}

- (BOOL)applicationSharePay: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication annotation: (id)annotation
{
    if ([url.host isEqualToString:@"safepay"])
    {
        handleAlipayCallback(url.query);
#ifdef ALI_ADK
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic){
            
             NSLog(@"result = %@",resultDic);
         }];
#endif
        return YES;
    }
    else if ([url.host isEqualToString:@"pay"])
    {
#ifdef WX_SDK

        return [WXApi handleOpenURL:url delegate:self];
#endif
    }
    
#ifdef SHARE_SDK

    return [ShareSDK handleOpenURL: url sourceApplication:sourceApplication annotation: annotation wxDelegate: self];
#endif
    return YES;
}

/////////////////////////////////////////////////////////////////////////////
#pragma mark - 分享
/////////////////////////////////////////////////////////////////////////////

#pragma mark - 分享初始化
- (void)initializePlat
{

#ifdef WX_SDK
    //微信支付
    //向微信注册
    [WXApi registerApp:_wxAppkey withDescription:_wxAppName];
    
#endif

    
#ifdef SHARE_SDK
    
    [ShareSDK registerApp:_shareSdkKey];

    //微博注册
//    [WeiboSDK enableDebugMode:YES];
//    [WeiboSDK registerApp:kAppKey];
    
    //连接微信分享
    [ShareSDK connectWeChatWithAppId:_wxAppkey   //微信APPID
                           appSecret:_wxAppSecret  //微信APPSecret
                           wechatCls:[WXApi class]];
    
    //连接QQ应用
    [ShareSDK connectQQWithQZoneAppKey:_qqAppkey
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    //连接QQ空间应用
    [ShareSDK connectQZoneWithAppKey:_qqAppkey
                           appSecret:_qqAppSecret
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
 

#endif
}


#pragma mark - QQ分享

#ifdef SHARE_SDK

- (void)shareButtonPressed:(ShareType)type content:(NSString*)content defaultContent:(NSString*)defaultContent imageName:(NSString*)imageName url:(NSString*)url
{
    //1.定制分享的内容
    id<ISSCAttachment> img;
    
    if([imageName hasPrefix:@"http"]){
        
        img = [ShareSDK imageWithUrl:imageName];
        
    }else{
        NSString* path = [[NSBundle mainBundle]pathForResource:imageName ofType:@"png"];
        
        img = [ShareSDK imageWithPath:path];
    }
    
    
    
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:defaultContent
                                                image:img
                                                title:_wxAppName
                                                  url:url
                                          description:_wxAppName
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //2.分享
    [ShareSDK showShareViewWithType:type container:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        
        NSLog(@"state === %i", state);
        
        //如果分享成功
        if (state == SSResponseStateSuccess) {
            NSLog(@"分享成功");
            
            //[[NSNotificationCenter defaultCenter]postNotificationName:ShareSuccessFul object:nil];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:_wxAppName message:@"分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        //如果分享失败
        if (state == SSResponseStateFail)
        {
            NSLog(@"分享失败,错误码:%ld,错误描述:%@",(long)[error errorCode],[error errorDescription]);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:_wxAppName message:@"分享失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        if (state == SSResponseStateCancel)
        {
            NSLog(@"分享取消");
            //        [[NSNotificationCenter defaultCenter]postNotificationName:ShareSuccessFul object:nil];
            //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"惠" message:@"分享取消" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //            [alert show];
        }
    }];
}

#endif

#pragma mark - 微信分享

#ifdef WX_SDK

/**
 * @brief 判断是否安装微信客户端
 */
- (BOOL)canOpenWeChat
{
    NSURL *url=[NSURL URLWithString:@"wechat://"];
    if ([[UIApplication sharedApplication]canOpenURL:url])
    {
        return YES;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"安装微信" message:@"您还没安装微信。需要去AppStore进行下载安装！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下载", nil];
        [alert show];
        
        
        return NO;
    }
}

//wx会话
-(void)wxSessionScene:(NSString*)content
{
    if (![self canOpenWeChat])
    {
        return;
    }
    /* enum WXScene _scene = (enum WXScene)WXSceneTimeline;
     
     JumpToBizWebviewReq * bizreq = [[JumpToBizWebviewReq alloc] init];
     bizreq.type=WXMPWebviewType_Ad;
     bizreq.tousrname = @"www.baidu.com";
     //    bizreq.scene = _scene;
     [WXApi sendReq:bizreq];*/
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = content;
    req.bText = YES;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

//wx朋友圈
-(void)wxTimelineScene:(NSString*)content
{
    if (![self canOpenWeChat])
    {
        return;
    }
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = content;
    req.bText = YES;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

-(void) onRequestAppMessage
{
    // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
}

-(void) onShowMediaMessage:(WXMediaMessage *) message
{
    // 微信启动， 有消息内容。
    //    [self viewContent:message];
}

#endif

/////////////////////////////////////////////////////////////////////////////
#pragma mark - 支付
/////////////////////////////////////////////////////////////////////////////

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
    if (IOS8_Later)
    {
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:title    message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        
        [alertCtr addAction:firstAction];
//        [self.tabbarViewController presentViewController:alertCtr animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alertView show];
    }
    
}



// 微信支付
- (void)wxSendPay:(NSString *)TradeNO price:(float)price
{
#ifdef WX_SDK
    price = price*100;
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    
    //创建支付签名对象
    payRequsestHandler *req = [[payRequsestHandler alloc]init];
    //初始化支付签名对象
    [req init:_wxAppkey  mch_id:_wxMchId];
    //设置密钥
    [req setKey:_wxPartnerID];
    
    //}}}
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_wx:TradeNO orderDesc:_wxAppName price:price notifyUrl:_wxPayNotifyUr];
    
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        
        //        [self alert:@"提示信息" msg:debug];
        
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }
#endif
}


//支付宝支付
- (void)alipay:(NSString *)TradeNO price:(float)price
{
    #ifdef ALI_ADK
    
    
    //MYLog(@"调用支付宝接口");
//    price = 0.01;//此行打开为测试0.01元
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/

    
    
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([_aliPartner length] == 0 ||
        [_aliSeller length] == 0 ||
        [_aliPrivateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予Order的成员变量
    Order *order = [[Order alloc] init];
    order.partner = _aliPartner;
    order.seller = _aliSeller;
    order.tradeNO = TradeNO; //订单ID(由商家□自□行制定)
    order.productName = [NSString stringWithFormat:@"%@-商品",_wxAppName]; //商品标题
    order.productDescription = @"商品描述"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",price]; //商品价格
    order.notifyURL = _aliNotifyUrl; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = _aliScheme;//////////此处定义回调,要与plist中一致
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(_aliPrivateKey);
    NSString *signedString = [signer signString:orderSpec];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            handleAlipayWebCallback([resultDic objectForKey:@"resultStatus"]);
            NSLog(@"支付宝reslut = %@",resultDic);
            
        }];
    }
    
    #endif
}



#pragma mark - WXApiDelegate

#ifdef WX_SDK

-(void) onReq:(BaseReq*)req
{
    //onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        [self onRequestAppMessage];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        [self onShowMediaMessage:temp.message];
    }
}

-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT object:[NSNumber numberWithInt:1]];
                
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            case WXErrCodeUserCancel:
                
                [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT object:[NSNumber numberWithInt:2]];
                
                strMsg = @"支付结果：用户取消！";
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT object:[NSNumber numberWithInt:0]];

                
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    else if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if (resp.errCode == 0)
        {
            NSLog(@"分享成功！");
            [[NSNotificationCenter defaultCenter] postNotificationName:SHARE_2_WX object:[NSNumber numberWithInt:1]];
        }
        else{
            NSLog(@"分享失败！");
            [[NSNotificationCenter defaultCenter] postNotificationName:SHARE_2_WX object:[NSNumber numberWithInt:-1]];
        }
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        if (resp.errCode == 0)
        {
            NSLog(@"分享成功！");
            
        }
        else
            NSLog(@"分享失败！");
    }
    
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //    [alert show];
    
}

#endif

void handleAlipayWebCallback(NSString* query)
{
#pragma 暂时注释掉
//    query = urlDecode(query);
    
    NSLog(@"alipay query:%@",query);
    
    if ([query rangeOfString:@"9000"].location != NSNotFound)
    {   // 成功
        NSLog(@"Alipay Success.");
        [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT object:[NSNumber numberWithInt:PAY_SUCC]];
    }
    else if ([query rangeOfString:@"8000"].location != NSNotFound)
    {
        // 回调确认中
        NSLog(@"Alipay confirming.");
        [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT object:[NSNumber numberWithInt:PAY_SUCC]];
    }
    else if ([query rangeOfString:@"6001"].location != NSNotFound)
    {
        // 中途取消
        NSLog(@"Alipay user cancel.");
        [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT object:[NSNumber numberWithInt:PAY_CANCEL]];
    }
    else
    {
        // 支付失败
        NSLog(@"Alipay failed.");
        [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT object:[NSNumber numberWithInt:PAY_FAIL]];
    }
    
//    if([query containsString:@"9000"]){//成功
//        NSLog(@"Alipay Success.");
//        [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT object:[NSNumber numberWithInt:1]];
//    }
//    else if([query containsString:@"8000"]){//回调确认中
//        NSLog(@"Alipay confirming.");
//        [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT object:[NSNumber numberWithInt:1]];
//    }else if([query containsString:@"6001"]){//中途取消
//        NSLog(@"Alipay user cancel.");
//        [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT object:[NSNumber numberWithInt:2]];
//        
////        if(appDelegate.tabbarViewController){
////            [appDelegate.tabbarViewController showToastHUDView:@"订单已提交，请尽快支付"];
////        }
//    }else{//支付失败
//        NSLog(@"Alipay failed.");
//        [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT object:[NSNumber numberWithInt:0]];
//        
////        if(appDelegate.tabbarViewController){
////            [appDelegate.tabbarViewController showToastHUDView:@"订单已提交，请尽快支付"];
////        }
//    }
}

void handleAlipayCallback(NSString* query)
{
//    query = urlDecode(query);
    NSLog(@"alipay query:%@",query);
    if ([query rangeOfString:@"\"ResultStatus\":\"9000\""].location != NSNotFound)
    {   // 成功
        NSLog(@"Alipay Success.");
        [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT object:[NSNumber numberWithInt:1]];
    }
    else if ([query rangeOfString:@"\"ResultStatus\":\"8000\""].location != NSNotFound)
    {
        // 回调确认中
        NSLog(@"Alipay confirming.");
        [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT object:[NSNumber numberWithInt:1]];
    }
    else if ([query rangeOfString:@"\"ResultStatus\":\"6001\""].location != NSNotFound)
    {
        // 中途取消
        NSLog(@"Alipay user cancel.");
        [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT object:[NSNumber numberWithInt:2]];
    }
    else
    {
        // 支付失败
        NSLog(@"Alipay failed.");
        [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT object:[NSNumber numberWithInt:0]];
    }
    
    
//    if([query containsString:@"\"ResultStatus\":\"9000\""]){//成功
//        NSLog(@"Alipay Success.");
//        [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT object:[NSNumber numberWithInt:1]];
//    }
//    else if([query containsString:@"\"ResultStatus\":\"8000\""]){//回调确认中
//        NSLog(@"Alipay confirming.");
//        [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT object:[NSNumber numberWithInt:1]];
//    }else if([query containsString:@"\"ResultStatus\":\"6001\""]){//中途取消
//        NSLog(@"Alipay user cancel.");
//        [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT object:[NSNumber numberWithInt:2]];
//        
////        if(appDelegate.tabbarViewController){
////            [appDelegate.tabbarViewController showToastHUDView:@"订单已提交，请尽快支付"];
////        }
//    }else{//支付失败
//        NSLog(@"Alipay failed.");
//        [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT object:[NSNumber numberWithInt:0]];
//        
////        if(appDelegate.tabbarViewController){
////            [appDelegate.tabbarViewController showToastHUDView:@"订单已提交，请尽快支付"];
////        }
//    }
}




@end
