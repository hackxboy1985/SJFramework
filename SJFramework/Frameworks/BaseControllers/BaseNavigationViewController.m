//
//  BaseNavigationViewController.m
//  BreakFast
//
//  Created by Born on 15/8/1.
//  Copyright (c) 2015年 Hkzr All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

-(void)dealloc
{
    //NSLog(@"%@ dealloced\n", NSStringFromClass(self.class));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setCustomSkin];
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.delegate = self;
}

//设置自定义皮肤
-(void)setCustomSkin
{
    if (SYSTEM_VERSION >=7.0) {
        UIImage *syncBgImg = [UIImage imageNamed:@"navi_bg5"];
        [self.navigationBar setBackgroundImage:syncBgImg forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
    else if (SYSTEM_VERSION >=6.0)
    {
        UIImage *syncBgImg = [UIImage imageNamed:@"navi_bg"];
        [self.navigationController.navigationBar setBackgroundImage:syncBgImg forBarMetrics:UIBarMetricsDefault];    }
    else
    {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_public_titlebar_6bg"] forBarMetrics:UIBarMetricsDefault];
    }
    
    if ([UINavigationBar instancesRespondToSelector:@selector(setShadowImage:)])
    {
        [self.navigationBar setShadowImage:[UIImage imageNamed:@"nav_public_titlebar_bg02"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    // fix 'nested pop animation can result in corrupted navigation bar'
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if(self.childViewControllers.count >= 1){
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if(self.childViewControllers.count >= 1){
        
        if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

@end
