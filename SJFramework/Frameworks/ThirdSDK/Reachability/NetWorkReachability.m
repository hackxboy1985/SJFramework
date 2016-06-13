

#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

#import "NetworkReachability.h"


@interface NetworkReachability (Private) 

- (void) tryTestCmwap;
- (void) callBack;
- (void) updateFlags:(SCNetworkReachabilityFlags)flags;

@end

@implementation NetworkReachability (Private)
- (void)callBack{
    if(_delegate){
        [_delegate networkReachabilityDidUpdate:(NetworkReachability *)self];
    }
}

- (void) updateFlags:(SCNetworkReachabilityFlags)flags;
{
    //add by sj for check 2g
    self.status = [self networkStatusForFlags:flags];
    //end
    
	_flags = flags;
	
	BOOL isRequireConnect = (flags & kSCNetworkReachabilityFlagsConnectionRequired)? YES: NO;
	BOOL isWWAN = (flags & kSCNetworkReachabilityFlagsIsWWAN)? YES: NO;
	BOOL isReachable = (flags & kSCNetworkReachabilityFlagsReachable)? YES: NO;
	
	NSLog(@"网络监测 SCNetworkFlags %@|%@|%@",(isWWAN?@"WWAN":@"WIFI"),(isRequireConnect?@"C":@"NC"),(isReachable?@"R":@"NR"));
	
	_reachable = isReachable;//(isReachable /*&& !isRequireConnect*/)? YES: NO;
	
    _isWWAN = isWWAN;
}

- (void) tryTestCmwap
{
    
}

//add by sj for check 2g
- (eNetworkStatus_t) networkStatusForFlags: (SCNetworkReachabilityFlags) flags
{
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
    {
        return eNotReachable;
        
    }
    
    BOOL retVal = eNotReachable;
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
    {
        // if target host is reachable and no connection is required
        //  then we'll assume (for now) that your on Wi-Fi
        retVal = eReachableViaWiFi;
    }
    
    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
    {
        // ... and the connection is on-demand (or on-traffic) if the
        //     calling application is using the CFSocketStream or higher APIs
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            // ... and no [user] intervention is needed
            retVal = eReachableViaWiFi;
        }
    }
    
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
    {
        if((flags & kSCNetworkReachabilityFlagsReachable) == kSCNetworkReachabilityFlagsReachable) {
            
            if ((flags & kSCNetworkReachabilityFlagsTransientConnection) == kSCNetworkReachabilityFlagsTransientConnection) {
                
                retVal = eReachableVia3G;
                
                if((flags & kSCNetworkReachabilityFlagsConnectionRequired) == kSCNetworkReachabilityFlagsConnectionRequired) {
                    
                    retVal = eReachableVia2G;
                }
            }
        }
    }
    
    return retVal;
    
}

@end

@implementation NetworkReachability

@synthesize delegate=_delegate;
@synthesize detecting = _detecting;
@synthesize isWWAN = _isWWAN;
@synthesize reachable = _reachable;

static void _ReachabilityCallBack(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
    
    NSLog(@"_ReachabilityCallBack");
	NSAutoreleasePool* pool = [NSAutoreleasePool new];
	
	NetworkReachability* self_instance = (NetworkReachability*)info;
//	BOOL oldReachable = self_instance->_reachable;
    [self_instance updateFlags:flags];
	//if(self_instance->_reachable||oldReachable != self_instance->_reachable)
	{
		[self_instance callBack];
	}
	[pool release];
}

- (id) initWithHostName:(NSString*)name
{
    //NSLog(@"initWithHostName");
	self = [super init];
	if(self != nil)
	{
		_host = [name retain];
		NSString * nav = name;
		_reachability = (void*)SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, [nav UTF8String]);
		_runLoop = (CFRunLoopRef)CFRetain(CFRunLoopGetMain());
		
		SCNetworkReachabilityContext context = {0, self, NULL, NULL, NULL};
		if(!SCNetworkReachabilitySetCallback(_reachability, _ReachabilityCallBack, &context)) {
			[self release];
			return nil;
		}
		if(!SCNetworkReachabilityScheduleWithRunLoop(_reachability, _runLoop, kCFRunLoopCommonModes)) {
			SCNetworkReachabilitySetCallback(_reachability, NULL, NULL);
			[self release];
			return nil;
		}		
	}
	return self;
}

- (id) initWithZeroAddress
{
    self = [super init];
	if(self != nil)
	{
        struct sockaddr_in zeroAddress;
        bzero(&zeroAddress, sizeof(zeroAddress));
        zeroAddress.sin_len = sizeof(zeroAddress);
        zeroAddress.sin_family = AF_INET;
        // Recover reachability flags
        _reachability = (void*)SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
		_runLoop = (CFRunLoopRef)CFRetain(CFRunLoopGetMain());
		
		SCNetworkReachabilityContext context = {0, self, NULL, NULL, NULL};
		if(!SCNetworkReachabilitySetCallback(_reachability, _ReachabilityCallBack, &context)) {
			[self release];
			return nil;
		}
		if(!SCNetworkReachabilityScheduleWithRunLoop(_reachability, _runLoop, kCFRunLoopCommonModes)) {
			SCNetworkReachabilitySetCallback(_reachability, NULL, NULL);
			[self release];
			return nil;
		}
        
        SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
        SCNetworkReachabilityFlags flags;
        //获得连接的标志
        BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
        CFRelease(defaultRouteReachability);
        //如果不能获取连接标志，则不能连接网络，直接返回
        if (!didRetrieveFlags)
        {
            return nil;
        }
		
        [self updateFlags:flags];
	}
	return self;
}


-(BOOL)isWifi
{
    return self.status == eReachableViaWiFi;
}

- (void) dealloc
{
	SCNetworkReachabilityUnscheduleFromRunLoop(_reachability, _runLoop, kCFRunLoopCommonModes);
	SCNetworkReachabilitySetCallback(_reachability, NULL, NULL);
	
	self.delegate = nil;
    if(_host)
        [_host release];
	if(_runLoop)
        CFRelease(_runLoop);
	if(_reachability)
        CFRelease(_reachability);
	[super dealloc];
}
@end

