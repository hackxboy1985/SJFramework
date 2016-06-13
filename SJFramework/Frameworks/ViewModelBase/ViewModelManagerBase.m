//
//  ViewModelManagerBase.m
//  Doctor
//
//  Created by born on 16/4/14.
//  Copyright © 2016年 Hkzr All rights reserved.
//

#import "ViewModelManagerBase.h"
#import "AppDelegateBase.h"
#import "ViewModelBase.h"

@implementation ViewModelManagerBase
{
    NSMutableDictionary* _dicModels;
}


-(id)init
{
    self = [super init];
    
    if(self){
        _dicModels = [[NSMutableDictionary alloc] init];
        [[AppDelegateBase getAppDelegateBase] registerViewModelManager:self];
    }
    
    return self;
}

-(void)didEnterBackground{
    
    NSArray* ary = [_dicModels allValues];
    for (ViewModelBase * model in ary) {
        [model didEnterBackground];
    }
}

-(void)didEnterForeground{
    NSArray* ary = [_dicModels allValues];
    for (ViewModelBase * model in ary) {
        [model didEnterForeground];
    }
}

-(void)loginSuccessful{
    NSArray* ary = [_dicModels allValues];
    for (ViewModelBase * model in ary) {
        [model loginSuccessful];
    }
}

-(void)logout{
    NSArray* ary = [_dicModels allValues];
    for (ViewModelBase * model in ary) {
        [model logout];
    }
}

/**
 *  @brief 注册模块
 *  @param viewModelClass 模块类名
 *  @param modelName 模块名
 */
-(void)registerViewModel:(NSString*)viewModelClass withName:(NSString*)modelName{
    
    id model = [[NSClassFromString(viewModelClass) alloc] init];
    [_dicModels  setObject:model forKey:modelName];
}


/**
 *  @brief 获得模块
 *  @param modelName 模块名
 *  @return 返回模块
 */
-(id)obtainViewModelWithName:(NSString*)modelName{
    return [_dicModels objectForKey:modelName];
}


/**
 * @brief 反注册UI监听对象
 * @param uiproxy 监听对象
 */
-(void)unregisterUIListener:(id<LogicToUICallback>)uiproxy{
    NSArray* ary = [_dicModels allValues];
    for (ViewModelBase * model in ary) {
        [model unregisterUIListener:uiproxy];
    }
}






@end
