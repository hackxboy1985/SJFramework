//
//  NSString+ZRExt.m
//
//  Created by ZR on 14-8-7.
//  Copyright (c) 2014年 ZR. All rights reserved.
//

#import "NSString+ZRExt.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

- (NSString*) MD5 {
	unsigned int outputLength = CC_MD5_DIGEST_LENGTH;
	unsigned char output[outputLength];
	
	CC_MD5(self.UTF8String, [self UTF8Length], output);
	return [[self toHexString:output length:outputLength] uppercaseString];;
}

- (unsigned int) UTF8Length {
	return (unsigned int) [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*) toHexString:(unsigned char*) data length: (unsigned int) length {
	NSMutableString* hash = [NSMutableString stringWithCapacity:length * 2];
	for (unsigned int i = 0; i < length; i++) {
		[hash appendFormat:@"%02x", data[i]];
		data[i] = 0;
	}
	return hash;
}

@end



@implementation NSString (SHA)

- (NSString*) SHA1 {
	unsigned int outputLength = CC_SHA1_DIGEST_LENGTH;
	unsigned char output[outputLength];
	
	CC_SHA1(self.UTF8String, [self UTF8Length], output);
	return [self toHexString:output length:outputLength];;
}

- (NSString*) SHA256 {
	unsigned int outputLength = CC_SHA256_DIGEST_LENGTH;
	unsigned char output[outputLength];
	
	CC_SHA256(self.UTF8String, [self UTF8Length], output);
	return [self toHexString:output length:outputLength];;
}

- (unsigned int) UTF8Length {
	return (unsigned int) [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*) toHexString:(unsigned char*) data length: (unsigned int) length {
	NSMutableString* hash = [NSMutableString stringWithCapacity:length * 2];
	for (unsigned int i = 0; i < length; i++) {
		[hash appendFormat:@"%02x", data[i]];
		data[i] = 0;
	}
	return hash;
}

@end



@implementation NSString (OAURLEncodingAdditions)

- (NSString *)URLEncodeString
{
    //同：stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
                                                                           NULL,
                                                                           kCFStringEncodingUTF8));
//    [result autorelease];
    return result;
}

- (NSString *)URLEncodeStringByLegalCharacters
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8));
//    [result autorelease];
    return result;
}

- (NSString *)URLDecodeString
{
    NSString*result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                          (CFStringRef)self,
                                                                                          CFSTR(""),
                                                                                          kCFStringEncodingUTF8));
//    [result autorelease];
    return result;
}

@end




@implementation NSString (Common)

- (NSString *)trim
{
    //去除前后空格和换行符
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return str;
}

- (BOOL)isEmpty
{
    NSString *trimStr = [self trim];
    if ([trimStr length] == 0)
    {
        return YES;
    }
    
    return NO;
}

@end




@implementation NSString (TimeShow)

- (NSString *)getFormatTimeShow
{
    if ([self isEmpty])
    {
        return @"";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
    NSDate *senderDate = [dateFormatter dateFromString:self];
    
    //得到相差秒数
    NSTimeInterval time = [currentDate timeIntervalSinceDate:senderDate];
    
    NSInteger months = ((NSInteger)time)/(3600*24*30);
    NSInteger days = ((NSInteger)time)%(3600*24*30)/(3600*24);
    NSInteger hours = ((NSInteger)time)%(3600*24)/3600;
    NSInteger minute = ((NSInteger)time)%3600/60;
    
    NSString *dateContent = @"";
    
    if (months > 0)
    {
        if (months >= 12)
        {
            dateContent = [NSString stringWithFormat:@"%@年前", @(months/12)];
        }
        else
        {
            dateContent = [NSString stringWithFormat:@"%@个月前", @(months)];
        }
    }
    else if (days > 0)
    {
        dateContent = [NSString stringWithFormat:@"%@天前", @(days)];
    }
    else if(hours > 0)
    {
        dateContent = [NSString stringWithFormat:@"%@小时前", @(hours)];
    }
    else if(minute > 0)
    {
        dateContent = [NSString stringWithFormat:@"%@分钟前", @(minute)];
    }
    else
    {
        dateContent = @"刚刚";
    }
    
    return dateContent;
}

@end



