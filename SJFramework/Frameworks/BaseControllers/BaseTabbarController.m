//
//  BaseTabbarController.m
//  BreakFast
//
//  Created by Born on 15/8/1.
//  Copyright (c) 2015年 Hkzr All rights reserved.
//

#import "BaseTabbarController.h"
#import "BaseNavigationViewController.h"
#import "BaseViewController.h"
#import "AppDelegateExten.h"

#define TabItemWidth 64/*80*/             //每个Item的宽
#define TabItemHeight 49            //每个item的高
#define TabItemImageWidth 22        //item中图片的宽
#define TabItemImageHeight 22       //item中图片的高
//#define TabSideMarginX 26.5
#define TabSideMarginY 5
#define TabSpacing 0

@interface BaseTabbarController ()
{
    BaseNavigationViewController *_fightNav;  //
    BaseNavigationViewController *_orderNav;  //
    BaseNavigationViewController *_myInfoNav;  //
}
@property (nonatomic,strong) MBProgressHUD *loadingHUD;
@property (nonatomic,strong) MBProgressHUD *toastHUD;

@property (nonatomic, strong) UIImageView *badgeView;

@property (nonatomic, strong) CATextLayer *badgeLayer;  // 份数(圆圈)
@end

#define BASE_TAG(i) 9+i

@implementation BaseTabbarController

