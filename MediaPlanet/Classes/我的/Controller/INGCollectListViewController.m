//
//  INGCollectListViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/14.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  我的收藏

#import "INGCollectListViewController.h"
#import "INGcollectListTableViewCell.h"
#import "INGNavigationController.h"
#import "INGProductInfoViewController.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import "myColListModle.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <MGSwipeTableCell.h>


#define deleteBtnRedbackgroundColor JCColor(251, 89, 91)
#define deleteBtnNormalbackgroundColor JCColor(100, 100, 100)

//返回的每页数据个数
static NSInteger const pagesize = 10;

@interface INGCollectListViewController ()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** 全部选中按钮 */
@property (nonatomic, strong) UIButton *selecteButton;
/** 删除按钮 */
@property (nonatomic, strong) UIButton *deleteButton;
/** 底部View */
@property (nonatomic, strong) UIView *bottomView;
/** 编辑按钮 */
@property (nonatomic, strong) UIButton *editButton;

/** 当前参数 */
@property (nonatomic, strong) NSDictionary *params;
/** 当前页数 */
@property (nonatomic, assign) NSInteger pageindex;

/** 收藏数组 */
@property (nonatomic, strong) NSMutableArray *colListArray;
/** 总的收藏数量 */
@property (nonatomic, assign) NSInteger total;
/** 选中的收藏数组 */
@property (nonatomic, strong) NSMutableArray *selectedArray;

/** 没有被选中的数组 */
@property (nonatomic, strong) NSMutableArray *NOSelectedArray;

@end

static NSString *const collectID = @"collectID";

@implementation INGCollectListViewController
-(NSMutableArray *)colListArray
{
    if (_colListArray == nil) {
        _colListArray = [NSMutableArray array];
    }
    return _colListArray;
}
-(NSMutableArray *)selectedArray
{
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}
-(NSMutableArray *)NOSelectedArray
{
    if (_NOSelectedArray == nil) {
        _NOSelectedArray = [NSMutableArray array];
    }
    return _NOSelectedArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setupGifBG];
    [self setupNav];
    [self setupTableView];
    [self setup];
    [self refresh];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableView:) name:INGCancelCollectionNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableView:) name:INGIsSelectedCollectionNotification object:nil];
}

-(void)setupNav
{
//    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.size = CGSizeMake(50, 30);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [rightButton setTitle:@"完成" forState:UIControlStateSelected];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton addTarget:self action:@selector(showBottomView) forControlEvents:UIControlEventTouchUpInside];
    self.editButton = rightButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

-(void)showBottomView
{
    self.editButton.selected = !self.editButton.isSelected;
    self.bottomView.hidden = !self.editButton.isSelected;

    [self.tableView reloadData];
}

-(void)refreshTableView:(NSNotification *)notification
{
    [self.NOSelectedArray removeAllObjects];
    //
    for (int i = 0; i < self.colListArray.count; i++) {
        myColListModle *modle = self.colListArray[i];
        if (modle.ProductNo == notification.userInfo[INGCancelCollection]) {
            [self.colListArray removeObjectAtIndex:i];
        }

        if (!modle.IsSelected) {
            self.selecteButton.selected = NO;
            [self.NOSelectedArray addObject:modle];
        }
    }
    if (self.NOSelectedArray.count == 0) {
        self.selecteButton.selected = YES;
    }
    //判断是都选中收藏
    [self.selectedArray removeAllObjects];
    for (int i = 0; i < self.colListArray.count; i++) {
        myColListModle *modle = self.colListArray[i];
        if (modle.IsSelected) {
            [self.selectedArray addObject:modle];
        }
    }

    if (self.selectedArray.count == 0) {
        
        self.deleteButton.backgroundColor = deleteBtnNormalbackgroundColor;
        self.deleteButton.enabled = NO;
    }else{
        self.deleteButton.backgroundColor = deleteBtnRedbackgroundColor;
        self.deleteButton.enabled = YES;
    }
    [self.tableView reloadData];
    
}
-(void)setup
{

    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor blackColor];
    bottomView.x = 0;
    bottomView.width = screenW;
    bottomView.height = 44;
    bottomView.y = screenH - bottomView.height;
    self.bottomView = bottomView;
    [self.view addSubview:bottomView];
    bottomView.hidden = YES;
    
    UIImageView *bottomImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"col_bottom"]];
    bottomImage.frame = bottomView.bounds;
    [bottomView addSubview:bottomImage];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.width = screenW * 0.33;
    deleteButton.height = 44;
    deleteButton.centerY = bottomView.height * 0.5;
    deleteButton.x = screenW - deleteButton.width;
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:15];
    deleteButton.backgroundColor = JCColor(100, 100, 100);//JCColor(251, 89, 91);
    
    self.deleteButton = deleteButton;
    [bottomView addSubview:deleteButton];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.width = 60;
    selectBtn.height = 30;
    selectBtn.centerY = bottomView.height * 0.5;
    selectBtn.x = 20;
    [selectBtn setTitle:@"全选" forState:UIControlStateNormal];
    selectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [selectBtn setImage:[UIImage imageNamed:@"personal_c"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"col_all"] forState:UIControlStateSelected];
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [selectBtn addTarget:self action:@selector(selecteClick) forControlEvents:UIControlEventTouchUpInside];
    self.selecteButton = selectBtn;
    [bottomView addSubview:selectBtn];
}
-(void)setupTableView
{
    self.tableView = [[UITableView alloc]init];
    
    self.tableView.x = 0;
    self.tableView.y = 64;
    self.tableView.width = screenW;
    self.tableView.height = screenH - 64;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setBackgroundColor:JCColor(238, 238, 238)];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([INGcollectListTableViewCell class]) bundle:nil] forCellReuseIdentifier:collectID];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [self.tableView setRowHeight:155];
    
    CGFloat bottom = self.tabBarController.tabBar.height;
    //    CGFloat top = JCTitleViewY + JCTitleViewH;
    
    //设置内边距
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, bottom, 0);
    //设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self.view addSubview:self.tableView];
    
}

