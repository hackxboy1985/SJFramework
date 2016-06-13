//
//  HomeViewModel.h
//  
//
//  Created by born on 16/4/11.
//
//

#import "ViewModelBase.h"

@interface HomeViewModel : ViewModelBase

/**
 * @brief 更新计划列表
 */
-(void)updatePlanListWithBlock:(BusinessCallback)block;

/**
 *  @brief 获取首页首页数据
 */
-(void)getHomeDataWithBlock:(BusinessCallback)block;


@end
