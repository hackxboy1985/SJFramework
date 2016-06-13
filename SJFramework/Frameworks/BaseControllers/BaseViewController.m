//
//  BaseViewController.m
//  BreakFast
//
//  Created by Born on 15/8/1.
//  Copyright (c) 2015年 Hkzr All rights reserved.
//

#import "BaseViewController.h"
#import "UIImage+Extend.h"
#import "UIView+Frame.h"
#import "AppDelegateBase.h"

//友盟
#ifdef UMENG_SDK
#import "MobClick.h"
#endif

#define NAVIGATION_VIEW_HEIGHT 44
#define STATUS_BAR_HEIGHT 20

@interface BaseViewController ()
@property (nonatomic,strong) UIButton* leftButton;
@property (nonatomic,strong) MBProgressHUD *loadingHUD;
@property (nonatomic,strong) MBProgressHUD *toastHUD;
@end

@implementation BaseViewController
@synthesize rightButton = _rightButton;
@synthesize leftButton  = _leftButton;



#pragma mark 进入后台时，打印出当前存活的视频

-(void)debugAliveViewController
{
    NSLog(@"进入后台后: %s 界面存活.如果非根视图，请检查泄露!",[[[self class] description] UTF8String]);
}

-(void)dealloc
{
    NSLog(@"%@ dealloced\n", NSStringFromClass(self.class));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[[AppDelegateBase getAppDelegateBase] getViewModelManager] unregisterUIListener:(id<LogicToUICallback>)self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    self.view.backgroundColor = BACKVIEWCOROR;
    self.view.backgroundColor = RGBA(244,245,249,1.0);

    [self setupForDismissKeyboard];//点击空白处，键盘消失
    
    if (IOS7_Later) {
        self.edgesForExtendedLayout = UIRectEdgeNone;//不延伸到bar下面
    }
    
//    [self setIsTransparent:NO];

    //非根视图默认添加返回按钮
    if ([self.navigationController.viewControllers count] > 0
        && self != [self.navigationController.viewControllers objectAtIndex:0])
    {
        //[self setLeftButtonWithImageName:@"titlebar_icon_back" bgImageName:nil];
        [self initNavBarLeftBtnWithNormalImage:nil];
    }
    
    
#ifdef DEBUG //Debug模式下进入后台时，打印出存活的视图.查看是否有泄漏视图.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(debugAliveViewController) name:UIApplicationDidEnterBackgroundNotification object:nil];
#endif
    
}

- (void)setupForDismissKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    
    __weak UIViewController *weakSelf = self;
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [weakSelf.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [weakSelf.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.navigationController.view endEditing:YES];
}


#pragma mark -  navBar
- (void)initNavBarRightBtnWithNormalImage:(NSString *)normalImage highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action
{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightButton setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

///导航栏左边返回按钮
- (void)initNavBarLeftBtnWithNormalImage:(NSString *)normalImage 
{
    NSString* leftTitle = nil;
//#define SHOW_PREVIEW_TITLE //是否显示上级界面标题
#ifdef SHOW_PREVIEW_TITLE
    //获取上级页面的标题
    if(self.navigationController.viewControllers.count>1){
        for(int i = 1; i < self.navigationController.viewControllers.count; i++){
            UIViewController* vc = self.navigationController.viewControllers[i];
            if(vc == self){
                leftTitle = self.navigationController.viewControllers[i-1].title;
                break;
            }
        }
    }
#endif
    
    if(normalImage == NULL)
        normalImage = @"title_bar_back";
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [leftButton setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:normalImage] forState:UIControlStateHighlighted];
    [leftButton setAdjustsImageWhenHighlighted:YES];
    [leftButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    CGFloat offsetX = -20;
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, offsetX, 0, 0)];
//    [leftButton.titleLabel showBounds];
//    [leftButton showBounds];
    if(leftTitle){
        //[leftButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [leftButton setTitle:leftTitle forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [leftButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(-2, -30+offsetX, 0, 0)];
    }
    [leftButton sizeToFit];

    UIBarButtonItem *leftButtonItem;
    leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
//    leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
  
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//系统
- (void)initNavBarRightBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
//自定义
- (void)initCustomNavBarRightBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setTitle:title forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [rightButton sizeToFit];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)initNavBarLeftBtnWithNormalImage:(NSString *)normalImage title:(NSString *)title
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 100, 34)];
    leftView.backgroundColor = [UIColor clearColor];
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7, 20, 20)];
    leftImageView.image = [UIImage imageNamed:normalImage];
    [leftView addSubview:leftImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 60, 34)];
    label.text = title;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14.0];
    [leftView addSubview:label];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = item;
    
}
- (void)setNavBarLeftBtnEnabled:(BOOL)enabled
{
    self.navigationItem.leftBarButtonItem.enabled = enabled;
}

- (void)setNavBarRightBtnEnabled:(BOOL)enabled
{
    self.navigationItem.rightBarButtonItem.enabled = enabled;
}

- (void)setNavBarRightBtnNil
{
    self.navigationItem.rightBarButtonItem = nil;
}


#pragma mark -  导航

