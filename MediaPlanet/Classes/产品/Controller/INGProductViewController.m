    //
//  INGProductViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/8.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  商品列表

#import "INGProductViewController.h"
#import "INGProductCell.h"
#import "INGSearchField.h"
#import "INGProductInfoViewController.h"
#import "INGSearchViewController.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import "productList.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>

@interface INGProductViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *sorctBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 请求页数 */
@property (nonatomic, assign) NSInteger pageIndex;

/** 模型数组 */
@property (nonatomic, strong) NSMutableArray *productArray;

/** 产品总数 */
@property (nonatomic, assign) NSInteger total;

/** 请求的参数 */
@property (nonatomic, strong) NSMutableDictionary *params;


@end

static NSString *const cellID = @"productCell";
static NSInteger const pagesize = 10;

@implementation INGProductViewController

-(NSMutableArray *)productArray
{
    if (_productArray == nil) {
        _productArray = [NSMutableArray array];
    }
    return _productArray;
}
-(NSMutableDictionary *)params
{
    if (_params == nil) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];

    [self setupNav];
    
    [self.view setupGifBG];
    
    [self setupRefresh];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //添加通知，监听用户的登录和退出
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setupRefresh) name:INGUserLoginOrOutNotification object:nil];
    
    //监听城市改变,刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupRefresh) name:INGCityDidSelectNotification object:nil];
}
//-(void)cityDidChange: (NSNotification *)notification
//{
//    self 
//}
/** 初始化导航栏 */
-(void)setupNav
{
    INGSearchField *searchField = [INGSearchField searchField];
    searchField.textColor = [UIColor whiteColor];
    searchField.delegate = self;
    searchField.width = screenW - 100;
    searchField.height = 30;
    searchField.x = 50;
    self.navigationItem.titleView = searchField;
    
}

/** 初始化tableview */
-(void)setupTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([INGProductCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 48, 0);
    
}
//
- (IBAction)sortClick:(id)sender {
    self.sorctBtn.selected = !self.sorctBtn.isSelected;
 
    [self.tableView.mj_header beginRefreshing];

}

/** 初始化刷新控件 */

-(void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
}

#pragma mark - 加载数据
/** 加载新数据 */
-(void)loadNew
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSMutableString *loadUrl = [NSMutableString string];
    [loadUrl appendString:apiUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    self.pageIndex = 1;
    NSString *cityName = [CityNameKey getOutStandard];
    if (cityName == nil) {
        cityName = @"上海";
    }
    
    switch (self.loadType) {
        case NormalProductType:     //正常模式
            [loadUrl appendString:@"products/list"];
            params[@"cityname"] = cityName;
            break;
        case SearchCategoryType:    //查询分类
            [loadUrl appendString:@"products/list"];
            params[@"adtype"] = self.searchText;
            params[@"cityname"] = cityName;
            break;
        case SearchProductType:     //查询关键字
            [loadUrl appendString:@"products/searchwords"];
            params[@"txt"] = self.searchText;;
            params[@"city"] = cityName;
            break;
        case admentNameType:        //  查询广告商
            [loadUrl appendString:@"products/adproduct"];
            params[@"advertiserno"] = self.searchText;
            params[@"city"] = cityName;
            break;
        default:
            break;
    }
    
    int sort = self.sorctBtn.isSelected == YES ? 2 : 1;
    params[@"sort"] = @ (sort);//1-降序、2-升序
    params[@"pageindex"] = @(self.pageIndex);
    params[@"pagesize"]  = @(pagesize);
    params[@"key"] = key;
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    
    [params removeObjectForKey:@"key"];
    
    self.params = params;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    
    [manager POST:loadUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if (self.params != params) {
            [SVProgressHUD dismiss];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        [self.tableView.mj_header endRefreshing];
        [self.productArray removeAllObjects];
        [self.tableView reloadData];
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            NSArray *array = [productList mj_objectArrayWithKeyValuesArray:responseObject[@"Results"][@"List"]];
            [self.productArray addObjectsFromArray:array];
            self.total = [responseObject[@"Results"][@"Total"] integerValue];
            
            if (  self.total <= self.pageIndex * pagesize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{

                [self.tableView.mj_footer endRefreshing];
            }
            self.pageIndex ++;
        }else{
            [self.tableView.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:@"未查询到相关产品"];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (self.params != params) {
            return ;
        }
        
        [self.productArray removeAllObjects];
        [self.tableView reloadData];
        [SVProgressHUD showErrorWithStatus:@"请求失败，稍后重试！"];
    }];
}
///** 加载更多 */
-(void)loadMore
{
    
    NSMutableString *loadUrl = [NSMutableString string];
    [loadUrl appendString:apiUrl];
    
    NSString *cityName = [CityNameKey getOutStandard];
    if (cityName == nil) {
        cityName = @"上海";
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    switch (self.loadType) {
        case NormalProductType:     //正常模式
            [loadUrl appendString:@"products/list"];
            params[@"cityname"] = cityName;
            break;
        case SearchCategoryType:    //查询分类
            [loadUrl appendString:@"products/list"];
            params[@"adtype"] = self.searchText;
            params[@"cityname"] = cityName;
            break;
        case SearchProductType:     //查询关键字
            [loadUrl appendString:@"products/searchwords"];
            params[@"txt"] = self.searchText;
            params[@"city"] = cityName;
            break;
        case admentNameType:        //  查询广告商
            [loadUrl appendString:@"products/adproduct"];
            params[@"advertiserno"] = self.searchText;
            params[@"city"] = cityName;
            break;
        default:
            break;
    }
    int sort = self.sorctBtn.isSelected == YES ? 2 : 1;
    params[@"sort"] = @ (sort);//1-降序、2-升序
    params[@"pageindex"] = @(self.pageIndex);
    params[@"pagesize"]  = @ (pagesize);
    params[@"key"] = key;
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:loadUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.tableView.mj_header endRefreshing];
//        NSLog(@"%@",responseObject);
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            NSArray *array = [productList mj_objectArrayWithKeyValuesArray:responseObject[@"Results"][@"List"]];
            [self.productArray addObjectsFromArray:array];
            
        }else{
            [SVProgressHUD showInfoWithStatus:@"已经加载完毕！"];
        }
        if (self.total <= self.pageIndex * pagesize) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            [self.tableView.mj_footer endRefreshing];
        }
        self.pageIndex ++;
        [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"请求失败，稍后重试！"];
    }];
}

#pragma mark - tableview的数据源和代理方法


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.productArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    INGProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.productModle = self.productArray[indexPath.row];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    INGProductInfoViewController *vc = [[INGProductInfoViewController alloc]init];
    
    vc.title = @"产品详情";
    productList *modle = self.productArray[indexPath.row];
    vc.productName = modle.ProductNo;
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    productList *modle = self.productArray[indexPath.row];
    return modle.cellHeight;
}
#pragma  mark - textField代理

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.navigationController popViewControllerAnimated:NO];
    INGSearchViewController *searchVC = [[INGSearchViewController alloc]init];
    [self presentViewController:searchVC animated:YES completion:nil];
    
//    INGSingletonSearch *searchVC = [INGSingletonSearch sharedINGSingletonSearch];
//    [self presentViewController:searchVC animated:YES completion:nil];
    
    return NO;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:INGUserLoginOrOutNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:INGCityDidSelectNotification object:nil];
}
@end