-(void)dealloc
{
    NSLog(@"%@ dealloced\n", NSStringFromClass(self.class));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//添加tabbar上面所有的navigationController
- (void)initAllNaviController:(NSArray*)vcArray titleArray:(NSArray*)titleArray
{
    self.naviArray = [NSMutableArray array];
    
    int i = 0;
    for (NSString* clsName in vcArray)
    {
        BaseViewController* vc = [[NSClassFromString(clsName) alloc] init];
        vc.title = [titleArray objectAtIndex:i++];//
        BaseNavigationViewController * nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
        [nav setHidesBottomBarWhenPushed:YES];
        [self.naviArray addObject:nav];
    }
    
    [self addAllImagesResource];
    [self setAllViewsToTabbar];
}

// 添加tabbar上面所有的navigationController
- (void)initAllNaviController:(NSArray*)vcArray titleArray:(NSArray*)titleArray unSelectedImgArray:(NSArray*)unselectedImgAry selectedImgArray:(NSArray*)selectedImgAry
{
    self.naviArray = [NSMutableArray array];
    
    int i = 0;
    for (NSString *clsName in vcArray)
    {
        BaseViewController* vc = [[NSClassFromString(clsName) alloc] init];
        vc.title = [titleArray objectAtIndex:i++];//
        BaseNavigationViewController * nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
        [nav setHidesBottomBarWhenPushed:YES];
        [self.naviArray addObject:nav];
    }
    self.unSelectedImageArray = (NSMutableArray*)unselectedImgAry;
    self.selectedImageArray = (NSMutableArray*)selectedImgAry;

    [self addAllImagesResource];
    [self setAllViewsToTabbar];
}


// 加载tabbar上面的资源图片
- (void)addAllImagesResource
{
    self.tabBarBackgroundImage = [UIImage imageNamed:@"tabbar_bg"];
    
    // 每一个item的宽度
    CGFloat itemWidth = self.view.frame.size.width/[self.naviArray count];
    // 每一个item图标离左侧的距离
    CGFloat marginx = (itemWidth - TabItemImageWidth)/2;

//    // 设置小红点
//        self.badgeImageView = [NSMutableArray array];
//        for (int i = 0; i < [self.naviArray count]; i++)
//        {
//            UIImageView* badge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg_prompt_bg"]];
//            badge.frame = CGRectMake(46+TabItemWidth*i, 6, 6, 6);
//            badge.hidden = YES;
//            [self.badgeImageView addObject:badge];
//        }
    
    self.itemBgImageViewArray = [NSMutableArray array];

    //设置tabbar的items图标
    for (int i = 0; i < [self.naviArray count]; i++)
    {
        UIImageView *itemBg  = [[UIImageView alloc] initWithFrame:CGRectMake(marginx + itemWidth * i + TabSpacing * i, TabSideMarginY, TabItemImageWidth, TabItemImageHeight)];
        
        UIImageView *bage = [self drawBadgeView:i];
        
        bage.tag = BASE_TAG(i);
        bage.hidden = YES;
        
        [itemBg addSubview:bage];
        
        [itemBg showBounds];
        
        itemBg.contentMode = UIViewContentModeScaleAspectFit;
        [self.itemBgImageViewArray addObject:itemBg];
    }
}

- (void)setCountWithIndex:(int)index andCount:(NSInteger)count
{

    if (count > 0)
    {
        UIImageView *itemBg  = [self.itemBgImageViewArray objectAtIndex:index];
        
        UIImageView *bage = (UIImageView *)[itemBg viewWithTag:BASE_TAG(index)];
        
        [bage removeFromSuperview];

        bage = [self drawBadgeView:count];
        
        bage.tag = BASE_TAG(index);
        
//        bage.layer.backgroundColor = [UIColor redColor].CGColor;
//        bage.layer.borderWidth = 1;
        
        [itemBg addSubview:bage];
        
        [self.itemBgImageViewArray replaceObjectAtIndex:index withObject:itemBg];
    }
    else
    {
        UIImageView *itemBg  = [self.itemBgImageViewArray objectAtIndex:index];
        
        UIImageView *bage = (UIImageView *)[itemBg viewWithTag:BASE_TAG(index)];
        
        [bage removeFromSuperview];
        
        // [itemBg addSubview:bage];
        
        [self.itemBgImageViewArray replaceObjectAtIndex:index withObject:itemBg];
    }
}

- (UIImageView *)drawBadgeView:(NSUInteger)count
{
    UIImageView *imageView = nil;
    UIImage *image = [UIImage imageNamed:@"msg_prompt_bg"];
    CGFloat top = 0;
    CGFloat bottom = 0;
    CGFloat left = 8.5;
    CGFloat right = 8.5;
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 伸缩后重新赋值
    image = [image resizableImageWithCapInsets:insets];
    UILabel *lable = [[UILabel alloc] init];
    NSString *countStr_ = nil;
    if (count > 99)
    {
        countStr_ = @"99+";
    }
    else
    {
        countStr_ = [NSString stringWithFormat:@"%ld",count];
    }
    CGSize size = [countStr_ sizeWithFont:[UIFont systemFontOfSize:10.0]];
    // CGSize size = [countStr_ sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    CGFloat width_ = size.width + 8.0;
    if (width_ < 16.0)
    {
        width_ = 16.0;
    }
    CGRect imageViewFream = CGRectMake(20, 0, width_, 16.0f);
    imageView = [[UIImageView alloc] initWithImage:image];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.frame = imageViewFream;
    lable.frame = CGRectMake(0, 0, imageViewFream.size.width, imageViewFream.size.height);
    lable.text = countStr_;
    lable.font = [UIFont systemFontOfSize:10.0];
    lable.textColor = [UIColor whiteColor];
    lable.backgroundColor = [UIColor clearColor];
    lable.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:lable];
    return imageView;
}

