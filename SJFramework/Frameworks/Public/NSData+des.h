//
//  NSData+des.h
//  BreakFast
//
//  Created by Hkzr on 15/5/4.
//  Copyright (c) 2015年 Hkzr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonCrypto/CommonCryptor.h"

@interface NSData (des)


//二进制数据与十六进制字符串之间的转换
NSString* binToHexWithData(NSData*data);
uint8_t  getCharValuewithPre(char pre,char next);
NSUInteger getValueByChar (char ch);
NSData* hexToBinWithString(NSString* txt);
NSString *urlDecode(NSString *originalString);

//加密
+ (NSData*)des3desEncrypt:(NSString*)plainText key:(NSString *)key;
//解密
+(NSString *)des3desDecrypt:(NSData *)cipherdata key:(NSString *)key;

+ (NSData *)desDataPKCS5:(NSData *)data key:(NSString *)keyString CCOperation:(CCOperation)op;


/**
 * @brief 3des算法
 */
+ (NSData *)des3Data:(NSData *)data key:(NSString *)keyString CCOperation:(CCOperation)op;

/**
 * @brief des pkcs7padding ecb 算法
 */
+ (NSData *)desData:(NSData *)data key:(NSString *)keyString CCOperation:(CCOperation)op;

//md5
- (NSData *)md5Digest;

@end
