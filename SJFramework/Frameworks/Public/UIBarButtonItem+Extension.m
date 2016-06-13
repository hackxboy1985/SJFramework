

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

//自定义导航栏的按钮(button)的样式
+ (instancetype)itemWithImageName:(NSString*)imageName target:(id)target action:(SEL)action
{

    UIButton* button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted", imageName]] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //设置button的大小
    [button sizeToFit];

    //设置button的点击事件(必须设置,要不然用这个方法创建的button没有点击事件)
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

//自定义导航栏的"返回按钮"
+ (instancetype)itemWithImageName:(NSString*)imageName title:(NSString*)title target:(id)target action:(SEL)action
{

    UIButton* button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted", imageName]] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];

    //设置button的title
    [button setTitle:title forState:UIControlStateNormal];
    //设置title不同状态下的颜色
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    //设置button的大小(根据内容调整大小)
    [button sizeToFit];
    

    //设置button的点击事件(必须设置,要不然用这个方法创建的button没有点击事件)
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

//只有文字
+ (instancetype)itemWithTitle:(NSString*)title target:(id)target action:(SEL)action
{
    
    UIButton* button = [[UIButton alloc] init];
    
    //设置button的title
    [button setTitle:title forState:UIControlStateNormal];
    
    //设置button的大小(根据内容调整大小)
    [button sizeToFit];
    //设置title不同状态下的颜色
    //[button setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //设置button的点击事件(必须设置,要不然用这个方法创建的button没有点击事件)
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
