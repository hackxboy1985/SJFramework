//
//  UIView+Frame.m
//  TESTDEMO
//
//  Created by wangpo on 15/3/24.
//  Copyright (c) 2015年 chinasofti. All rights reserved.
//

#import "UIView+Frame.h"

CGFloat getLabelTextWidth(UILabel* label)
{
    NSDictionary *attribute = @{NSFontAttributeName: label.font};
    CGSize boundSize = CGSizeMake(200, 33);
    CGSize size = [label.text boundingRectWithSize:boundSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size.width;
}

@implementation UIView (Frame)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

-(void)showBounds{
    self.layer.borderWidth = 1.f;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

@end





@implementation UILabel (Frame)

+(CGFloat) getTextWidthWithString:(NSString*)text font:(UIFont*)font
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize boundSize = CGSizeMake(180, 1000);
    CGSize size = [text boundingRectWithSize:boundSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size.width;
}


-(CGFloat) getTextWidth
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    CGSize boundSize = CGSizeMake(200, 33);
    CGSize size = [self.text boundingRectWithSize:boundSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size.width;
}
@end