-(void)selecteClick
{
    self.selecteButton.selected = !self.selecteButton.isSelected;
    for (myColListModle *modle in self.colListArray) {
        modle.IsSelected = self.selecteButton.selected;
    }
    if (self.selecteButton.isSelected == YES) {
        self.deleteButton.backgroundColor = JCColor(251, 89, 91);
        self.deleteButton.enabled = YES;
    }else{
        self.deleteButton.backgroundColor = JCColor(100, 100, 100);
        self.deleteButton.enabled = NO;
    }
    [self.tableView reloadData];
}

-(void)deleteButtonClick
{
    [self.selectedArray removeAllObjects];
    NSMutableString *prodcutStr = [NSMutableString string];
    for (myColListModle *modle in self.colListArray) {
        if (modle.IsSelected) {
//            [self.selectedArray addObject:modle.ProductNo];
            [prodcutStr appendString:modle.ProductTag];
            [prodcutStr appendString:@","];
        }
    }

    NSMutableString *delUrl = [NSMutableString string];
    [delUrl appendString:apiUrl];
    [delUrl appendString:@"pcenter/removecols"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *isDel = self.selecteButton.isSelected == YES ? @"true" : @"false";
    params[@"isdel"] = isDel;
    
    if (self.selecteButton.isSelected) {
        params[@"product"] = nil;
    }else{
        if (prodcutStr.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请选择删除数据"];
            return;
        }
        params[@"product"] = [prodcutStr substringToIndex:(prodcutStr.length - 1)];//self.selectedArray;
        
    }
    params[@"key"] = key;
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    self.params = params;
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:delUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        if (self.params != params) return ;
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            if (self.selecteButton.isSelected) {
                [self.colListArray removeAllObjects];
                
            }else{
                for (int i = 0; i < self.colListArray.count; i++) {
                    myColListModle *modle = self.colListArray[i];
                    if (modle.IsSelected == YES) {
                        [self.selectedArray addObject:modle];
                    }
                }
                [self.colListArray removeObjectsInArray:self.selectedArray];
                
                [self.tableView reloadData];
            }
            [self.tableView reloadData];
            [SVProgressHUD showSuccessWithStatus:@"删除完成"];
            self.selecteButton.selected = NO;
            self.deleteButton.backgroundColor = JCColor(100, 100, 100);
            self.deleteButton.enabled = NO;
        }else{
            self.deleteButton.backgroundColor = JCColor(251, 89, 91);
            self.deleteButton.enabled = YES;
            [SVProgressHUD showErrorWithStatus:@"删除失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.deleteButton.backgroundColor = JCColor(251, 89, 91);
        self.deleteButton.enabled = YES;
        [self.tableView reloadData];
        if (self.params != params) return ;
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
        
    }];
    
    
}
#pragma mark - 设置刷新
/** 设置刷新 */
-(void)refresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewList)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}
-(void)loadNewList
{
    
    NSMutableString *listUrl = [NSMutableString string];
    [listUrl appendString:apiUrl];
    [listUrl appendString:@"pcenter/querycols"];
    self.pageindex = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageindex"] = @ (self.pageindex);
    params[@"pagesize"] = @(pagesize);
    params[@"key"] = key;
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    self.params = params;
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:listUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.tableView.mj_header endRefreshing];
        //如果请求返回的参数不等请求之前的参数，就不做处理
        if (self.params != params) return ;
        NSLog(@"responseObject = %@",responseObject);
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            [self.colListArray removeAllObjects];
            self.selecteButton.selected = NO;
