
//导入SystemConfiguration.framework
#import <Foundation/Foundation.h>
//#import <sys/socket.h>

//add by sj.
typedef enum {
    eNotReachable,
    eReachableViaWiFi,
    eReachableVia3G,
    eReachableVia2G,
}eNetworkStatus_t;
//end

@class NetworkReachability;

@protocol NetworkReachabilityDelegate <NSObject>
@required
- (void) networkReachabilityDidUpdate:(NetworkReachability*)reachability;
@end

@interface NetworkReachability : NSObject
{
@private
	void* _reachability;
	CFRunLoopRef _runLoop;
	id<NetworkReachabilityDelegate>         _delegate;
    uint32_t _flags;
    BOOL _reachable;
    NSString * _host;
    BOOL _detecting;
    BOOL _isWWAN;
    
    eNetworkStatus_t _status;
}

@property(nonatomic, assign) id <NetworkReachabilityDelegate> delegate;
@property(nonatomic, assign) eNetworkStatus_t status;

@property(nonatomic, getter=isReachable) BOOL reachable;

@property(nonatomic, readonly) BOOL detecting;
@property(assign) BOOL isWWAN;

- (id) initWithHostName:(NSString*)name;
- (id) initWithZeroAddress;

-(BOOL)isWifi;
@end
