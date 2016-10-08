//
//  INGConnectUsTableViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/3.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGConnectUsTableViewController.h"
#import "INGMesCell.h"
#import "personalInfo.h"
#import "INGOnlineLvaveViewController.h"
#import "INGMessageBoardViewController.h"
#import <MJExtension.h>

@interface INGConnectUsTableViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 标题数组 */
@property (nonatomic, strong) NSArray *titleArray;
/** icon数组 */
@property (nonatomic, strong) NSArray *imgArray;
/** 模型数组 */
@property (nonatomic, strong) NSMutableArray *infoArray;
/** 数组 */
@property (nonatomic, strong) NSArray *connectArray;

/** tableview */
@property (nonatomic, strong) UITableView *tableView;

@end
static NSString *const cellID = @"cellID";
@implementation INGConnectUsTableViewController
/** 懒加载 */
-(NSArray *)titleArray
{
    if (_titleArray == nil) {
        _titleArray = @[@"客服电话",@"在线留言"];
    }
    return _titleArray;
}

-(NSArray *)imgArray
{
    if (_imgArray == nil) {
        _imgArray = @[@"contect",@"contect_1"];
    }
    return _imgArray;
}
-(NSMutableArray *)infoArray
{
    if (_infoArray == nil) {
        _infoArray = [NSMutableArray array];
        for (int i = 0; i < self.imgArray.count; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"headerIcon"] = self.imgArray[i];
            dic[@"titleText"] = self.titleArray[i];
            [_infoArray addObject:dic];
        }
    }
    return _infoArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self.view setupGifBG];
    
    self.connectArray = [personalInfo mj_objectArrayWithKeyValuesArray:self.infoArray];
}

-(void)setupTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screenW, screenH - 64)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([INGMesCell class]) bundle:nil] forCellReuseIdentifier:cellID];

    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    INGMesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.info = self.connectArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        INGMessageBoardViewController *lvaveVC = [[INGMessageBoardViewController alloc]init];
        [self.navigationController pushViewController:lvaveVC animated:YES];
    }else if (indexPath.row == 0){
        NSString *phoneStr = @"13681704531";//
        NSMutableString *phone = [[NSMutableString alloc]initWithFormat:@"telprompt://%@",phoneStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];

    }
}


@end
