//
//  NSDictionary+ZRExt.h
//
//  Created by ZR on 14-3-22.
//  Copyright (c) 2014年 ZR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (String)

//如果找不到，返回@"" (防止出现nil，使程序崩溃)
- (NSString *)stringForKey:(id)aKey;

- (NSString *)stringForKey:(id)aKey withDefaultValue:(NSString *)defValue;

//替换&nbsp;为@" "
- (NSString *)replaceNBSPforKey:(id)aKey ;


@end


@interface NSDictionary (Unicode)

/**
 * @brief 支持中文输出
 */
- (NSString*)unicodeDesc;

@end
