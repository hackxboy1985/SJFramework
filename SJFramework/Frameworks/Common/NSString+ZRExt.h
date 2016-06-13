//
//  NSString+ZRExt.h
//
//  Created by ZR on 14-8-7.
//  Copyright (c) 2014年 ZR. All rights reserved.
//

#import <Foundation/Foundation.h>

//MD5加密
@interface NSString (MD5)

- (NSString*) MD5;

@end



//SHA加密
@interface NSString (SHA)

- (NSString*) SHA1;
- (NSString*) SHA256;

@end



//UTF8编码
@interface NSString (OAURLEncodingAdditions)

//编码NSString为UTF8（主要处理中文）
//比如处理前：http://zs.tb360.org/恒时灯(宽屏）.mp4
//   处理后：http://zs.tb360.org/%E6%81%92%E6%97%B6%E7%81%AF(%E5%AE%BD%E5%B1%8F%EF%BC%89.mp4
- (NSString *)URLEncodeString;

//编码NSString为UTF8（处理中文＋"!*'();:@&=+$,/?%#[]"）
//比如处理前：http://zs.tb360.org/恒时灯(宽屏）.mp4
//   处理后：http%3A%2F%2Fzs.tb360.org%2F%E6%81%92%E6%97%B6%E7%81%AF%28%E5%AE%BD%E5%B1%8F%EF%BC%89.mp4
- (NSString *)URLEncodeStringByLegalCharacters;

//解码UTF8为NSString（对上面两种进行解码）
- (NSString *)URLDecodeString;

@end



//
@interface NSString (Common)

- (NSString *)trim;
- (BOOL)isEmpty;

@end



@interface NSString (TimeShow)

- (NSString *)getFormatTimeShow;

@end





