//
//  Debug_ios.m
//  FetionUtil
//
//  Created by Born on 14-2-27.
//  Copyright (c) 2014年 FetionUtil. All rights reserved.
//

#include "Debug_ios.h"
#include "Log.h"
#include <assert.h>
#include <mach/mach_time.h>
#include <UIKit/UIKit.h>


FT_INLINE FT_API u_int32_t ft_get_tick()
{
	return (u_int32_t)mach_absolute_time()/1000;//微秒级输出
}

FT_API void ft_func_tracer_begin(ft_func_tracer* ft, const char * funcname)
{
    ft->dumpTracking = true;
	ft->m_funcname = funcname;
	DebugLog("[%s] Begin",funcname);
	ft->m_BeginTime = ft_get_tick();
}

FT_API void ft_func_tracer_end(ft_func_tracer* ft)
{
	unsigned int ttt = ft_get_tick()-ft->m_BeginTime;

#ifdef FT_PLATFORM_WIN32
//	unsigned lTime = ft_get_tick() - ft->m_BeginThreadTime;
//	DebugLog("[%s] End [%d][%d]",ft->m_funcname,ttt,(int)lTime);
#elif defined(FT_PLATFORM_SYMBIAN)
//	DebugLog("[%s] End [%d]",ft->m_funcname,ttt);
#elif defined(FT_PLATFORM_IOS)
	DebugLog("[%s] End [%d 微秒 %0.2f毫秒]",ft->m_funcname,ttt, ttt/1000.f);
#endif
}


FT_API void ft_func_tracer_time_begin(ft_func_tracer* ft, const char * desc)
{
    ft->dumpTracking = true;
	ft->m_funcname = desc;
	DebugLog("[%s] Begin",desc);
	ft->m_BeginTime = ft_get_tick();
}

FT_API void ft_func_tracer_time(ft_func_tracer* ft, const char * format,...)
{
    if (ft->dumpTracking == false) {
        return;
    }
	unsigned int ttt = ft_get_tick()-ft->m_BeginTime;
    
#ifdef FT_PLATFORM_WIN32
    //	unsigned lTime = ft_get_tick() - ft->m_BeginThreadTime;
    //	DebugLog("[%s] End [%d][%d]",ft->m_funcname,ttt,(int)lTime);
#elif defined(FT_PLATFORM_SYMBIAN)
    //	DebugLog("[%s] End [%d]",ft->m_funcname,ttt);
#elif defined(FT_PLATFORM_IOS)
    
    NSString* ocFormat = [[NSString alloc] initWithUTF8String:format];

    va_list args;
    va_start(args, format);
    NSString* msgTemp = [[NSString alloc] initWithFormat:ocFormat arguments:args];
    va_end(args);
    
	DebugLog("[%s-%s] End [%d 微秒 %0.2f毫秒]",ft->m_funcname,[msgTemp UTF8String], ttt, ttt/1000.f);
#endif
}

FT_API void ft_func_tracer_time_end(ft_func_tracer* ft)
{
    ft->dumpTracking = false;

}

#ifdef DEBUG
FT_API void __ft_assert_va(int __unused idx,const char *filename,int linenumber,const char * exp,...)
{
    NSString* ocFormat = [[NSString alloc] initWithUTF8String:exp];

    va_list args;
	va_start(args, exp);
    NSString* msgTemp = [[NSString alloc] initWithFormat:ocFormat arguments:args];
	va_end(args);

    __ft_assert(idx,filename,linenumber,msgTemp.UTF8String);
}
FT_API void __ft_assert(int __unused idx,const char *filename,int linenumber,const char * exp)
{
    ErrorLog("\n!!!!!!!!!!!!!!!!!!!assert failed!!!!!!!!!!!!!!!!!!!\n [assert info]:\n%s:%d [%s]\n\n",filename,linenumber,exp);
    usleep(1000);
    Class lnClass = (NSClassFromString(@"UILocalNotification"));
    if(lnClass != nil)
    {
		NSString* s = [NSString stringWithFormat:@"<Line:%d>%s : [%s]",linenumber,filename,exp];
		id ln = [[lnClass alloc] init];
		[ln setAlertBody:s];
		[ln setFireDate:[NSDate dateWithTimeInterval:1 sinceDate:[NSDate date]]];
		[[UIApplication sharedApplication] cancelAllLocalNotifications];
		[[UIApplication sharedApplication] scheduleLocalNotification:ln];
    }
//	assert(0);
	exit(0);
}
#else
FT_API void __ft_assert_va(int __unused idx,const char *filename,int linenumber,const char * exp,...)
{
    ErrorLog("\n!!!!!!!!!!!!!!!!!!!assert failed!!!!!!!!!!!!!!!!!!!\n [assert info]:\n%s:%d [%s]\n\n",filename,linenumber,exp);
}
FT_API void __ft_assert(int idx,const char *filename,int linenumber,const char * exp)
{
    ErrorLog("\n!!!!!!!!!!!!!!!!!!!assert failed!!!!!!!!!!!!!!!!!!!\n [assert info]:\n%s:%d [%s]\n\n",filename,linenumber,exp);
}
#endif



