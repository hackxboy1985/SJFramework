//
//  Debug_ios.h
//  FetionUtil
//
//  Created by Born on 14-2-27.
//  Copyright (c) 2014年 FetionUtil. All rights reserved.
//


#ifndef __DEBUG_IOS__
#define __DEBUG_IOS__
//////////////////////////////////////////////////////////////////////////
#ifdef __cplusplus
extern "C"{
#endif
//////////////////////////////////////////////////////////////////////////
//
#if defined(__APPLE__)
#  define FT_PLATFORM_IOS
	
#if defined(__cplusplus)
#  define FT_API
#else
#  define FT_API
#endif
	
#if !defined(FT_INLINE)
#if defined(__GNUC__)
#define FT_INLINE static __inline__ __attribute__((always_inline))
#elif defined(__MWERKS__) || defined(__cplusplus)
#define FT_INLINE static inline
#elif defined(_MSC_VER)
#define FT_INLINE static __inline
#elif TARGET_OS_WIN32
#define FT_INLINE static __inline__
#endif
#endif
    
#define FT_PRETTY_FUNCTION_NAME __PRETTY_FUNCTION__
    
#endif
//////////////////////////////////////////////////////////////////////////
    
    
typedef struct ft_func_tracer
{
    bool  dumpTracking;
    const char * m_funcname;
    u_int32_t m_BeginTime;
#ifdef FT_PLATFORM_WIN32
    unsigned int m_BeginThreadTime;
#endif
}ft_func_tracer;

FT_API void ft_func_tracer_begin(ft_func_tracer* ft,const char * funcname);
FT_API void ft_func_tracer_end(ft_func_tracer* ft);
    
FT_API void ft_func_tracer_time_begin(ft_func_tracer* ft, const char * desc);
FT_API void ft_func_tracer_time(ft_func_tracer* ft, const char * format,...);
FT_API void ft_func_tracer_time_end(ft_func_tracer* ft);
    
FT_API void __ft_assert_va(int idx,const char *filename,int linenumber,const char * exp,...);
FT_API void __ft_assert(int idx,const char *filename,int linenumber,const char * exp);



#ifdef DEBUG
#//assert
#   if defined(assert)
#       undef assert
#       define assert(e)
#   endif
#
#//NSParameterAssert
#   if defined(NSParameterAssert)
#       undef NSParameterAssert
#       define NSParameterAssert(e)        __FT_ASSERT(e,#e)
#   endif
#
#//NSAssert
#   if defined(NSAssert)
#       undef NSAssert
#   define NSAssert(condition, desc, ...)	{if(!(condition)) {__ft_assert_va(0,FT_PRETTY_FUNCTION_NAME, __LINE__, [desc UTF8String], ##__VA_ARGS__);}}
#   endif
#
#	if defined(FT_PLATFORM_SYMBIAN)
#		define __FT_ASSERT(e,des)       {if(!(e)) {__ft_assert(0,__FILE__, __LINE__, #des);assert(0);exit(-1);}}
#	else
#		define __FT_ASSERT(e,des)       {if(!(e)) {__ft_assert(0,FT_PRETTY_FUNCTION_NAME, __LINE__, #des);}}
#	endif
#
#	define __FT_VERIFY(e,des)   __FT_ASSERT(e,des)
#	define __FT_TODO(des)       __ft_assert(0,FT_PRETTY_FUNCTION_NAME, __LINE__, "TODO: you must implement this function!!!"#des)
#	define __FT_TODO_EX(des)    __ft_assert(0,FT_PRETTY_FUNCTION_NAME, __LINE__, "TODO:"#des)
#
#	define __FT_FUNC_TRACE_BEGIN()	ft_func_tracer _ft_func_tracer_obj5ytfqt5w545u6hga;ft_func_tracer_begin(&_ft_func_tracer_obj5ytfqt5w545u6hga,FT_PRETTY_FUNCTION_NAME)
#	define __FT_FUNC_TRACE_END()    ft_func_tracer_end(&_ft_func_tracer_obj5ytfqt5w545u6hga)
#
#	define __FT_FUNC_TRACE_BEGIN_EX(i)	ft_func_tracer _ft_func_tracer_obj5ytfqt5w545u6hga_##i;ft_func_tracer_begin(&_ft_func_tracer_obj5ytfqt5w545u6hga_##i,FT_PRETTY_FUNCTION_NAME)
#	define __FT_FUNC_TRACE_END_EX(i)    ft_func_tracer_end(&_ft_func_tracer_obj5ytfqt5w545u6hga_##i)
#
#else
#
#//assert
#   if defined(assert)
#       undef assert
#       define assert(e)
#   endif
#
#//NSParameterAssert
#   if defined(NSParameterAssert)
#       undef NSParameterAssert
#       define NSParameterAssert(e)
#   endif
#
#
#//NSAssert
#   if defined(NSAssert)
#       undef NSAssert
#       define NSAssert(condition, desc, ...)
#   endif
#
#	define __FT_ASSERT(e,des)  	((void)0)
#	define __FT_VERIFY(e,des)  	(e)
#	define __FT_TODO(des)
#   define __FT_TODO_EX(des)
#	define __FT_FUNC_TRACE_BEGIN()
#	define __FT_FUNC_TRACE_END()
#	define __FT_FUNC_TRACE_BEGIN_EX(i)
#	define __FT_FUNC_TRACE_END_EX(i)
#endif


    

    

    
//////////////////////////////////////////////////////////////////////////
#ifdef __cplusplus
}
#endif
//////////////////////////////////////////////////////////////////////////

#endif