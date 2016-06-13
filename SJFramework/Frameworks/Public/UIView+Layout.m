

#import "UIView+Layout.h"

@implementation UIView (Layout)

-(void)setTop:(CGFloat)top{

    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}
-(CGFloat)top{

    return self.frame.origin.y;
}


-(void)setLeft:(CGFloat)left{

    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}
-(CGFloat)left{

    return self.frame.origin.x;
}


-(void)setButtom:(CGFloat)buttom{

    CGRect frame = self.frame;
    frame.origin.y = buttom - frame.size.height;
    self.frame = frame;
}
-(CGFloat)buttom{

    return self.frame.size.height + self.frame.origin.y;
}

-(void)setRight:(CGFloat)right{

    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame =  frame;
}
-(CGFloat)right{

    return self.frame.size.width + self.frame.origin.x;
}


-(void)setX:(CGFloat)value{

    CGRect frame = self.frame;
    frame.origin.x = value;
    self.frame = frame;
}
-(CGFloat)x{

    return self.frame.origin.x;
}

-(void)setY:(CGFloat)value{

    CGRect frame = self.frame;
    frame.origin.y = value;
    self.frame = frame;
}
-(CGFloat)y{

    return self.frame.origin.y;
}

-(void)setOrigin:(CGPoint)origin{

    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
-(CGPoint)origin{

    return self.frame.origin;
}


-(void)setCenterX:(CGFloat)centerX{

    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
-(CGFloat)centerX{

    return self.center.x;
}

-(void)setCenterY:(CGFloat)centerY{

    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
-(CGFloat)centerY{

    return self.center.y;
}


-(void)setWidth:(CGFloat)width{

    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
-(CGFloat)width{

    return self.frame.size.width;
}

-(void)setHeight:(CGFloat)height{

    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(CGFloat)height{

    return self.frame.size.height;
}


-(void)setSize:(CGSize)size{

    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
-(CGSize)size{

    return self.frame.size;
}

@end


#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)


@implementation UIFont (AdapterUI)

+ (UIFont *)systemFontOfSizeInIphone6:(CGFloat)fontSize{
    
    if(isIPhone5)
        fontSize -= 1;
    
    if(isIPhone6P)
        fontSize += 0.5;
    
    return [UIFont systemFontOfSize:fontSize];
}

@end



