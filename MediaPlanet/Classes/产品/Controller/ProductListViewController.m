//
//  ProductListViewController.m
//  MediaPlanet
//
//  Created by eric on 16/9/13.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "ProductListViewController.h"
#import "ProductListDataViewController.h"
#import "TypeSelectedView.h"
#import "ProductListTableViewCell.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import "productList.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "INGProductInfoViewController.h"
#import "INGSearchViewController.h"
#import "INGMapViewController.h"
#import "INGNavigationController.h"

@interface ProductListViewController ()<TypeSelectedViewDelegate,UITableViewDelegate,UITableViewDataSource,ProductListTableViewCellDelegate>

@property (nonatomic, strong) ProductListDataViewController* productListDataViewController;

/** 请求页数 */
@property (nonatomic, assign) NSInteger pageIndex;

/** 模型数组 */
@property (nonatomic, strong) NSMutableArray *productArray;

/** 产品总数 */
@property (nonatomic, assign) NSInteger total;

/** 请求的参数 */
@property (nonatomic, strong) NSMutableDictionary *params;
/**
 *  请求时传的参数  不传返回所有商品，传NO返回普通产品，传YES返回拼单产品
 */
@property (nonatomic, strong) NSString* isgroup;

@end

static NSInteger const pagesize = 10;

@implementation ProductListViewController

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
    self.productListDataViewController = [[ProductListDataViewController alloc]init];
    [self configureNavigationView];
    [self configureSelectedView];
    [self configureTableView];
    self.isgroup = @"false";
    [self setupRefresh];
}

-(void)configureNavigationView
{
    self.navigationItem.title = @"产品列表";
    //设置导航栏右边按钮-
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"Search" highImage:@"Search" target:self action:@selector(searchClick)];
}

-(void)configureSelectedView
{
    [self.view addSubview:self.productListDataViewController.typeSelectedView];
    self.productListDataViewController.typeSelectedView.delegate = self;
    self.productListDataViewController.typeSelectedView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,64).heightIs(screenH*0.07);
}

-(void)configureTableView
{
    [self.view addSubview:self.productListDataViewController.customTableView];
    
    self.productListDataViewController.customTableView.delegate = self;
    self.productListDataViewController.customTableView.dataSource = self;
    
    self.productListDataViewController.customTableView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.productListDataViewController.typeSelectedView,0).bottomEqualToView(self.view);
}


/** 初始化刷新控件 */

-(void)setupRefresh
{
    self.productListDataViewController.customTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    [self.productListDataViewController.customTableView.mj_header beginRefreshing];
    self.productListDataViewController.customTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
}
/**
 *  点击右上角搜索按钮跳转
 */
-(void)searchClick
{
    INGSearchViewController* searchViewController = [[INGSearchViewController alloc]init];
    [self.navigationController pushViewController:searchViewController animated:YES];
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
    
    int sort = 2;//self.sorctBtn.isSelected == YES ? 2 : 1;
    params[@"sort"] = @ (sort);//1-降序、2-升序
    params[@"pageindex"] = @(self.pageIndex);
    params[@"pagesize"]  = @(pagesize);
    params[@"key"] = key;
    params[@"isgroup"] = self.isgroup;
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
        //        NSLog(@"%@",responseObject);
        if (self.params != params) {
            [SVProgressHUD dismiss];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        [self.productListDataViewController.customTableView.mj_header endRefreshing];
        [self.productArray removeAllObjects];
        [self.productListDataViewController.customTableView reloadData];
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            NSArray *array = [productList mj_objectArrayWithKeyValuesArray:responseObject[@"Results"][@"List"]];
            [self.productArray addObjectsFromArray:array];
            self.total = [responseObject[@"Results"][@"Total"] integerValue];
            
            if (  self.total <= self.pageIndex * pagesize) {
                [self.productListDataViewController.customTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                
                [self.productListDataViewController.customTableView.mj_footer endRefreshing];
            }
            self.pageIndex ++;
        }else{
            [self.productListDataViewController.customTableView.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:@"未查询到相关产品"];
        }
        [self.productListDataViewController.customTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.productListDataViewController.customTableView.mj_header endRefreshing];
        [self.productListDataViewController.customTableView.mj_footer endRefreshing];
        
        if (self.params != params) {
            return ;
        }
        
        [self.productArray removeAllObjects];
        [self.productListDataViewController.customTableView reloadData];
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
    int sort = 2;//self.sorctBtn.isSelected == YES ? 2 : 1;
    params[@"sort"] = @ (sort);//1-降序、2-升序
    params[@"pageindex"] = @(self.pageIndex);
    params[@"pagesize"]  = @ (pagesize);
    params[@"key"] = key;
    params[@"isgroup"] = self.isgroup;
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
        [self.productListDataViewController.customTableView.mj_header endRefreshing];
        //        NSLog(@"%@",responseObject);
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            NSArray *array = [productList mj_objectArrayWithKeyValuesArray:responseObject[@"Results"][@"List"]];
            [self.productArray addObjectsFromArray:array];
            
        }else{
            [SVProgressHUD showInfoWithStatus:@"已经加载完毕！"];
        }
        if (self.total <= self.pageIndex * pagesize) {
            
            [self.productListDataViewController.customTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            [self.productListDataViewController.customTableView.mj_footer endRefreshing];
        }
        self.pageIndex ++;
        [self.productListDataViewController.customTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        NSLog(@"%@",error);
        [self.productListDataViewController.customTableView.mj_header endRefreshing];
        [self.productListDataViewController.customTableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"请求失败，稍后重试！"];
    }];
}