// 设置视图控件
- (void)setAllViewsToTabbar
{
    // 初始化tabbar的items图表为未选中状态
    for (int i = 0; i < [self.itemBgImageViewArray count]; i++)
    {
        UIImageView *itemBg  = [self.itemBgImageViewArray objectAtIndex:i];
        if(i < self.unSelectedImageArray.count)
            itemBg.image = [self.unSelectedImageArray objectAtIndex:i];
        [self.tabBar addSubview:itemBg];
    }
    
    // 初始化tabbarcontroller控件,会默认调用设置selectedIndex为0
    self.viewControllers = [NSArray arrayWithArray:self.naviArray];
    
    self.tabBar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - TABBARVIEW_HEIGHT, [UIScreen mainScreen].bounds.size.width, TABBARVIEW_HEIGHT);
    //    self.tabBar.clipsToBounds = YES;
    
    // 设置tabbar的背景图
    if(self.tabBarBackgroundImage)
    {
        [self.tabBar setBackgroundImage:self.tabBarBackgroundImage];
    }
    
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -3)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 新消息通知,当有新消息时，会发出此通知，改用了另外种方式，参见asyncConversationFromDB
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCount) name:@"HX_RCV_NEW_MSG" object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)getCount
{
//    NSInteger count = [appDelegate hxGetNewMsgCount];
    //NSInteger count = 1;
    //[self setCountWithIndex:3 andCount:count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 设置上次的选中
- (void)setLastSelectedIndex:(NSUInteger)lastSelectedIndex
{
    if (_lastSelectedIndex != lastSelectedIndex)
    {
        //将上次的选中效果取消
        if(_lastSelectedIndex >= self.itemBgImageViewArray.count)
            NSLog(@"_lastSelectedIndex,操作选中效果图越界.");
        else
        {
            UIImageView *lastSelectedImageView = (UIImageView *)[self.itemBgImageViewArray objectAtIndex:_lastSelectedIndex];
            
            if(_lastSelectedIndex >= self.unSelectedImageArray.count)
                NSLog(@"_lastSelectedIndex,操作未选中效果图越界.");
            else
            {
                lastSelectedImageView.image = [self.unSelectedImageArray objectAtIndex:_lastSelectedIndex];
            }
            
            _lastSelectedIndex = lastSelectedIndex;
        }
    }
}

//设置选中
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    //self.tabBar.selectionIndicatorImage = [UIImage createImageWithColor:[UIColor clearColor] andSize:CGSizeMake(320, 2)];
    [self.currNavi popToRootViewControllerAnimated:NO];
    self.currNavi = [self.naviArray objectAtIndex:selectedIndex];
    [self setSelectedViewController:self.currNavi];
    
    //将上次的选中效果取消
    self.lastSelectedIndex = selectedIndex;
    
    // 将本次的选中效果显示
    UIImageView *selectedImageView = (UIImageView *)[self.itemBgImageViewArray objectAtIndex:selectedIndex];
    
    if(selectedIndex < self.selectedImageArray.count)
        selectedImageView.image = [self.selectedImageArray objectAtIndex:selectedIndex];
    
//    //取消小红点显示
//    if (selectedIndex == KBesideBarItemType) {
//        //        [self setBadgeValue:0 withTabbarType:KBesideBarItemType];
//        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"SHENBIANFIRSTENTER"];
//        [[FTBesideStatus defaultBesideStatus] updateNewBroadcastCount];
//    }
}


#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.selectedIndex = [tabBar.items indexOfObject:item];
    [item setFinishedSelectedImage:nil withFinishedUnselectedImage:nil];
}

#pragma mark - MBProgressHUD

- (void)showLoadingHUDView:(NSString *)title
{
    if (_loadingHUD == nil)
    {
        _loadingHUD = [[MBProgressHUD alloc] initWithView:self.view];
        _loadingHUD.mode = MBProgressHUDModeIndeterminate;
        _loadingHUD.removeFromSuperViewOnHide = NO;
        [self.view addSubview:_loadingHUD];
    }
    
    _loadingHUD.labelText = title;
    [_loadingHUD show:YES];
}

- (void)hideLoadingHUDView
{
    [_loadingHUD hide:YES];
}

- (void)showToastHUDView:(NSString *)title
{
    [self showToastHUDView:title afterDelay:1.5];
}

- (void)showToastHUDView:(NSString *)title afterDelay:(NSTimeInterval)delay
{
    if (_toastHUD != nil)
    {
        [_toastHUD removeFromSuperview];
    }
    
    _toastHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _toastHUD.mode = MBProgressHUDModeText;
    _toastHUD.removeFromSuperViewOnHide = NO;
    [self.view addSubview:_toastHUD];
    _toastHUD.detailsLabelText = title;
    [_toastHUD show:YES];
    [_toastHUD hide:YES afterDelay:delay];
    _toastHUD.alpha = 0.9f;
}


- (void)showHintAlert:(NSString *)message buttonTitle:(NSString *)buttonTitle
{
    if (IOS8_Later)
    {
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleCancel handler:nil];
        
        [alertCtr addAction:firstAction];
        [self presentViewController:alertCtr animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:buttonTitle otherButtonTitles:nil];
        alertView.tag = 521;
        [alertView show];
    }
}

@end
