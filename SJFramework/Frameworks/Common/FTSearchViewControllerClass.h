//
//  FTSearchViewControllerClass.h
//  Fetion
//
//  Created by yanggongwei on 14-2-13.
//  Copyright (c) 2014年 chinasofti. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FTSearchViewControllerClassDelegate <NSObject>
@optional
/**
 *	@brief	searchBar 搜索的关键字
 */
-(NSInteger)shouldReloadTableForSearchString:(NSString *)searchString;
/**
 *	@brief	搜索结束后需要回调跟新自己的tableview
 */
-(void)searchControllerDidEndSearch;

/**
 *  点击searchbar数据统计(供埋点统计数据用)
 */
-(void)clickSearchBarDataStatistics;


@end


@interface FTSearchViewControllerClass : NSObject<UISearchBarDelegate,UISearchDisplayDelegate,UITextFieldDelegate>
{
    __weak id<UITableViewDelegate> searchResultsDelegate;//设置searchTable的代理
    __weak id<UITableViewDataSource> searchResultsDataSource;//设置searchTable的数据源
    __weak id <FTSearchViewControllerClassDelegate> searchControllerClassDelegate;//FTSearchViewControllerClass的代理
    UISearchBar* _searchBar;
    UISearchDisplayController* _searchDisplayControl;

}

@property(weak,nonatomic) id <UITableViewDelegate> searchResultsDelegate;
@property(weak,nonatomic) id <UITableViewDataSource> searchResultsDataSource;
@property(weak,nonatomic) id <FTSearchViewControllerClassDelegate> searchControllerClassDelegate;
@property(nonatomic, strong)  UISearchBar* searchBar;
@property(nonatomic, strong)  UISearchDisplayController* searchDisplayControl;
@property (nonatomic, assign, getter = isActive) BOOL active;



/**
 *	@brief	初始化SearchBarcontroller接收controller
 */
-(id)initWitchController:(UIViewController*)controller;

/**
 *	@brief	获取SearchViewController中的searchBar
 */
-(UISearchBar*)getSearchBar;

/**
 *  设置第三方键盘(讯飞的)
 */
-(void)setUITextFieldInputView;

/**
 *  初始化时候设置结果tableviewRow的高度
 */
-(void)setSearchResultsTableviewRowHeight:(CGFloat)height;
@end