-(void)findSelectedOrderTypeModel
{
//    if (self.productListDataViewController.typeSelectedArr.count>0)
//    {
//        for (OrderTypeModel* tempModel in self.productListDataViewController.typeSelectedArr)
//        {
//            if ([self.orderTypeModel.Guid isEqualToString:tempModel.Guid])
//            {
//                tempModel.IsSelected = YES;
//            }
//        }
//    }
}


#pragma mark -UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return self.productArray.count>0?self.productArray.count:0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.01;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductListTableViewCell* productListTableViewCell = [ProductListTableViewCell tableView:tableView dequeueReusableCellWithReuseIdentifier:ProductListTableViewCellId forIndexPath:indexPath];
    productListTableViewCell.delegate = self;
    [productListTableViewCell layoutWithObject:self.productArray[indexPath.section]];
    return productListTableViewCell;
}
#pragma mark -UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    productList* productList = self.productArray[indexPath.section];
    /**
     *  标题高度
     */
    /**
     *  加点空格，留个位置给“拼单产品”
     */
    NSString* spaceStr;
    if (productList.IsGroup == 1)
    {
        spaceStr = @"                   ";
    }
    else
    {
        spaceStr = @"";
    }
    spaceStr = [spaceStr stringByAppendingString:productList.ProductName];
    CGFloat titleHeight = [self calculateHeighWithLabelContent:spaceStr
                                                  WithFontName:nil
                                                  WithFontSize:14
                                                     WithWidth:screenW-40
                                                      WithBold:NO];
    /**
     *  广告商高度
     */
    CGFloat adsHeight = [self calculateHeighWithLabelContent:[NSString stringWithFormat:@"广告商：%@",productList.AdvertiserName]
                                                  WithFontName:nil
                                                  WithFontSize:13
                                                     WithWidth:screenW-40
                                                      WithBold:NO];
    /**
     *  价格那一行的高度
     */
    CGFloat priceHeight = [self calculateHeighWithLabelContent:[NSString stringWithFormat:@"%f",productList.ProductPrice0]
                                                WithFontName:nil
                                                WithFontSize:13
                                                   WithWidth:screenW-40
                                                    WithBold:NO];
    /**
     *  地址栏的高度
     */
    CGFloat locHeight;
    if ([productList.ProductLoc isEqualToString:@""] || !productList.ProductLoc)
    {
        //去掉与上面控件的间距10
        locHeight = -10;
    }
    else
    {
        locHeight = [self calculateHeighWithLabelContent:productList.ProductLoc
                                            WithFontName:@"迷你简楷体"
                                            WithFontSize:13
                                               WithWidth:screenW-40
                                                WithBold:NO];
    }
    
    //图片高度+标题高度+广告商高度+价格高度+地址栏高度+空白
    return (screenW-20)*0.62+titleHeight+adsHeight+priceHeight+locHeight+60;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    INGProductInfoViewController *vc = [[INGProductInfoViewController alloc]init];
    
    vc.title = @"产品详情";
    productList *modle = self.productArray[indexPath.row];
    vc.productName = modle.ProductNo;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - TypeSelectedViewDelegate选择普通产品/拼单产品
-(void)didClickWashCarButtonWithTypeSelectedView:(TypeSelectedView *)typeSelectedView
{
    if ([self.isgroup isEqualToString:@"false"])
    {
        return;
    }
    else
    {
        self.isgroup = @"false";
        [self loadNew];
    }
}

-(void)didClickMaintenanceButtonWithTypeSelectedView:(TypeSelectedView *)typeSelectedView
{
    self.isgroup = @"true";
    [self loadNew];
    
}

#pragma mark - ProductListTableViewCellDelegate
-(void)didclickMapButton:(ProductListTableViewCell *)productListTableViewCell
{
    NSIndexPath* indexPath = [self.productListDataViewController.customTableView indexPathForCell:productListTableViewCell];
    
    INGMapViewController *mapVC = [[INGMapViewController alloc]init];
     productList *modle = self.productArray[indexPath.row];
//        mapVC.infoModle = modle.ProductLoc;
    INGNavigationController *nav = [[INGNavigationController alloc]initWithRootViewController:mapVC];
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [root presentViewController:nav animated:YES completion:nil];
}
@end
