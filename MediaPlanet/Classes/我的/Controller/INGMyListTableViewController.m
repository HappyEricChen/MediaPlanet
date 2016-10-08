//
//  INGMyListTableViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/3.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  我的订单

#import "INGMyListTableViewController.h"
#import "INGMyListTableViewCell.h"
#import "INGOderInfoViewController.h"
#import "loginMedel.h"
#import "myListModle.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MGSwipeTableCell.h>

//返回的每页数据个数
static NSInteger const pagesize = 10;

@interface INGMyListTableViewController ()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;

/** 订单模型数组 */
@property (nonatomic, strong) NSMutableArray *listArray;

/** 当前参数 */
@property (nonatomic, strong) NSDictionary *params;

/** 当前页数 */
@property (nonatomic, assign) NSInteger pageindex;
/** 订单总数 */
@property (nonatomic, assign) NSInteger total;


@end

static NSString *const listCell = @"listCell";

@implementation INGMyListTableViewController

-(NSMutableArray *)listArray
{
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setupGifBG];
    [self setupTableView];

    [self refresh];
}

-(void)setupTableView
{
    CGFloat tableViewX = 0;
    CGFloat tableViewY = 64;
    CGFloat tableViewW = screenW;
    CGFloat tableViewH = screenH - 64;
    CGRect rect = CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH);
    self.tableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStyleGrouped];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setBackgroundColor:[UIColor whiteColor]];//JCColor(238, 238, 238)
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([INGMyListTableViewCell class]) bundle:nil] forCellReuseIdentifier:listCell];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    CGFloat bottom = self.tabBarController.tabBar.height;
    
    //设置内边距
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, bottom, 0);
    //设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self.view addSubview:self.tableView];
    
}

/** 设置刷新 */
-(void)refresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewList)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}
-(void)loadNewList
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSMutableString *listUrl = [NSMutableString string];
    [listUrl appendString:apiUrl];
    [listUrl appendString:@"products/qorder"];
    self.pageindex = 1 ;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageindex"] = @ (self.pageindex);
    params[@"pagesize"] = @(pagesize);
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    params[@"key"] = key;
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
        NSLog(@"list responseObject = %@",responseObject);
        loginMedel *modle = [loginMedel mj_objectWithKeyValues:responseObject];
        
        if (modle.IsSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"加载完成"];
            self.total = [responseObject[@"Results"][@"Total"] integerValue];
            if (self.total < pagesize) {
//                self.tableView.mj_footer.hidden = YES;
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
//                self.tableView.mj_footer.hidden = NO;
                [self.tableView.mj_footer endRefreshing];
            }
            
            self.listArray = [myListModle mj_objectArrayWithKeyValuesArray:responseObject[@"Results"][@"List"]];
            self.pageindex ++;
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:@"没有订单信息"];
//            self.tableView.mj_footer.hidden = YES;
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        if (self.params != params) return ;
         [SVProgressHUD showErrorWithStatus:@"请求数据出错"];
    }];
    
}

