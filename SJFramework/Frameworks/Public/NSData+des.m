//
//  NSData+des.m
//  BreakFast
//
//  Created by Hkzr on 15/5/4.
//  Copyright (c) 2015年 Hkzr. All rights reserved.
//

#import "NSData+des.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (des)

//#define gkey            @"my.oschina.net/penngo?#@"
#define gIv             @"01234567"


// 加密方法
+ (NSData*)des3desEncrypt:(NSString*)plainText key:(NSString *)key
{
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    return myData;
}

//解密
+(NSString *)des3desDecrypt:(NSData *)cipherdata key:(NSString *)key
{
        NSString *plaintext = nil;
//        unsigned char buffer[1024];
        unsigned char *buffer = malloc(cipherdata.length + 8);
        memset(buffer, 0, cipherdata.length + 8);

        size_t numBytesDecrypted = 0;
    
        const void *vkey = (const void *) [key UTF8String];
        const void *vinitVec = (const void *) [gIv UTF8String];
    
        CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                              kCCAlgorithm3DES,
                                              kCCOptionPKCS7Padding,
                                              vkey,
                                              kCCKeySize3DES,
                                              vinitVec,
                                              [cipherdata bytes],
                                              [cipherdata length],
                                              buffer,
                                              cipherdata.length + 8,
                                              &numBytesDecrypted);
        if(cryptStatus == kCCSuccess) {
            NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
            plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
        }
        return plaintext;
}

+ (NSData *)desDataPKCS5:(NSData *)data key:(NSString *)keyString CCOperation:(CCOperation)op
{
    //    char buffer [4096] ;
    char *buffer = malloc(data.length + 8);
    memset(buffer, 0, data.length + 8);
    size_t bufferNumBytes;
    CCCryptorStatus cryptStatus = CCCrypt(op,
                                          
                                          kCCAlgorithm3DES,
                                          
                                          kCCOptionPKCS7Padding,
                                          
                                          [keyString UTF8String],
                                          
                                          kCCAlgorithm3DES,
                                          
                                          NULL,
                                          
                                          [data bytes],
                                          
                                          [data length],
                                          
                                          buffer,
                                          
                                          data.length + 8,
                                          
                                          &bufferNumBytes);
    if(cryptStatus == kCCSuccess)
    {
        NSData *returnData =  [NSData dataWithBytes:buffer length:bufferNumBytes];
        free(buffer);
        return returnData;
        //        NSString *returnString = [[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding]autorelease];
    }
    NSLog(@"des failed！");
    free(buffer);
    return nil;
}


/**
 * @brief 3des算法
 */
