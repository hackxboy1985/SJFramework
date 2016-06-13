//
//  log.h
//  myLog
//
//  Created by wFeng on 13-8-14.
//  Copyright (c) 2013年 vsignsoft. All rights reserved.
//

#ifndef FetionUtil_Log_h
#define FetionUtil_Log_h

#include "LoggerManager.h"
#import "DistributeConfig.h"




#ifdef DistributeConfig_Log
//#define CLOSE_CONSOLE_LOG //开启时，将关闭真机界面log
//#define TraceDBExecution//开启时，将打印数据库操作相关日志
#endif


#ifdef DistributeConfig_Performance
#define FTPERFORMANCETEST //性能测试开关
#endif


/****************************************************************************
 *
 * Description: 分级日志方法，日志将会写入文件.   文件路径:(document/log/)
 *              日志共分4级:Debug用于调试,Info用于信息输出,Warn用于警告,Error用于错误
 *
 * Use-case:    使用c语言格式化输出，而不是oc格式化输出(即不使用@"")
 *              DebugLog("state:%d",5);//正确
 *              DebugLog(@"state:%d",5);//错误
 *
 * Modification Log:
 *   DATE       AUTHOR           DESCRIPTION
 *---------------------------------------------------------------------------
 * 2011-09-21   wangf        Initial Release
 ****************************************************************************/



#ifdef DEBUG//真机联调

#define DebugLog(format, ...)	__writeLog(__FILE__, __LINE__, __FUNCTION__, LogLevel_Debug, format, ##__VA_ARGS__);
#define InfoLog(format, ...)	__writeLog(__FILE__, __LINE__, __FUNCTION__, LogLevel_Info, format, ##__VA_ARGS__);
#define WarnLog(format, ...)	__writeLog(__FILE__, __LINE__, __FUNCTION__, LogLevel_Warn, format, ##__VA_ARGS__);
#define ErrorLog(format, ...)	__writeLog(__FILE__, __LINE__, __FUNCTION__, LogLevel_Error, format, ##__VA_ARGS__);

#else

#ifndef DistributeConfig_Log//发布AppStore

#define DebugLog(format, ...)
#define InfoLog(format, ...)
#define WarnLog(format, ...)
#define ErrorLog(format, ...)   __writeLog(__FILE__, __LINE__, __FUNCTION__, LogLevel_Error, format, ##__VA_ARGS__);

#else//打包测试

#define DebugLog(format, ...)	__writeLog(__FILE__, __LINE__, __FUNCTION__, LogLevel_Debug, format, ##__VA_ARGS__);
#define InfoLog(format, ...)    __writeLog(__FILE__, __LINE__, __FUNCTION__, LogLevel_Info, format, ##__VA_ARGS__);
#define WarnLog(format, ...)
#define ErrorLog(format, ...)	__writeLog(__FILE__, __LINE__, __FUNCTION__, LogLevel_Error, format, ##__VA_ARGS__);

#endif

#endif



//#include "ModuleLog.h"




/****************************************************************************
 *
 * Description: 分模块日志方法，会在XCode控制台显示. 如果CLOSE_CONSOLE_LOG宏未被定义，
                则日志将在手机屏幕的log界面显示,如果该宏定义了,则关闭手机屏幕的log界面功能.
 *
 *
 * Use-case:    使用oc语言格式化输出;(使用@"")
 *              LOGIN_LOG(@"state:%d",5);//正确
 *              LOGIN_LOG("state:%d",5);//错误
 *
 * Modification Log:
 *   DATE       AUTHOR           DESCRIPTION
 *---------------------------------------------------------------------------
 * 2014-01-17   shijia        Initial Release
 ****************************************************************************/

#ifdef DistributeConfig_Log

