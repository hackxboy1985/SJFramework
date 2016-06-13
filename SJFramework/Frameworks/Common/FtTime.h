//
//  FtTime.h
//  FetionUtil
//
//  Created by Born on 14-4-2.
//  Copyright (c) 2014年 FetionUtil. All rights reserved.
//

#ifndef FetionUtil_FTTime_h
#define FetionUtil_FTTime_h

struct ft_time{
    
	u_int16_t year;
	u_int8_t  mon;
	u_int8_t  day;
	u_int8_t  wday;
	
	u_int8_t  hour;
	u_int8_t  min;
	u_int8_t  sec;
	int32_t msec;
};

#ifdef __cplusplus
extern "C"{
#endif
    

    void ft_time_now(struct ft_time *time);

    /**
     *	@brief	获得当前时间,格式:1900-04-19 10:21:12
     *
     *	@param 	 	N/A
     *
     *	@return	返回该格式的时间字符串
     */
    NSString* ft_time_now_str();

    
    
    
#ifdef __cplusplus
}
#endif

#endif
