//
//  UIView+Frame.h
//  TESTDEMO
//
//  Created by wangpo on 15/3/24.
//  Copyright (c) 2015年 chinasofti. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @brief 获得label显示内容后的宽度，以进行界面适配使用.
 */
CGFloat getLabelTextWidth(UILabel* label);


@interface UIView (Frame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize  size;

-(void)showBounds;
@end


@interface UILabel (Frame)

/**
 * @brief 获得text显示内容后的宽度，以进行界面适配使用.
 */
+(CGFloat) getTextWidthWithString:(NSString*)text font:(UIFont*)font;

/**
 * @brief 获得label显示内容后的宽度，以进行界面适配使用.
 */
-(CGFloat) getTextWidth;

@end