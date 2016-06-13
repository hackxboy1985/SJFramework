//
//  FTSearchViewControllerClass.m
//  Fetion
//
//  Created by yanggongwei on 14-2-13.
//  Copyright (c) 2014年 chinasofti. All rights reserved.
//

#import "FTSearchViewControllerClass.h"
#import "UIImage+Extend.h"

@interface FTSearchViewControllerClass()
{
}

@end



@implementation FTSearchViewControllerClass

@synthesize searchResultsDelegate;
@synthesize searchResultsDataSource;
@synthesize searchControllerClassDelegate;



-(id)initWitchController:(UIViewController*)controller
{
    self = [super init];
    
    if (self) {
        
        [self initWithSearch:(UIViewController*)controller];
//        [[NSNotificationCenter defaultCenter]  addObserver:self
//                                                  selector:@selector(menuWillShow:)
//                                                      name:UIMenuControllerWillShowMenuNotification
//                                                    object:nil];
        
    }
    return self;
}

// 初始化搜索框和UISearchDisplayController
-(void)initWithSearch:(UIViewController*)controller
{
    
    UISearchBar * mSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, 48)];
    mSearchBar.backgroundColor = [UIColor clearColor];
//    mSearchBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"searchbar_bg.png"]];
//    [mSearchBar setBackgroundImage:[UIImage imageNamed:@"searchbar_bg.png"]];
    [mSearchBar setPlaceholder:NSLocalizedString(@"search",@"搜索")];
    UITextField *searchfield = [mSearchBar valueForKey:@"_searchField"];
    searchfield.inputView = nil;
    searchfield.layer.cornerRadius = 5.0f;
//    searchfield.layer.masksToBounds = YES;
    if (SYSTEM_VERSION >= 7.0) {
#ifdef __IPHONE_7_0
        mSearchBar.searchBarStyle = UISearchBarStyleProminent;
        mSearchBar.barTintColor = [UIColor whiteColor];
#endif
        
        //通过增加个view以及设置灰色背景，同时设置UISearchBarBackground的clipsToBounds属性,
        //同时将navigationController.view的背景色设置与view相同来解决上移时，背景问题
        UIColor * bkCol = RGBA(239, 240, 241, 1.0);
        controller.navigationController.view.backgroundColor = bkCol;
        UIView* searchBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 66)];
        searchBg.backgroundColor = bkCol;
        for (UIView *obj in [mSearchBar subviews]) {
            for (UIView *objs in [obj subviews]) {
                if ([objs isKindOfClass:NSClassFromString(@"UISearchBarBackground")]){
                    [objs addSubview:searchBg];
                    objs.backgroundColor = bkCol;
                    objs.clipsToBounds = YES;
                    break;
                }
            }
            if ([obj isKindOfClass:NSClassFromString(@"UISearchBarBackground")]){
                [obj addSubview:searchBg];
                break;
            }
        }
    }
    else{
        for (UIView *subview in mSearchBar.subviews)
        {
            if ([subview isKindOfClass:[UITextField class]]) {
                [(UITextField *)subview setBackground:nil];
            }
        }
        [mSearchBar setBackgroundImage:[UIImage new]];
    }
    
//    searchfield.backgroundColor = RGBA(244, 244, 244, 1.0);//灰色搜索输入框
    searchfield.layer.borderWidth = 0.5;
    searchfield.layer.borderColor = [RGBA(203, 203, 203, 0.5) CGColor];
    mSearchBar.delegate = self;
    
    
    [mSearchBar sizeToFit];
    
    self.searchBar = mSearchBar;
    
    //init search controller
    UISearchDisplayController *sController =[[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:controller];
    
    sController.delegate = self;
    
    self.searchDisplayControl = sController;
    
    [self setCancelButtonString:NSLocalizedString(@"cancel",@"取消")];
    
}

//修改搜索 取消按钮
-(void)setCancelButtonString:(NSString*)string
{
    if (SYSTEM_VERSION >= 7.0) {
        
        UIButton *cancelButton = nil;
        
        UIView *topView = self.searchDisplayControl.searchBar.subviews[0];
        
        for (UIView *subView in topView.subviews) {
            
            if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
                
                cancelButton = (UIButton*)subView;
            }
        }
        
        if (cancelButton) {
            //Set the new title of the cancel button
            [cancelButton setTitle:string forState:UIControlStateNormal];
        }
    }
    else
    {
        for(UIView *subView in self.searchDisplayControl.searchBar.subviews)
        {
            if([subView isKindOfClass:[UIButton class]])
            {
                [(UIButton*)subView setTitle:string forState:UIControlStateNormal];
            }
        }
    }
}

