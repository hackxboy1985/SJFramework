//
//  GMTextView.h
//  Guamu
//
//  Created by chenxuefang on 15/1/24.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMTextView : UITextView

@property(nonatomic,assign)BOOL     isShowPlaceHolder;
@property(nonatomic,strong)UILabel  *placeHoldLabel;

// 求最大高度,返回高度  (备注：计算有误差)
-(CGFloat)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines;

//默认一行，暂不处理，返回高度 (备注：计算有误差)
-(CGFloat)setMinNumberOfLines:(NSUInteger)minNumberOfLines;

//设置文字内容
-(void)setText:(NSString *)text;

//设置文字的字体
-(void)setTextFont:(UIFont *)font;

//设置默认的文字
-(void)setPlaceHolder:(NSString*)text;

//设置默认的文字
-(void)setPlaceHolderColor:(UIColor*)color;
//设置默认的文字的字体
-(void)setPlaceHolderFont:(UIFont *)font;

@end
