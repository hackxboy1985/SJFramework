//
//  GMTextView.m
//  Guamu
//
//  Created by chenxuefang on 15/1/24.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "GMTextView.h"

@implementation GMTextView
@synthesize placeHoldLabel = _placeHoldLabel;

//设置文字内容
- (void)setText:(NSString *)text
{
    [super setText:text];
}


//设置文字的字体
-(void)setTextFont:(UIFont *)font
{
    [super setFont:font];
}

- (void)setContentOffset:(CGPoint)s
{
    if (self.tracking || self.decelerating)
    {
        //initiated by user...
        self.contentInset = UIEdgeInsetsZero;
    }
    else
    {
        float bottomOffset = (self.contentSize.height - self.frame.size.height + self.contentInset.bottom);
        if (s.y < bottomOffset && self.scrollEnabled)
        {
            self.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
        }
        else
        {
            s = CGPointMake(0, 2);
        }
    }
    
    [super setContentOffset:s];
}

- (void)setContentInset:(UIEdgeInsets)s
{
    UIEdgeInsets insets = s;
    if (s.bottom > 6)
    {
        insets.bottom = 0;
    }
    insets.top = 0;
    
    [super setContentInset:insets];
}


-(void)setIsShowPlaceHolder:(BOOL)isShowPlaceHolder
{
    if(_isShowPlaceHolder == isShowPlaceHolder && _isShowPlaceHolder == NO)
        return;
    
    _isShowPlaceHolder = isShowPlaceHolder;
    
    if(_placeHoldLabel)
    {
        [_placeHoldLabel setHidden:!_isShowPlaceHolder];
    }
    
    if(_isShowPlaceHolder)
    {
        CGRect pFrame = self.bounds;
        pFrame.origin.x += 10;
        pFrame.size.width -= 10;
        pFrame.size.height = 30;
        [_placeHoldLabel setFrame:pFrame];
        [_placeHoldLabel setHidden:NO];
    }
}

- (void)createPlaceHolder
{
    if(_placeHoldLabel == nil)
    {
        CGRect pFrame = self.bounds;
        pFrame.origin.x += 10;
        pFrame.size.width -= 10;
        pFrame.size.height = 30;
        _placeHoldLabel = [[UILabel alloc] initWithFrame:pFrame];
        [_placeHoldLabel setTextColor:[UIColor lightGrayColor]];
        [_placeHoldLabel setBackgroundColor:[UIColor clearColor]];
        [_placeHoldLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_placeHoldLabel];
        _isShowPlaceHolder = YES;
    }
}

-(void)setPlaceHolder:(NSString*)text
{
    [self createPlaceHolder];
    [_placeHoldLabel setText:text];
}

-(void)setPlaceHolderColor:(UIColor*)color
{
    _placeHoldLabel.textColor = color;
}

//设置默认的文字的字体
-(void)setPlaceHolderFont:(UIFont *)font
{
    [self createPlaceHolder];
    [_placeHoldLabel setFont:font];
}

// 求最大高度
-(CGFloat)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines
{
    NSMutableString *newLines = [NSMutableString string];
    if (maxNumberOfLines == 1) {
        [newLines appendString:@"-"];
    }
    else {
        for (int i = 1; i < maxNumberOfLines; i++) {
            [newLines appendString:@"\n"];
        }
    }
    
    CGSize size = [newLines sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return  size.height;
}


//默认一行，暂不处理
-(CGFloat)setMinNumberOfLines:(NSUInteger)minNumberOfLines
{
    return self.contentSize.height;
}

@end
