//
//  QUCommon.m
//
//  Created by ZR on 14-3-5.
//  Copyright (c) 2014年 ZR. All rights reserved.
//

#import "QUCommon.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define MB_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define MB_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif

@implementation QUCommon

+ (NSString *)getRand:(NSString *)source length:(int)length
{
    NSMutableString *string = [[NSMutableString alloc] init];
	srand((unsigned int)time(0));
	for (int i = 0; i < length; i++)
	{
		unsigned index = rand() % [source length];
		NSString *s = [source substringWithRange:NSMakeRange(index, 1)];
		[string appendString:s];
	}
    
    return string;
}


+ (NSString *)stringWithUUID
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}


+ (BOOL)openBrowser:(NSString*)url
{
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


+ (BOOL)openTelephone:(NSString*)telephoneNumber
{
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",telephoneNumber]]];
}


+ (BOOL)openSMS:(NSString*)smsTo
{
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",smsTo]]];
}


+ (BOOL)openEmail:(NSString*)mailTo
{
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",mailTo]]];
}


+ (BOOL)openAppStore:(NSString*)appId
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&amp;mt=8",appId]];
    return [[UIApplication sharedApplication] openURL:url];
}

+(BOOL)judgePassWordLegal:(NSString *)pass{
    BOOL result = false;
    if ([pass length] >= 6){
        // 判断长度大于6位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
}
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    // 简单判断
    if ([mobileNum hasPrefix:@"1"] && mobileNum.length == 11)
    {
        unichar c;
        for (int i = 0; i < mobileNum.length; i++)
        {
            c = [mobileNum characterAtIndex:i];
            if (!isdigit(c))
            {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

+ (CGSize)getTextSize:(NSString*)text withFontSize:(CGFloat)font maxWidth:(CGFloat)width
{
    CGSize contentSize = MB_MULTILINE_TEXTSIZE(text, [UIFont systemFontOfSize:font], CGSizeMake(width, CGFLOAT_MAX), NSLineBreakByWordWrapping);
    
    //CGSize contentSize =  [text sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    return contentSize;
}


@end
