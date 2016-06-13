//
//  ViewModelManager.m
//  Doctor
//
//  Created by born on 16/4/14.
//  Copyright © 2016年 ViewHigh. All rights reserved.
//

#import "ViewModelManager.h"

#define kModel_Home @"homeModel"
#define kModel_Login @"LoginModel"
#define kModel_Register @"RegisterModel"


@implementation ViewModelManager
+ (void) initialize{
    [ViewModelManager getSingleton];
}

static ViewModelManager* m_singleton = NULL;
+(ViewModelManager*)getSingleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m_singleton = [[ViewModelManager alloc] init];
    });
    return m_singleton;
}


-(id)init{
    if(self = [super init]){
        
        [super registerViewModel:@"HomeViewModel" withName:kModel_Home];
        [super registerViewModel:@"LoginViewModel" withName:kModel_Login];
        [super registerViewModel:@"RegisterViewModel" withName:kModel_Register];
    }
    return self;
}


-(HomeViewModel*)getHomeViewModel{
    return [super obtainViewModelWithName:kModel_Home];
}

-(LoginViewModel *)getLoginViewModel{

    return [super obtainViewModelWithName:kModel_Login];
}

-(RegisterViewModel *)getRegisterViewModel{

    return [super obtainViewModelWithName:kModel_Register];
}


@end