//设置navbar的标题
- (void)setStrNavTitle:(NSString *)navTitle
{
    UIView* navTitleView = (self.navigationItem.titleView);
    
    UILabel* titleLabel;
    if([navTitleView isKindOfClass:[UILabel class]])//先要判断是否为label
    {
        titleLabel = (UILabel*)navTitleView;
        titleLabel.text = navTitle;
    }
    else
    {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.text= navTitle;
        self.navigationItem.titleView = titleLabel;
    }
    
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
#define FontName(name,sz) [UIFont fontWithName:name size:sz]
    
    titleLabel.font = FontName(@"STHeitiSC-Medium", 20);//[UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor blackColor];
    [titleLabel sizeToFit];
}


//设置导航可以透明
-(void)setIsTransparent:(BOOL)isTransparent
{
    if (isTransparent)//透明
    {
        [self clearNavigationBar];
    }
    else//不透明
    {
        [self setNavigationBarImage];
    }
}


-(void)setNavigationBarImage
{
    if (SYSTEM_VERSION >=7.0) {
//        UIImage *syncBgImg = [UIImage imageNamed:@"navi_bg5"];
        UIImage *syncBgImg = [UIImage createImageWithColor:[UIColor whiteColor] andSize:CGSizeMake(320, 64)];
        [self.navigationController.navigationBar setBackgroundImage:syncBgImg forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
    else
    {
        UIImage *syncBgImg = [UIImage imageNamed:@"navi_bg"];
        [self.navigationController.navigationBar setBackgroundImage:syncBgImg forBarMetrics:UIBarMetricsDefault];
    }
    
//    if ([UINavigationBar instancesRespondToSelector:@selector(setShadowImage:)])
//    {
//        [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"nav_public_titlebar_bg02"]];
//    }
}

//导航设置为透明
-(void)clearNavigationBar
{
    self.edgesForExtendedLayout = UIRectEdgeAll;

    self.navigationController.view.backgroundColor = [UIColor clearColor];//
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor] andSize:CGSizeMake(320, 64)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];//效果同上行

    //隐藏nav bar底部线
    if ([UINavigationBar instancesRespondToSelector:@selector(setShadowImage:)])
    {
        [self.navigationController.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor clearColor] andSize:CGSizeMake(320, 3)]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"%@ didReceiveMemoryWarning\n", NSStringFromClass(self.class));
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
#ifdef UMENG_SDK
    [MobClick beginLogPageView:self.title];
#endif
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
#ifdef UMENG_SDK
    [MobClick endLogPageView:self.title];
#endif
}


//设置导航左边的button的名称
- (void)setLeftButtonWithName:(NSString*)titleName
{
    UIButton *tmpLightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpLightButton.frame = CGRectMake(0, BUTTONMarginUP, 60, NAVBUTTON_HEIGHT);
    
    tmpLightButton.showsTouchWhenHighlighted = NO;
    tmpLightButton.exclusiveTouch = YES;
    
    [tmpLightButton addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [tmpLightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tmpLightButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [tmpLightButton setTitle:titleName forState:UIControlStateNormal];
    
    [tmpLightButton setTitleColor:RGBA(200, 200, 200,1.0) forState:UIControlStateDisabled];
    
    [tmpLightButton setTitleColor:RGBA(200, 200, 200,1.0) forState:UIControlStateHighlighted];
    
    self.leftButton = tmpLightButton;
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tmpLightButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    if (SYSTEM_VERSION >= 7.0)//左边button的偏移量，从左移动13个像素
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -10;
        [self.navigationItem setLeftBarButtonItems:@[negativeSeperator, leftButtonItem]];
    }
    else
    {
        [self.navigationItem setLeftBarButtonItem:leftButtonItem];
    }
}


//设置导航左边的button的图片名和背景图片名
- (void)setLeftButtonWithImageName:(NSString*)imageName bgImageName:(NSString*)bgImageName
{
    UIButton *tmpLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    tmpLeftButton.frame = CGRectMake(0, BUTTONMarginUP, 19, 35);
    tmpLeftButton.showsTouchWhenHighlighted = NO;
    tmpLeftButton.exclusiveTouch = YES;
    
    if (bgImageName)//设置button的背景
    {
        [tmpLeftButton setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    }
    
    [tmpLeftButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [tmpLeftButton addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    tmpLeftButton.backgroundColor = [UIColor clearColor];
    self.leftButton = tmpLeftButton;
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tmpLeftButton];

    if (SYSTEM_VERSION >= 7.0)//左边button的偏移量，从左移动13个像素
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, BUTTONMarginUP, 50, 20);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.showsTouchWhenHighlighted = NO;
        button.exclusiveTouch = YES;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
//        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];

        
        UIBarButtonItem *leftButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:button];

        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -10;
        [self.navigationItem setLeftBarButtonItems:@[leftButtonItem,leftButtonItem2]];
        
    }
    else
    {
        [self.navigationItem setLeftBarButtonItem:leftButtonItem];
    }
}

//设置导航右边的button的名称