//            NSArray *array = responseObject[@"Results"][@"List"];
            NSArray *array = [myColListModle mj_objectArrayWithKeyValuesArray:responseObject[@"Results"][@"List"]];
            [self.colListArray addObjectsFromArray:array];
            self.total = [responseObject[@"Results"][@"Total"] integerValue] - (self.pageindex -1) * pagesize;
            if (self.total < pagesize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
//                self.tableView.mj_footer.hidden = NO;
                [self.tableView.mj_footer endRefreshing];
            }
            self.pageindex ++;
            
        }else{
            [self.colListArray removeAllObjects];
            [SVProgressHUD showInfoWithStatus:@"没有收藏记录"];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVProgressHUD showErrorWithStatus:@"请求数据出错"];
        if (self.params != params) return ;
        [self.tableView.mj_header endRefreshing];
    }];
//    self.tableView.mj_footer.hidden = NO;
    [self.tableView.mj_footer endRefreshing];
}

-(void)loadMore
{
    
    NSMutableString *listUrl = [NSMutableString string];
    [listUrl appendString:apiUrl];
    [listUrl appendString:@"pcenter/querycols"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageindex"] = @(self.pageindex);
    params[@"pagesize"] = @(pagesize);
    params[@"key"] = key;
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    self.params = params;
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:listUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"====%@",responseObject);
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            self.selecteButton.selected = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            //如果请求返回的参数不等请求之前的参数，就不做处理
            if (self.params != params) return ;
            self.total = [responseObject[@"Results"][@"Total"] integerValue] - (self.pageindex - 1) * pagesize;
            self.pageindex ++;
            
            NSArray *array = [myColListModle mj_objectArrayWithKeyValuesArray:responseObject[@"Results"][@"List"]];
            [self.colListArray addObjectsFromArray:array];
            
            if (self.total < pagesize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
//                self.tableView.mj_footer.hidden = NO;
                [self.tableView.mj_footer endRefreshing];
            }
            
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.params != params) return ;
        [SVProgressHUD showErrorWithStatus:@"请求出错"];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.colListArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    INGcollectListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:collectID];
    cell.modle = self.colListArray[indexPath.row];
    
    cell.delegate = self;
    if (self.editButton.isSelected) {
        cell.collectBtn.hidden = NO;
    }else{
        cell.collectBtn.hidden = YES;
    }
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"删除" icon:nil backgroundColor:JCColor(251, 89, 91)]];
    return cell;
    
}

#pragma mark - 代理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    INGProductInfoViewController *VC = [[INGProductInfoViewController alloc]init];
    VC.title = @"产品详情";
    myColListModle *modle = self.colListArray[indexPath.row];
    VC.productName = modle.ProductNo;
    [self.navigationController pushViewController:VC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    myColListModle *modle = self.colListArray[indexPath.row];
    return modle.cellHeight;
}
#pragma mark - MGSwipeTableCell侧滑按钮的回调

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion
{

    if (direction == MGSwipeDirectionRightToLeft && index == 0) {
        //delete button 删除按钮
        
        NSIndexPath * path = [_tableView indexPathForCell:cell];
        myColListModle *modle = self.colListArray[path.row];
        
        [self cancelColProductNo:modle];
        
        return NO; //Don't autohide to improve delete expansion animation
    }
    
    return YES;
}
#pragma mark - 删除收藏
//取消收藏
- (void)cancelColProductNo:(myColListModle *)modle
{
    NSMutableString *collUr = [NSMutableString string];
    [collUr appendString:apiUrl];
    [collUr appendString:@"products/collections"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"product"] = modle.ProductNo;
    params[@"isdel"] = @"true";
    params[@"key"] = key;
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    
    [params removeObjectForKey:@"key"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:collUr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"取消成功"];
            [self.colListArray removeObject:modle];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:@"取消失败"];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试"];
        
        
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
