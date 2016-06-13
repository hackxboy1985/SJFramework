//
//  MainViewController.m
//  Doctor
//
//  Created by born on 16/4/25.
//  Copyright © 2016年 ViewHigh. All rights reserved.
//

#import "MainViewController.h"
#import "UIResponder+Router.h"
#import "BaseNavigationViewController.h"
#import "ViewModelManager.h"

@interface MainViewController ()
{
    NSInteger _unreadCount;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupUnreadMessageCount];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - public

- (void)jumpToChatList
{
}

//-(void)postSetupUnreadMessageCount{
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    //刷新未读消息数
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
//    //消息数量改变时
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
//}


// 统计未读消息数
-(void)setupUnreadMessageCount
{
//    NSArray *conversations = [[DeviceDBHelper sharedInstance] getMyCustomSession];
//    NSInteger unreadCount = 0;
//    for (ECSession *conversation in conversations) {
//        unreadCount += conversation.unreadCount;
//    }
//    HomeViewModel* viewModel = [[ViewModelManager getSingleton] getHomeViewModel];
//    HomePatientRequestModel *model = [[viewModel getPatientRequestArray] lastObject];
//    unreadCount += model.msgCount;
//    //增加请求消息未读数
//    //unreadCount += [[[RequestViewController shareController] dataSource] count];
//
//    if(_unreadCount != unreadCount){
//        NSLog(@"设置首页消息数量:%ld",unreadCount);
//        [self setCountWithIndex:0 andCount:unreadCount];
//        
//        UIApplication *application = [UIApplication sharedApplication];
//        [application setApplicationIconBadgeNumber:unreadCount];
//        _unreadCount = unreadCount;
//    }
}

//统计添加好友未读消息
- (void)setupUntreatedApplyCount
{
//    NSInteger unreadCount = [[[RequestViewController shareController] dataSource] count];
//    [self setCountWithIndex:1 andCount:unreadCount];
}



@end