+ (NSData *)des3Data:(NSData *)data key:(NSString *)keyString CCOperation:(CCOperation)op
{
    //    char buffer [4096] ;
    //char *buffer = malloc(data.length + 8);
    //memset(buffer, 0, data.length + 8);
    size_t bufferNumBytes;
    
    size_t bufferPtrSize = (data.length + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    char *bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    CCCryptorStatus cryptStatus = CCCrypt(op,
                                          
                                          kCCAlgorithm3DES,
                                          
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          
                                          [keyString UTF8String],
                                          
                                          kCCKeySize3DES,
                                          
                                          NULL,
                                          
                                          [data bytes],
                                          
                                          [data length],
                                          
                                          bufferPtr,
                                          
                                          bufferPtrSize,
                                          
                                          &bufferNumBytes);
    if(cryptStatus == kCCSuccess)
    {
        NSData *returnData =  [NSData dataWithBytes:bufferPtr length:bufferNumBytes];
        free(bufferPtr);
        return returnData;
        //        NSString *returnString = [[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding]autorelease];
    }
    NSLog(@"des failed！");
    free(bufferPtr);
    return nil;
}

/**
 * @brief des pkcs7padding ecb 算法
 */
+ (NSData *)desData:(NSData *)data key:(NSString *)keyString CCOperation:(CCOperation)op
{
//    char buffer [4096] ;
    char *buffer = malloc(data.length + 8);
    memset(buffer, 0, data.length + 8);
    size_t bufferNumBytes;
    CCCryptorStatus cryptStatus = CCCrypt(op,
                                          
                                          kCCAlgorithmDES,
                                          
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          
                                          [keyString UTF8String],
                                          
                                          kCCKeySizeDES,
                                          
                                          NULL,
                                          
                                          [data bytes],
                                          
                                          [data length],
                                          
                                          buffer,
                                          
                                          data.length + 8,
                                          
                                          &bufferNumBytes);
    if(cryptStatus == kCCSuccess)
    {
        NSData *returnData =  [NSData dataWithBytes:buffer length:bufferNumBytes];
        free(buffer);
        return returnData;
        //        NSString *returnString = [[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding]autorelease];
    }
    NSLog(@"des failed！");
    free(buffer);
    return nil;
}


#pragma mark ---  binData hexString---

NSString* binToHexWithData(NSData*data)
{
    //将二进制数据转换为十六进制字符串
    if(data&&[data length]>0)
    {
        NSMutableString* mStr=[[NSMutableString alloc] initWithCapacity:0];
        
        for(int i=0;i<[data length];i++)
        {
            NSData* subData=[data subdataWithRange:NSMakeRange(i, 1)];
            uint8_t* bytes=(uint8_t*)[subData bytes];
            NSString* tempStr=[NSString stringWithFormat:@"%02X",bytes[0]];
            [mStr appendString:tempStr];
        }
        
        return mStr;
    }
    return nil;
}


uint8_t  getCharValuewithPre(char pre,char next)
{
    NSUInteger preValue= getValueByChar(pre)*16;
    NSUInteger nextValue=getValueByChar(next);
    uint8_t ret=preValue+nextValue;
    return ret;
}


NSUInteger getValueByChar (char ch)
{
    NSUInteger ret=0;
    switch(ch)
    {
        case 'A':ret=10;break;
        case 'B':ret=11;break;
        case 'C':ret=12;break;
        case 'D':ret=13;break;
        case 'E':ret=14;break;
        case 'F':ret=15;break;
        case '9':ret=9;break;
        case '8':ret=8;break;
        case '7':ret=7;break;
        case '6':ret=6;break;
        case '5':ret=5;break;
        case '4':ret=4;break;
        case '3':ret=3;break;
        case '2':ret=2;break;
        case '1':ret=1;break;
        case '0':ret=0;break;
    }
    return ret;
}


NSData* hexToBinWithString(NSString* txt)
{
    //将十六进制字符串转换为二进制数据.
    const char* charArray=[[txt uppercaseString] UTF8String];
    NSMutableData* mData=[[NSMutableData alloc] initWithLength:0];
    
    for(unsigned int i=0;i<[txt length];i+=2)
    {
        char  pre=charArray[i];
        char  next=charArray[i+1];
        uint8_t value=getCharValuewithPre(pre,  next);
        uint8_t chArrays[1]={value};
        [mData appendBytes:chArrays length:1];
    }
    return mData;
}



- (NSData *)md5Digest
{
    NSData* digestData = nil;
    if([self length]>0)
    {
        uint8_t digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5([self bytes], (CC_LONG)[self length], digest);
        digestData = [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    }
    return digestData;
}

NSString *urlDecode(NSString *originalString)
{
    //%21%40%24%26%28%29%3D%2B%7E%60%3B%27%3A%2C%2F%3F
    //!  @  $  &  (  )  =  +  ~  `  ;  '  :  ,  /  ?
    NSArray *escapeChars = [[NSArray alloc] initWithObjects:@"%3b" , @"%2f" , @"%3f" , @"%3a" ,
                            @"%40" , @"%26" , @"%3d" , @"%2b" , @"%24" , @"%2c" ,
                            @"%21", @"%27", @"%28", @"%29", @"%2a", nil];
    
    NSArray *replaceChars = [[NSArray alloc] initWithObjects:@";" , @"/" , @"?" , @":" ,
                             @"@" , @"&" , @"=" , @"+" , @"$" , @"," ,
                             @"!", @"'", @"(", @")", @"*", nil];
    
    NSUInteger len = [escapeChars count];
    
    NSString *temp = [originalString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    for(NSUInteger i = 0; i < len; i++)
    {
        temp = [temp stringByReplacingOccurrencesOfString:[escapeChars objectAtIndex:i]
                                               withString:[replaceChars objectAtIndex:i]
                                                  options:NSLiteralSearch
                                                    range:NSMakeRange(0, [temp length])];
    }
    
    NSString *relout = [NSString stringWithString: temp];
    
    return relout;
}


@end