- (void)setRightButtonWithName:(NSString*)imageName
{
    CGSize size;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {

        size = [imageName boundingRectWithSize:CGSizeMake(MAXFLOAT, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0]} context:nil].size;
    }else{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
        
        size = [imageName sizeWithFont:[UIFont systemFontOfSize:20.0] constrainedToSize:CGSizeMake(MAXFLOAT, 44)];
#endif
    }
    if (size.width<60) {
        size.width = 60;
    }
    else
    {
        size.width+=6;
    }
    UIButton *tmpRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpRightButton.frame = CGRectMake(self.view.frame.size.width-NAVBUTTON_WIDTH-BUTTONMarginX, BUTTONMarginUP, size.width, 30);
    
    tmpRightButton.showsTouchWhenHighlighted = NO;
    tmpRightButton.exclusiveTouch = YES;
    
    [tmpRightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //    [tmpRightButton setBackgroundImage:[[UIImage imageNamed:@"publicr_button_title"] stretchableImageWithLeftCapWidth:6 topCapHeight:6] forState:UIControlStateNormal];
    [tmpRightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tmpRightButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [tmpRightButton setTitle:imageName forState:UIControlStateNormal];
    
    //    UIImage* grayImage = [[UIImage imageNamed:@"publicr_button_title_gray"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    //    [tmpRightButton setBackgroundImage:grayImage forState:UIControlStateDisabled];
    [tmpRightButton setTitleColor:RGBA(200, 200, 200,1.0) forState:UIControlStateDisabled];
    
    //[tmpRightButton setBackgroundImage:grayImage forState:UIControlStateHighlighted];
    [tmpRightButton setTitleColor:RGBA(200, 200, 200,1.0) forState:UIControlStateHighlighted];
    
    self.rightButton = tmpRightButton;
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tmpRightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    if (SYSTEM_VERSION >= 7.0)//左边button的偏移量，从左移动13个像素
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -10;
        [self.navigationItem setRightBarButtonItems:@[negativeSeperator, rightButtonItem]];
    }
    else
    {
        [self.navigationItem setRightBarButtonItem:rightButtonItem];
    }
}


-(void)setRightButtonWithStateImage:(NSString*)normaimageName stateHighlightedImage:(NSString*)highlightedImage stateDisabledImage:(NSString*)disabledImage titleName:(NSString*)titleName
{
    UIButton *tmpRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpRightButton.exclusiveTouch = YES;//add by ljj 修改push界面问题
    
    tmpRightButton.frame = CGRectMake(self.view.frame.size.width-NAVBUTTON_WIDTH-BUTTONMarginX, BUTTONMarginUP, NAVBUTTON_WIDTH, NAVBUTTON_HEIGHT);
    if (titleName) {
        [tmpRightButton setTitle:titleName forState:UIControlStateNormal];
        [tmpRightButton setTitle:titleName forState:UIControlStateDisabled];
    }
    tmpRightButton.showsTouchWhenHighlighted = NO;
    [tmpRightButton setImage:[UIImage imageNamed:normaimageName] forState:UIControlStateNormal];
    [tmpRightButton setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    [tmpRightButton setImage:[UIImage imageNamed:disabledImage] forState:UIControlStateDisabled];
    
    [tmpRightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton = tmpRightButton;
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tmpRightButton];
    
    if (SYSTEM_VERSION >= 7.0)//左边button的偏移量，从左移动13个像素
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -10;
        [self.navigationItem setRightBarButtonItems:@[negativeSeperator, rightButtonItem]];
    }
    else
    {
        [self.navigationItem setRightBarButtonItem:rightButtonItem];
    }
}




/*
 * @brief   导航左按钮点击事件
 *          重写此方法可以实现扩展
 */
- (void)leftButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


/*
 * @brief   导航右按钮点击事件
 *          重写此方法可以实现扩展
 */
- (void)rightButtonPressed:(id)sender
{
}

//设置左边按钮的显示or隐藏状态
- (void)setLeftButtonHiden:(BOOL)hiden
{
    if (self.leftButton) {
        [self.leftButton setHidden:hiden];
    }
}


//设置右边按钮的显示or隐藏状态
- (void)setRightButtonHiden:(BOOL)hiden
{
    if (self.rightButton)
    {
        [self.rightButton setHidden:hiden];
    }
}

//设置右边按钮的可用状态
- (void)setRightButtonEnabled:(BOOL)enabled
{
    [self.rightButton setEnabled:enabled];
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    //UIStatusBarStyleLightContent 为白字
//    return UIStatusBarStyleLightContent;
//}

#pragma mark - MBProgressHUD Loading

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

- (void)hideLoadingHUDViewAfterDelay
{
    [_loadingHUD hide:YES afterDelay:1.5];
}

- (void)hideLoadingHUDViewAfterDelay:(float)second
{
    [_loadingHUD hide:YES afterDelay:second];
}

#pragma mark - MBProgressHUD Toast


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

- (void)showHintAlert:(NSString *)message buttonTitle:(NSString *)buttonTitle otherTitle:(NSString *)otherTitle{
    if (IOS8_Later)
    {
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        
        [alertCtr addAction:firstAction];
        [alertCtr addAction:secondAction];
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
