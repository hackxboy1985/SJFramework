//
//  BaseViewController.h
//  BreakFast
//
//  Created by Born on 15/8/1.
//  Copyright (c) 2015年 Hkzr All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "QUDefines.h"

#define BUTTONMarginX    10
#define BUTTONMarginUP   0
#define NAVBUTTON_WIDTH  44
#define NAVBUTTON_HEIGHT 44

@interface BaseViewController : UIViewController

/**
 * @brief 新增回调block，支持3个参数
 */
@property (nonatomic, copy) void(^callbackBlock)(id param1,id param2,id param3);


@property (nonatomic, assign) CGRect currViewRect;

@property (nonatomic,strong)UIButton* rightButton;

- (void)initNavBarRightBtnWithNormalImage:(NSString *)normalImage highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action;
- (void)initNavBarLeftBtnWithNormalImage:(NSString *)normalImage;
//系统
- (void)initNavBarRightBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action;
//自定义
- (void)initCustomNavBarRightBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action;

- (void)initNavBarLeftBtnWithNormalImage:(NSString *)normalImage title:(NSString *)title;
- (void)setNavBarLeftBtnEnabled:(BOOL)enabled;
- (void)setNavBarRightBtnEnabled:(BOOL)enabled;
- (void)setNavBarRightBtnNil;

//设置navbar的标题
- (void)setStrNavTitle:(NSString *)navTitle;

//设置导航可以透明
-(void)setIsTransparent:(BOOL)isTransparent;


//导航左按钮点击事件
- (void)leftButtonPressed:(id)sender;

//导航右按钮点击事件
- (void)rightButtonPressed:(id)sender;

/**
 *	@brief	设置导航左边的button的图片名和背景图片名
 *
 *	@param 	imageName 	button的图片名
 *	@param 	bgImageName 	button的背景图片名
 */
- (void)setLeftButtonWithImageName:(NSString*)imageName bgImageName:(NSString*)bgImageName;

/**
 * 设置导航右边的button的名称
 *
 *  @param name 设置button的名称
 */
- (void)setRightButtonWithName:(NSString*)imageName;


-(void)setRightButtonWithStateImage:(NSString*)normaimageName stateHighlightedImage:(NSString*)highlightedImage stateDisabledImage:(NSString*)disabledImage titleName:(NSString*)titleName;

- (void)setLeftButtonWithName:(NSString*)titleName;

/**
 *	@brief	设置左边按钮的显示or隐藏状态
 *
 *	@param 	hiden 	YES 隐藏 NO 显示
 */
- (void)setLeftButtonHiden:(BOOL)hiden;


/**
 *	@brief	设置右边按钮的显示or隐藏状态
 *
 *	@param 	hiden 	YES 隐藏 NO 显示
 */
- (void)setRightButtonHiden:(BOOL)hiden;

/**
 *  设置右侧按钮是否点击
 *
 *  @param enabled YES 可用   NO 不可用
 */
- (void)setRightButtonEnabled:(BOOL)enabled;


#pragma mark - MBProgressHUD

/**
 *  显示loading提示，需调用hideLoadingHUDView或hideLoadingHUDViewAfterDelay才会消失
 *
 *  @param enabled YES 可用   NO 不可用
 */
- (void)showLoadingHUDView:(NSString *)title;
- (void)hideLoadingHUDView;
- (void)hideLoadingHUDViewAfterDelay;//1秒后才消失
- (void)hideLoadingHUDViewAfterDelay:(float)second;

/**
 *  显示toast提示，1.5秒自动消失
 *
 *  @param enabled YES 可用   NO 不可用
 */
- (void)showToastHUDView:(NSString *)title;
- (void)showToastHUDView:(NSString *)title afterDelay:(NSTimeInterval)delay;
- (void)showHintAlert:(NSString *)message buttonTitle:(NSString *)buttonTitle;
- (void)showHintAlert:(NSString *)message buttonTitle:(NSString *)buttonTitle otherTitle:(NSString*)otherTitle;

//ljp
- (void)setupForDismissKeyboard;
@end
