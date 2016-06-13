//
//  UITextField+ZRLengthLimit.h
//
//  Created by ZR on 14-9-26.
//  Copyright (c) 2014年 ZR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ZRLengthLimit)

/**
 *  限制输入长度
 *
 *  @param limitMax 限制的长度
 *  @param target   action所在的Target（比如***ViewController；不实现action的话，传nil即可）
 *  @param action   超出限制长度触发事件（不需要实现action的话，传nil即可）
 */
- (void)addLengthLimit:(int)limitMax target:(id)target action:(SEL)action;

@end
