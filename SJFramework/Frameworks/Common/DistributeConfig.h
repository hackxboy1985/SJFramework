//
//  DistributeConfig.h
//  FetionUtil
//
//  Created by guoxiaodong on 14-6-25.
//  Copyright (c) 2014年 FetionUtil. All rights reserved.
//



#warning 提交APPStore时，要将此两行代码打开，关闭Log
//开启时，将关闭所有相关log，【仅限发布APPStore时开启】
//#define DISTRIBUTION_APP


#ifndef DISTRIBUTION_APP
//1.登录环境开关，打开这个宏定义，可以选择环境.【一般测试包】关闭
#define DistributeConfig_Login

//2.性能测试开关。【一般测试包】打开
//#define DistributeConfig_Performance

//3.log日志开关、【一般测试包】打开
#define DistributeConfig_Log
#endif