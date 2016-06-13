//
//  BaseTabbarController.h
//  BreakFast
//
//  Created by Born on 15/8/1.
//  Copyright (c) 2015年 Hkzr All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "QUDefines.h"

@class BaseNavigationViewController;
@interface BaseTabbarController : UITabBarController


@property (nonatomic, strong) NSMutableArray*   naviArray;           //存储导航控制器
@property (nonatomic, strong) UIImage* tabBarBackgroundImage;//背景图片
@property (nonatomic, strong) NSMutableArray* unSelectedImageArray;
@property (nonatomic, strong) NSMutableArray* selectedImageArray;
@property (nonatomic, strong) NSMutableArray* itemBgImageViewArray;
@property (nonatomic, strong) BaseNavigationViewController* currNavi;
@property (nonatomic, assign) NSUInteger  lastSelectedIndex;     // 上一次选中的tabBarItem的index

- (void)setCountWithIndex:(int)index andCount:(NSInteger)count;

//添加tabbar上面所有的navigationController
-(void)initAllNaviController:(NSArray*)navArray titleArray:(NSArray*)titleArray;
//添加tabbar上面所有的navigationController
-(void)initAllNaviController:(NSArray*)vcArray titleArray:(NSArray*)titleArray unSelectedImgArray:(NSArray*)unselectedImgAry selectedImgArray:(NSArray*)selectedImgAry;
#pragma mark - MBProgressHUD

- (void)showLoadingHUDView:(NSString *)title;
- (void)hideLoadingHUDView;
- (void)showToastHUDView:(NSString *)title;
- (void)showToastHUDView:(NSString *)title afterDelay:(NSTimeInterval)delay;
- (void)showHintAlert:(NSString *)message buttonTitle:(NSString *)buttonTitle;

@end