#define vLOG(...) vNSLog(__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//通用log
#define COMMON_LOG(...) ConsoleLogEx(COMMON_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//内存相关log
#define MEM_LOG(...) ConsoleLogEx(MEM_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//登录相关log
#define LOGIN_LOG(...) ConsoleLogEx(LOGIN_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//联系人相关log
#define CONTACT_LOG(...) ConsoleLogEx(CONTACT_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//群讨论组相关log
#define PDGROUP_LOG(...) ConsoleLogEx(PDGROUP_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//公众平台相关log
#define PP_LOG(...) ConsoleLogEx(PP_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//消息相关log
#define MSG_LOG(...) ConsoleLogEx(MSG_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//数据库相关log
#define DB_LOG(...) ConsoleLogEx(DB_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//文件相关log
#define FILE_LOG(...) ConsoleLogEx(FILE_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//更多相关log
#define MORE_LOG(...) ConsoleLogEx(MORE_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//二维码相关log
#define BARCODE_LOG(...) ConsoleLogEx(MORE_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//随心议相关log
#define MEETCALL_LOG(...) ConsoleLogEx(MORE_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//家庭网相关log
#define HOMENETWORK_LOG(...) ConsoleLogEx(MORE_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//通用版家庭网相关log
#define VNET_LOG(...) ConsoleLogEx(VNET_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//皮肤字体相关log
#define THEME_LOG(...)  ConsoleLogEx(THEME_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//上传下载相关log
#define DOWNLOAD_LOG(...) ConsoleLogEx(DOWNLOAD_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//短信sms相关log
#define SMS_LOG(...)     ConsoleLogEx(SMS_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//音视频媒体相关log
#define MEDIA_LOG(...)   ConsoleLogEx(MEDIA_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//消息列表消息合子相关log
#define MSGBOX_LOG(...)     ConsoleLogEx(MSGBOX_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//注册相关log
#define REGIST_LOG(...)     ConsoleLogEx(REGIST_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//通讯录log
#define ADDRESSBOOK_LOG(...) ConsoleLogEx(ADDRESSBOOK_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)
//AMS相关log
#define AMS_LOG(...)        ConsoleLogEx(AMS_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//彩云收藏相关log
#define CLOUD_LOG(...)      ConsoleLogEx(CLOUD_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

#define BESIDE_LOG(...)     ConsoleLogEx(BESIDE_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//GMS相关log
#define GMS_LOG(...)        ConsoleLogEx(GMS_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

#define EMSHOP_LOG(...)      ConsoleLogEx(EMSHOP_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

//功能引导相关log
#define FUNCTIONGUIDE_LOG(...) ConsoleLogEx(FUNCTIONGUIDE_LOG,__FILE__,__FUNCTION__,__LINE__,__VA_ARGS__)

#else //打包测试

#define vLOG(...)

#define COMMON_LOG(...)

#define MEM_LOG(...)

#define LOGIN_LOG(...)

#define CONTACT_LOG(...)

#define PDGROUP_LOG(...)

#define PP_LOG(...)

#define MSG_LOG(...)

#define DB_LOG(...)

#define FILE_LOG(...)

#define MORE_LOG(...)

#define BARCODE_LOG(...)

#define MEETCALL_LOG(...)

#define HOMENETWORK_LOG(...)

#define VNET_LOG(...)

#define THEME_LOG(...)

#define DOWNLOAD_LOG(...)

#define SMS_LOG(...)

#define MEDIA_LOG(...)

#define MSGBOX_LOG(...)

#define REGIST_LOG(...)

#define ADDRESSBOOK_LOG(...)

#define AMS_LOG(...)

#define GMS_LOG(...)

#define CLOUD_LOG(...)

#define BESIDE_LOG(...)

#define EMSHOP_LOG(...)

#define FUNCTIONGUIDE_LOG(...)

#endif






#include "Debug_ios.h"

//////////////////////////////////////////////////////////////////////////
//代码中使用以下相关［断言宏］及［跟踪宏］, 使用C格式，非OC格式.
//////////////////////////////////////////////////////////////////////////
#define FT_ASSERT(e)        __FT_ASSERT(e,#e)       /**< 断言,e为判断表格式*/
#define FT_ASSERT_EX(e,des) __FT_ASSERT(e,des)      /**< 断言,e为判断表格式,des为相应描述,C字符串*/
#define FT_VERIFY(e,des)    __FT_ASSERT(e,des)      /**< 验证,等同断言*/
#define FT_TODO(des)        __FT_TODO(des);         /**< TODO断言*/
#define FT_TODO_EX(des)     __FT_TODO_EX(des);      /**< TODO断言,带描述*/


/**< 函数跟踪，结束时会打印出函数调用时间*/
#define FT_BEGIN()  __FT_FUNC_TRACE_BEGIN() /**< 函数跟踪开始*/
#define FT_END()    __FT_FUNC_TRACE_END()   /**< 函数跟踪结束*/

#define FT_BEGIN_EX(i)  __FT_FUNC_TRACE_BEGIN_EX(i) /**< 函数跟踪开始*/
#define FT_END_EX(i)    __FT_FUNC_TRACE_END_EX(i)   /**< 函数跟踪结束*/

#define FT_DISCARD_API                      /**< 已经弃用或过期的api申明*/
//////////////////////////////////////////////////////////////////////////




#endif // FetionUtil_FtLog_h


