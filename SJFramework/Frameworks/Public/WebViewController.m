//
//  WebViewController.m
//  User
//
//  Created by born on 15/11/3.
//  Copyright (c) 2015年 chinaisale. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = @"广告链接";
    
    //跳转wap页面.
    CGRect bounds = [[UIScreen mainScreen] bounds];
    UIWebView* webView = [[UIWebView alloc]initWithFrame:bounds];
    webView.height = ViewControllHight;

    if(!self.url || [self.url isKindOfClass:[NSNull class]] || [self.url isEqualToString:@""])
    {
        return;
    }
    //创建NSURLRequest
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [webView loadRequest:request];//加载
    [self.view addSubview:webView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