-(void)loadMore
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSMutableString *listUrl = [NSMutableString string];
    [listUrl appendString:apiUrl];
    [listUrl appendString:@"products/qorder"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageindex"] = @(self.pageindex) ;
    params[@"pagesize"] = @(pagesize);
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    params[@"key"] = key;
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    
    params[@"sign"] = sign;
    
    [params removeObjectForKey:@"key"];
    
    self.params = params;
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];

    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    
    [manager POST:listUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        //如果请求返回的参数不等请求之前的参数，就不做处理
        if (self.params != params) return ;
//        NSLog(@"%@",responseObject);
        loginMedel *modle = [loginMedel mj_objectWithKeyValues:responseObject];
        if (modle.IsSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"加载完成"];
            NSArray *moreListArray = [myListModle mj_objectArrayWithKeyValuesArray:responseObject[@"Results"][@"List"]];
            [self.listArray addObjectsFromArray:moreListArray];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];

        }else{
            
            [SVProgressHUD showInfoWithStatus:@"没有订单信息"];
        }
        
        NSInteger Total = (self.total - self.pageindex * pagesize);
        if (Total < pagesize) {
//            self.tableView.mj_footer.hidden = YES;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
//            self.tableView.mj_footer.hidden = NO;
            [self.tableView.mj_footer endRefreshing];
        }
        self.pageindex ++;

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.params != params) return ;
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试"];
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    INGMyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell forIndexPath:indexPath];
//    MGSwipeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell forIndexPath:indexPath];
    myListModle *modle = self.listArray[indexPath.section];
    
    cell.modle = modle;
    cell.delegate = self;
    
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"删除" icon:nil backgroundColor:[UIColor redColor]]];
    
    /**
     [self.listArray removeObjectAtIndex:indexPath.row];
     [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
     [self.tableView reloadData];
     */
    //[MGSwipeButton buttonWithTitle:nil icon:[UIImage imageNamed:@"close"] backgroundColor:[UIColor clearColor]]
    //[MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor]],
    //[MGSwipeButton buttonWithTitle:@"More" backgroundColor:[UIColor lightGrayColor]],
    return cell;

}
/** 删除取消订单 */
-(BOOL)isRemoveOrder:(NSString *)orderNO withIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD showWithStatus:@"加载中"];
    __block BOOL isRemove = NO;
    
    NSMutableString *listUrl = [NSMutableString string];
    [listUrl appendString:apiUrl];
    [listUrl appendString:@"products/removeorder"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = orderNO;
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    params[@"key"] = key;
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    
    params[@"sign"] = sign;
    
    [params removeObjectForKey:@"key"];
    
    self.params = params;
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    
    [manager POST:listUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //如果请求返回的参数不等请求之前的参数，就不做处理
        if (self.params != params) return ;
        //        NSLog(@"%@",responseObject);

        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"删除完成"];
            [self.listArray removeObjectAtIndex:indexPath.section];
            NSIndexSet *setSecton = [[NSIndexSet alloc]initWithIndex:indexPath.section];
            [_tableView deleteSections:setSecton withRowAnimation:UITableViewRowAnimationLeft];
//            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }else{
            [SVProgressHUD showInfoWithStatus:@"不能删除处理中的订单"];
            isRemove = NO;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return ;
        [SVProgressHUD showErrorWithStatus:@"请求数据出错"];
        isRemove = NO;
        
    }];
    
    return isRemove;
}


#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    INGOderInfoViewController *infoVC = [[INGOderInfoViewController alloc]init];
    myListModle *modle = self.listArray[indexPath.section];
    infoVC.orderNo = modle.OrderNo;
    [self.navigationController pushViewController:infoVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    myListModle *modle = self.listArray[indexPath.row];
    return 130;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 30)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    myListModle *modle = self.listArray[section];
    UILabel *dateLable = [[UILabel alloc]init];
    dateLable.x = 10;
    dateLable.y = 0;
    dateLable.width = 150;
    dateLable.height = 30;
    dateLable.text = modle.OrderTime;
    dateLable.textColor = [UIColor blackColor];
    dateLable.font = [UIFont systemFontOfSize:14];
    
    UILabel *stateLable = [[UILabel alloc]init];
    stateLable.x = screenW - 80;
    stateLable.y = 0;
    stateLable.width = 70;
    stateLable.height = 30;
    stateLable.textAlignment = NSTextAlignmentRight;
    stateLable.text = modle.OrderStateChar;
    /**
     1	已付款
     2	已签约
     3	已取消
     4	已预约
     */
    if ([modle.OrderStateChar isEqualToString:@"已付款"]) {
        stateLable.textColor = [UIColor blackColor];
    }else if([modle.OrderStateChar isEqualToString:@"已签约"]){
        stateLable.textColor = [UIColor blueColor];
    }else if([modle.OrderStateChar isEqualToString:@"已取消"]){
        stateLable.textColor = [UIColor redColor];
    }else if([modle.OrderStateChar isEqualToString:@"已预约"]){
        stateLable.textColor = [UIColor orangeColor];
    }
    
    
    stateLable.font = [UIFont systemFontOfSize:14];
    
    [headerView addSubview:stateLable];
    [headerView addSubview:dateLable];
    return headerView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = JCColor(238, 238, 238);
    
    myListModle *modle = self.listArray[section];
    
    if ([modle.OrderStateChar isEqualToString:@"已预约"]) {
        footerView.frame = CGRectMake(0, 0, screenW, 55);
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 45)];
        contentView.backgroundColor = [UIColor whiteColor];
        
        [footerView addSubview:contentView];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.width = 70;
        cancelBtn.height = 25;
        cancelBtn.x = screenW - 80;
        cancelBtn.y = 10;
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelBtn.tag = section;
        [cancelBtn setTitle:@"已取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        cancelBtn.backgroundColor = [UIColor redColor];
        [cancelBtn addTarget:self action:@selector(canceledClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [footerView addSubview:cancelBtn];
    }else{
        footerView.frame = CGRectMake(0, 0, screenW, 20);
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 10)];
        contentView.backgroundColor = [UIColor whiteColor];
        [footerView addSubview:contentView];
    }
    return footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    myListModle *modle = self.listArray[section];
    
    if ([modle.OrderStateChar isEqualToString:@"已预约"]) {
        
        return 55.0f;
    }else{
        return 20.0f;
    }
    
}

