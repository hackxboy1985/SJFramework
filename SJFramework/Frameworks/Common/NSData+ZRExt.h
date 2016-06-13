//
//  NSData+ZRExt.h
//
//  Created by ZR on 14-8-7.
//  Copyright (c) 2014年 ZR. All rights reserved.
//

#import <Foundation/Foundation.h>

//MD5加密
@interface NSData (MD5)

- (NSData*) MD5;

@end



//SHA加密
@interface NSData (SHA)

- (NSData*) SHA1;
- (NSData*) SHA256;

@end
