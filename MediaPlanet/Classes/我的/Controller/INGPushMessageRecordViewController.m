//
//  INGPushMessageRecordViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/8/25.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  消息推送记录页面

#import "INGPushMessageRecordViewController.h"
#import "INGPushInfoController.h"
#import "INGPushMSGCell.h"

@interface INGPushMessageRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;

@end

static NSString *const cellID = @"pushCell";

@implementation INGPushMessageRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setupGifBG];
    [self setUpTableView];
}

-(void)setUpTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screenW, screenH - 64)];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([INGPushMSGCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}
#pragma mark - tableview数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    INGPushMSGCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}
#pragma mark - tableview的代理方法

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 103.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    INGPushInfoController *infoVC = [[INGPushInfoController alloc]init];
    infoVC.title = @"消息详情";
    [self.navigationController pushViewController:infoVC animated:YES];
}
@end
