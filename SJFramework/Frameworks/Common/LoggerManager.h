//
//  LoggerManager.h
//  myLog
//
//  Created by wFeng on 13-8-14.
//  Copyright (c) 2013年 vsignsoft. All rights reserved.
//

#import <Foundation/Foundation.h>



/**
 * @brief 日志级别
 */
typedef enum LogLevel
{
	LogLevel_Debug = 0, /**< 调试级日志*/
	LogLevel_Info,      /**< 信息级日志*/
	LogLevel_Warn,      /**< 警告级日志*/
	LogLevel_Error,     /**< 错误级日志*/
    LogLevel_None,      /**< 适用于无级别的log，比如给模块log使用或者希望输出原始数据*/
}eLogLevel;



@interface LoggerManager : NSObject

+(LoggerManager*)getInstance;
+(void)startLogThread;

@end


//-----------------------------------

#ifdef __cplusplus
extern "C" {
#endif
	
void __writeLog(const char* file,
			  const int line,
			  const char* function,
			  eLogLevel logLevel,
			  const char* format, ...);
	
    /**
     * @brief 非级别log，通常用于模块log,此函数只将消息内容做为参数即可,格式由调用函数自行处理
     */
void __model_writeLog(const char* content);
#ifdef __cplusplus
}
#endif


