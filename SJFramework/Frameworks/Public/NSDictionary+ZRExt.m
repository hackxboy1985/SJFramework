//
//  NSDictionary+ZRExt.m
//
//  Created by ZR on 14-3-22.
//  Copyright (c) 2014年 ZR. All rights reserved.
//

#import "NSDictionary+ZRExt.h"

@implementation NSDictionary (String)

- (NSString*) stringForKey:(id)aKey
{
    return [self stringForKey:aKey withDefaultValue:@""];
}

- (NSString *)stringForKey:(id)aKey withDefaultValue:(NSString *)defValue
{
    NSString *value = [self objectForKey:aKey];
    if (value == nil || [value isKindOfClass:[NSNull class]])
    {
        value = defValue;
    }
    return [NSString stringWithFormat:@"%@",value];
}

-(NSString*)replaceNBSPforKey:(id)aKey
{
    NSString *value = [self objectForKey:aKey];
    if (!value)
    {
        value = @"";
    }
    
    NSString* str = [value stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "] ;
    
    return [NSString stringWithFormat:@"%@",str];
}


@end
