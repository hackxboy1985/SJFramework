//
//  HomeViewModel.m
//  
//
//  Created by born on 16/4/11.
//
//

#import "HomeViewModel.h"
#import "UserAccount.h"


#define kUrlUpdatePlan IP@"/health-api/api/v1/user/index?serviceId=11"


#define HomeReuestURL IP@"/api/v1/home/findHomeList" //首页接口地址

@interface HomeViewModel()
{
    NSArray* ary;
    NSMutableArray *_messageDataSource;
}
@property (nonatomic, strong) NSMutableArray *name;

@end




@implementation HomeViewModel

- (id)init{
    if (self = [super init]) {
        _messageDataSource = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark - 获取首页数据
-(void)getHomeDataWithBlock:(BusinessCallback)block{

    UserAccount *userAccount = [UserAccount getAccount];
    NSDictionary *dict = @{@"uid":userAccount.userId,@"sid":userAccount.sid,@"did":userAccount.did};
    [super HttpRequestForUri:HomeReuestURL andSendDic:dict businessBlock:block callback:^(NSString *errorTips, NSDictionary *responsDict, BusinessCallback callback) {
        if (responsDict) {
            NSLog(@"首页数据-->%@",responsDict);
            
            //首页日程数组
            
            
            if(block)//判断 block 是否有值
                block(true,@"");
        } else{
            
            if(block)
                block(false,errorTips);
        }
    }];

}

-(void)updatePlanListWithBlock:(BusinessCallback)block{
    //1.组织请求数据
    //2.请求server，解析返回数据
    
    return;
    
    NSDictionary* dict = NULL;
    
    //__weak typeof(self) wself = self;
    [super HttpRequestForUri:kUrlUpdatePlan andSendDic:dict businessBlock:block callback:^(NSString *errorTips, NSDictionary *responsDict, BusinessCallback block) {
        
        if(responsDict){
            //处理业务,将数据存储在ViewModel
            
            
            //回调页面
            if(block)
                block(true,@"");
        }else{
            
            //回调页面
            if(block)
                block(false,errorTips);
        }
        
    }];
    
}


#pragma mark - 程序退出后清空数据

-(void)logout{
    
    
}



#pragma mark - 数组懒加载

@end