//获取 _searchBar 供其他调用
-(UISearchBar*)getSearchBar
{
    return _searchBar;
}

//讯飞键盘暂时不用
-(void)setUITextFieldInputView
{
    UITextField *searchfield = [self getSearchField:_searchBar];
    searchfield.inputView = nil;
}

//获取UItextField
- (UITextField *)getSearchField:(UISearchBar *)searchBar
{
    UITextField *textField = nil;
    @try {
        textField = [searchBar valueForKey:@"_searchField"];
    }
    @catch (NSException *exception) {
        NSLog(@"%s exception:%@", __func__, exception);
    }
    @finally {
        
    }
    return textField;
}

//初始化时候设置结果tableviewRow的高度
-(void)setSearchResultsTableviewRowHeight:(CGFloat)height
{
    _searchDisplayControl.searchResultsTableView.rowHeight = height;
}


//初始化时候设置代理
-(void)setSearchResultsDelegate:(id<UITableViewDelegate>)newsearchResultsDelegate
{
    _searchDisplayControl.searchResultsDelegate = newsearchResultsDelegate;
}
//初始化时候设置代理
-(void)setSearchResultsDataSource:(id<UITableViewDataSource>)newsearchResultsDataSource
{
    _searchDisplayControl.searchResultsDataSource = newsearchResultsDataSource;
}



//设置搜索框内默认字
-(void)setPlaceholderStr:(NSString *)newplaceholderStr
{
    [self.searchBar setPlaceholder:newplaceholderStr];//按照产品要求统一修改为搜索
}

/*
- (void) menuWillShow:(NSNotification *)notification
{

    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuVisible:NO];
//    UIMenuItem *manageItem = [[UIMenuItem alloc] initWithTitle:@"粘贴" action:@selector(manageFunc)];
//    [menuController setMenuItems:[NSArray arrayWithObjects:manageItem, nil]];
//    [menuController setTargetRect:self.view.frame inView:self.superview];
//    [menuController setMenuVisible:YES animated:YES];
//    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuWillHide:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}

- (void) menuWillHide:(NSNotification *)notification
{

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}*/

#pragma mark - UISearchDisplayDelegate methods

//点击搜索框调用此方法
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    UITextField *searchField = [self getSearchField:self.searchBar];

    _active = true;
    
    //埋点数据统计用 点击searchbar
    if (searchControllerClassDelegate && [searchControllerClassDelegate respondsToSelector:@selector(clickSearchBarDataStatistics)])
    {
        [searchControllerClassDelegate clickSearchBarDataStatistics];
    }
    UIMenuController *menuController = [UIMenuController sharedMenuController];

    NSMutableArray *mulArray = [[NSMutableArray alloc] initWithArray:[menuController menuItems]];
    if (mulArray && [mulArray count] != 0) {
        [mulArray removeAllObjects];
    }
    [menuController setMenuItems:mulArray];
}

//搜索将结束调用此方法
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    _active = false;
    [controller.searchResultsTableView reloadData];
}

//一旦SearchBar輸入內容有變化，則執行這個方法
-(BOOL)searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (searchControllerClassDelegate && [searchControllerClassDelegate respondsToSelector:@selector(shouldReloadTableForSearchString:)])
    {
        // ygw   开始进行搜索
        NSInteger countdata = [searchControllerClassDelegate shouldReloadTableForSearchString:searchString];
        if (0 == countdata)
        {
            controller.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self setCancelButtonString:NSLocalizedString(@"cancel",@"取消")];
        }
        else
        {
            controller.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self setCancelButtonString:NSLocalizedString(@"完成",@"完成")];
        }
        
        [controller.searchResultsTableView reloadData];
    }
    return YES;
}


//搜索结束调用
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    if (searchControllerClassDelegate && [searchControllerClassDelegate respondsToSelector:@selector(searchControllerDidEndSearch)])
    {
        [searchControllerClassDelegate searchControllerDidEndSearch];
        [self setCancelButtonString:NSLocalizedString(@"cancel",@"取消")];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _active = false;

//    if (searchControllerClassDelegate && [searchControllerClassDelegate respondsToSelector:@selector(searchControllerDidEndSearch)])
//    {
//        [searchControllerClassDelegate searchControllerDidEndSearch];
//    }
}

// called when table is shown/hidden
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.backgroundColor = [UIColor whiteColor];
}


- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.backgroundColor = [UIColor whiteColor];
}


- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
}


- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{
}

@end
