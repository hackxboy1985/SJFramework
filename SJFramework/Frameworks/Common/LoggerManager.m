//
//  LoggerManager.m
//  myLog
//
//  Created by wFeng on 13-8-14.
//  Copyright (c) 2013年 vsignsoft. All rights reserved.
//

#import "LoggerManager.h"
#include <sys/stat.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "FtTime.h"
#import "FileUtil.h"

// keys
const NSString* kType		= @"kType";
const NSString* kMsg		= @"kMsg";
const NSString* kDate		= @"kDate";
const NSString* kLevel		= @"kLevel";
const NSString* kThreadName = @"kThreadName";
const NSString* kFile		= @"kFile";
const NSString* kFuncName	= @"kFuncName";

// 20MB
#define MAX_LOG_SIZE 20


static LoggerManager* s_pLoggerManager = nil;


@interface LoggerManager()

@property (nonatomic, retain) NSCondition* signal;
@property (nonatomic, retain) NSMutableArray* queue; // item为NSDictionary; keys:kType、kMsg、kDate、kLevel、kThreadName & kFuncName
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) NSThread* logThread;
//@property (nonatomic, retain) NSDate* day;
@property (nonatomic, retain) NSString* dayString;
@end



@implementation LoggerManager

@synthesize signal = _signal;
@synthesize queue = _queue;
@synthesize index = _index;
@synthesize logThread = _logThread;
//@synthesize day = _day;
@synthesize dayString = _dayString;


-(void)dealloc
{
	[_signal release];
	[_queue release];
	[_logThread release];
//	[_day release];
	[_dayString release];
    
	[super dealloc];
}

+(LoggerManager*)getInstance
{
	@synchronized(self)
	{
		if (nil == s_pLoggerManager)
		{
			[[self alloc] init];
		}
	}
	
	return s_pLoggerManager;
}

+(id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if (nil == s_pLoggerManager)
		{
			s_pLoggerManager = [super allocWithZone:zone];			
			return s_pLoggerManager;
		}
	}
	
	return nil;
}

-(void)initMembers
{
	_signal = [[NSCondition alloc] init];
	_queue = [[NSMutableArray alloc] init];
//	self.day = [NSDate date];
    self.dayString = [self dayString];
}

+(void)startLogThread
{
	LoggerManager* logManager = [LoggerManager getInstance];
	
	if (logManager.logThread == nil)
	{
		[logManager initMembers];
		
		NSThread* logThread = [[NSThread alloc] initWithTarget:logManager selector:@selector(threadProcessWithParam:) object:nil];
		logManager.logThread = logThread;
		[logThread start];
		[logThread release];
		logThread = nil;
	}
	
	return;
}

-(void)threadProcessWithParam:(id)param
{
	do
	{
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		
		for (int i = 0; i < 20; i++)
		{
			[self.signal lock];
			while (0 == [self.queue count])
			{
				[self.signal wait];
			}			
			NSArray* itemList = [NSArray arrayWithArray:self.queue];
			[self.queue removeAllObjects];
			[self.signal unlock];
			
			//
			if ([itemList count] > 0)
			{
				[self logToFile:itemList];
			}
		}
		
		[pool release];
        pool = nil;
        
	} while (YES);
	
	return;
}

-(NSString*)getDayString
{
    return ft_time_now_str();
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//	[formatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
//	NSString* now = [formatter stringFromDate:[NSDate date]];
//	[formatter release];
//	formatter = nil;
//    return now;
}
-(NSString*)getLogFilePath
{
    NSString * log = [[kFileUtil getCachesPath] stringByAppendingPathComponent:@"log"];
    if ([kFileUtil isFileExist:log] == NO)
    {
        [kFileUtil createPath:log];
    }
    
	NSFileManager* fileManager = [NSFileManager defaultManager];
	BOOL isDic = YES;
	if (![fileManager fileExistsAtPath:log isDirectory:&isDic])
	{
		[fileManager createDirectoryAtPath:log
               withIntermediateDirectories:YES
                                attributes:[NSDictionary dictionaryWithObject:NSFileProtectionNone forKey:NSFileProtectionKey]
                                     error:nil];
	}
	if (self.dayString == NULL) {
        self.dayString = [self getDayString];
    }
//	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//	[formatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
//	NSString* now = [formatter stringFromDate:self.day];
//	[formatter release];
//	formatter = nil;
	
	NSProcessInfo* processInfo = [NSProcessInfo processInfo];
	int pId = [processInfo processIdentifier];
	NSString* fileName = [NSString stringWithFormat:@"%@ (%d).log", self.dayString, pId];
	NSString* filePath = [log stringByAppendingPathComponent:fileName];
	
	return filePath;
}