-(void)canceledClick:(UIButton *)button
{
    NSLog(@"@%s",__func__);
    [SVProgressHUD showWithStatus:@"发送中"];
    myListModle *modle = self.listArray[button.tag];
    
    NSMutableString *loadUrl = [NSMutableString string];
    [loadUrl appendString:apiUrl];
    [loadUrl appendString:@"products/cancelorder"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"orderNo"] = modle.OrderNo;
    params[@"ts"] = timeSp;
    params[@"key"] = key;
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    
    params[@"sign"] = sign;
    
    [params removeObjectForKey:@"key"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求头
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    
    [manager POST:loadUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            
            [SVProgressHUD showInfoWithStatus:@"取消成功"];

            modle.OrderStateChar = @"已取消";

        }else{
            /**
             
             1	已付款
             2	已签约
             3	已取消
             4	已预约
             
             */
            [SVProgressHUD showInfoWithStatus:@"订单状态已改变"];
            if (responseObject[@"Results"]) {
                NSInteger Results = [responseObject[@"Results"] integerValue];
                switch (Results) {
                    case 1:
                        modle.OrderStateChar = @"已付款";

                        break;
                    case 2:
                        modle.OrderStateChar = @"已签约";

                        break;
                    case 3:
                        modle.OrderStateChar = @"已取消";

                        break;
                    case 4:
                        modle.OrderStateChar = @"已预约";

                        break;
                    default:
                        break;
                }
                
                for (myListModle *tempModle in self.listArray) {
                    if (tempModle.OrderNo == modle.OrderNo) {
                        tempModle.OrderStateChar = modle.OrderStateChar;
                    }
                    
                }
            }
            
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络错误，请稍后重试"];
    }];
}


#pragma mark - MGSwipeTableCell侧滑按钮的回调

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion
{
//    NSLog(@"Delegate: button tapped, %@ position, index %d, from Expansion: %@",
//          direction == MGSwipeDirectionLeftToRight ? @"left" : @"right", (int)index, fromExpansion ? @"YES" : @"NO");
//    
    if (direction == MGSwipeDirectionRightToLeft && index == 0) {
        //delete button 删除按钮
        
        NSIndexPath * path = [_tableView indexPathForCell:cell];
        myListModle *modle = self.listArray[path.section];
        [self isRemoveOrder:modle.OrderNo withIndexPath:path];
        
        return NO; //Don't autohide to improve delete expansion animation
    }
    
    return YES;
}


/*
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.tableView.editing)//----通过表视图是否处于编辑状态来选择是左滑删除，还是多选删除。
//    {
//        //当表视图处于没有未编辑状态时选择多选删除
//        return UITableViewCellEditingStyleDelete| UITableViewCellEditingStyleInsert;
//    }
//    else
//    {
//        //当表视图处于没有未编辑状态时选择左滑删除
//        return UITableViewCellEditingStyleDelete;
//    }
    [tableView setEditing:YES animated:YES];
    return UITableViewCellEditingStyleDelete;
}
//设置进入编辑状态时，Cell不会缩进

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

//根据不同的editingstyle执行数据删除操作（点击左滑删除按钮的执行的方法）
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        [self.listArray removeObjectAtIndex:indexPath.row];
//        // Delete the row from the data source.
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//    else if(editingStyle == (UITableViewCellEditingStyleDelete| UITableViewCellEditingStyleInsert))
//    {
//        
//    }
//    
//}
*/
@end
