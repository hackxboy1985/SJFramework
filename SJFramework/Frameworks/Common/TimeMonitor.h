//
//  TimeMonitor.h
//  User
//
//  Created by born on 15/12/25.
//  Copyright (c) 2015年 Hkzr All rights reserved.
//

#import "Debug_ios.h"



/**< 函数跟踪，结束时会打印出函数调用时间*/
#define FT_BEGIN()  __FT_FUNC_TRACE_BEGIN() /**< 函数跟踪开始*/
#define FT_END()    __FT_FUNC_TRACE_END()   /**< 函数跟踪结束*/

#define FT_BEGIN_EX(i)  __FT_FUNC_TRACE_BEGIN_EX(i) /**< 函数跟踪开始*/
#define FT_END_EX(i)    __FT_FUNC_TRACE_END_EX(i)   /**< 函数跟踪结束*/