-(void)logToFile:(NSArray*)itemList
{
	//NSArray* logLevelList = @[@"Debug", @"Info", @"Warn", @"Error"];
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

	for (NSDictionary* item in itemList)
	{
		NSString* filePath = [self getLogFilePath];
		
        /*
		NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		NSString* content = [[NSString alloc] initWithFormat:@">> %@ [%@] %@ %@ %@: %@\n",
							 [formatter stringFromDate:[item objectForKey:kDate]],
							 [logLevelList objectAtIndex:[[item objectForKey:kLevel] integerValue]],
							 [item objectForKey:kThreadName],
							 [item objectForKey:kFile],
							 [item objectForKey:kFuncName],
							 [item objectForKey:kMsg]];

		[formatter release];
		formatter = nil;
        */
        NSString* content = [self getContentFromeEntry:item];
		
		// print to screen
		//printf("%s", [content UTF8String]);
		
		// write to file
		FILE* file = fopen([filePath UTF8String], "a+b");
		if (file != NULL)
		{
			NSUInteger contentByteLen = [content lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
			unsigned char* pbyContent = (unsigned char*)malloc(contentByteLen);
			memcpy(pbyContent, [content UTF8String], contentByteLen);
			fwrite(pbyContent, contentByteLen, 1, file);
			fclose(file);
			free(pbyContent);
		}
		
		
		// >= 20MB，新建另一个log文件
		struct stat st;
		if (stat([filePath UTF8String], &st) == 0)
		{
			if (st.st_size >= MAX_LOG_SIZE * 1024 * 1024)
			{
				//_index++;
//				self.day = [NSDate date];
                self.dayString = [self getDayString];
			}
		}
	}
	
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LookLogReFresh" object:nil];
    [pool release];
	return;
}

-(void)appendLogEntry:(NSDictionary*)entry
{
	[self.signal lock];
	[self.queue addObject:entry];
	[self.signal signal];	
	[self.signal unlock];

	return;
}

-(NSString*)getContentFromeEntry:(NSDictionary*)entry
{
    
    NSArray* logLevelList = @[@"Debug", @"Info", @"Warn", @"Error",@""];
	
    NSString* dateStr = NULL;
    NSString* levelStr = NULL;
    
    dateStr = [entry objectForKey:kDate];
    
    int level = (int)[[entry objectForKey:kLevel] integerValue];
    if (level == LogLevel_None) {
        /**
         * @brief 原始log内容输出
         */
        NSString* content = [NSString stringWithFormat:@">> %@\t%@\n",
                             dateStr,
                             [entry objectForKey:kMsg]];
        return content;
    }
    
    

    if (level >= 0 && level <= 3) {
        levelStr = [logLevelList objectAtIndex:level];
    }

    NSString* content = [NSString stringWithFormat:@">> %@\t[%@]\t%@ %@ %@: %@\n",
                         dateStr,
                         levelStr,
                         [entry objectForKey:kThreadName],
                         [entry objectForKey:kFile],
                         [entry objectForKey:kFuncName],
                         [entry objectForKey:kMsg]];
    

	
    return content;
}

@end


#pragma mark - C Func

void __writeLog(const char* file,
			  const int line,
			  const char* function,
			  eLogLevel logLevel,
			  const char* format, ...)
{
	[LoggerManager startLogThread];
	
	//
	if (format == NULL)
	{
		return;
	}
	
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

	NSString* ocFormat = [[NSString alloc] initWithUTF8String:format];
	
	va_list args;
	va_start(args, format);
	NSString* msgTemp = [[NSString alloc] initWithFormat:ocFormat arguments:args];
	NSUInteger len = [msgTemp lengthOfBytesUsingEncoding:NSUTF8StringEncoding];

	char* pMsg = (char*)malloc(len+1);
	memset(pMsg, 0, len+1);
    strncpy(pMsg, [msgTemp UTF8String], len);
    //	vsprintf(pMsg, format, args);
    
	va_end(args);
	
	[msgTemp release];
	msgTemp = nil;
	[ocFormat release];
	ocFormat = nil;
	
	NSString* msg = [[NSString alloc] initWithUTF8String:pMsg];
	free(pMsg);
	
	NSString* curThreadName = [[NSThread currentThread] name];
	NSString* funcName = [NSString stringWithUTF8String:function];
	
	NSString* ocFile = [NSString stringWithUTF8String:file];
	NSArray* div = [ocFile componentsSeparatedByString:@"/"];	
	NSString* fileName = [NSString stringWithFormat:@"%@:%d", [div objectAtIndex:[div count]-1], line];
	
	if (curThreadName == nil)
	{
		curThreadName = @"";
	}
	
	if (funcName == nil)
	{
		funcName = @"";
	}
	
	if (msg == nil)
	{
		msg = [@"" retain];
	}
	
	NSDictionary* entry = [[NSDictionary alloc] initWithObjectsAndKeys:@"LogEntry", kType,
						   msg, kMsg,
                           ft_time_now_str(),kDate,
						   [NSNumber numberWithUnsignedInteger:logLevel], kLevel,
						   curThreadName, kThreadName,
						   funcName, kFuncName,
						   fileName, kFile,
						   nil];
	
	[msg release];
	msg = nil;
	
    //
    LoggerManager* logManager = [LoggerManager getInstance];
    
    // 在调用者线程里 print，及时性！ 写入日志文件时，在日志线程里运行；
    printf("%s", [[logManager getContentFromeEntry:entry] UTF8String]);
    
	[logManager appendLogEntry:entry];
	[entry release];
	entry = nil;
	[pool release];
    
	return;
}




void __model_writeLog(const char* content)
{
	[LoggerManager startLogThread];
	
	//
	if (content == NULL)
	{
		return;
	}
	
	NSString* msg = [[NSString alloc] initWithUTF8String:content];

	if (msg == nil)
	{
		msg = [@"" retain];
	}
    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

	NSDictionary* entry = [[NSDictionary alloc] initWithObjectsAndKeys:@"LogEntry", kType,
						   msg, kMsg,
                           ft_time_now_str(),kDate,
						   [NSNumber numberWithUnsignedInteger:LogLevel_None], kLevel,
						   nil];
	
	[msg release];
	msg = nil;
	
    //
    LoggerManager* logManager = [LoggerManager getInstance];
    

    // 在调用者线程里 print，及时性！ 写入日志文件时，在日志线程里运行；
    printf("%s", [[logManager getContentFromeEntry:entry] UTF8String]);
    
	[logManager appendLogEntry:entry];
	[entry release];
	entry = nil;
	[pool release];
    
	return;
}

















