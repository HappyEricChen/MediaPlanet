//
//  INGMessageBoardViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/13.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  留言板

#import "INGMessageBoardViewController.h"
#import "INGOnlineLvaveViewController.h"
#import "INGMessageTableViewCell.h"
#import "listResultModle.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <MJRefresh.h>
#import <SVProgressHUD.h>

@interface INGMessageBoardViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

/** 留言模型数组 */
@property (nonatomic, strong) NSMutableArray *resultArray;

/** 留言数量 */
@property (nonatomic, assign) NSUInteger Total;

/** 请求的页面索引 */
@property (nonatomic, assign) NSInteger pageIndex;

/** 请求网络的参数 */
@property (nonatomic, strong) NSMutableDictionary *parmas;

@end
static NSString *const messageID = @"messageID";
static NSInteger const pageSize = 10;
@implementation INGMessageBoardViewController

-(NSMutableArray *)resultArray
{
    if (_resultArray == nil) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}
-(NSMutableDictionary *)parmas
{
    if (_parmas == nil) {
        _parmas = [NSMutableDictionary dictionary];
    }
    return _parmas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self.view setupGifBG];
    self.navigationItem.title = @"在线留言";
    
    UIImageView *bottomImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"col_bottom"]];
    bottomImage.width = screenW;
    [self.bottomView insertSubview:bottomImage atIndex:0];
    [self refresh];
}


-(void)setupTableView
{
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([INGMessageTableViewCell class]) bundle:nil] forCellReuseIdentifier:messageID];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
//    [self.tableView setRowHeight:165];
}


- (IBAction)messageClick:(id)sender {
    INGOnlineLvaveViewController *vc = [[INGOnlineLvaveViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)refresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewMsg)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMsg)];
}

-(void)loadNewMsg
{
    
    NSMutableString *msgUrl = [NSMutableString string];
    
    [msgUrl appendString:apiUrl];
    [msgUrl appendString:@"pcenter/qmsg"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    self.pageIndex = 1;
    params[@"pageindex"] = @ (self.pageIndex);
    params[@"pagesize"] = @ (pageSize);
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"key"]=  key;//@"4DB03900-7322-4C9C-A5D5-94AD7E8A5703";
    params[@"ts"] = timeSp;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    self.parmas = params;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:msgUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.parmas != params) {
            return ;
        }
        BOOL isSuccess = [responseObject[@"IsSuccess"] boolValue];
//        NSLog(@"%@",responseObject);
        [self.tableView.mj_header endRefreshing];
        if (isSuccess) {
            self.Total = [responseObject[@"Results"][@"Total"] integerValue];
            [self.resultArray removeAllObjects];
            self.resultArray = [listResultModle mj_objectArrayWithKeyValuesArray:responseObject[@"Results"][@"List"]];
            if (self.Total <= self.pageIndex * pageSize ) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            
            self.pageIndex ++;
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"ErrorMessage"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        if (self.parmas != params) {
            return ;
        }
    }];
}

-(void)loadMoreMsg
{
    [self.tableView.mj_header endRefreshing];
    NSMutableString *msgUrl = [NSMutableString string];
    [msgUrl appendString:apiUrl];
    [msgUrl appendString:@"pcenter/qmsg"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageindex"] = @ (self.pageIndex);
    params[@"pagesize"] = @ (pageSize);
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"key"]=  key;//@"4DB03900-7322-4C9C-A5D5-94AD7E8A5703";
    params[@"ts"] = timeSp;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    self.parmas = params;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:msgUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.parmas != params) {
            return ;
        }
        BOOL isSuccess = [responseObject[@"IsSuccess"] boolValue];
//        NSLog(@"%@",responseObject);
        if (isSuccess) {
            
            NSArray *array = [listResultModle mj_objectArrayWithKeyValuesArray:responseObject[@"Results"][@"List"]];
            [self.resultArray addObjectsFromArray:array];
            if (self.Total <= self.pageIndex * pageSize ) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            
            self.pageIndex ++;
            
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"ErrorMessage"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.parmas != params) {
            return ;
        }
    }];

}
#pragma mark - Datesource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    INGMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:messageID];
    cell.resultModle = self.resultArray[indexPath.row];
    return cell;
}
#pragma mark - Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    listResultModle *modle = self.resultArray[indexPath.row];
    return modle.cellHeight + 5;
}
@end
