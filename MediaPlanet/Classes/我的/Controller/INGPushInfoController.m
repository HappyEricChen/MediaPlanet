//
//  INGPushInfoController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/8/25.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGPushInfoController.h"
#import "INGPushInfoCell.h"

@interface INGPushInfoController ()<UITableViewDataSource,UITableViewDelegate>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;

@end

static NSString *const cellID = @"pushInfoCell";

@implementation INGPushInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setupGifBG];
    [self setUpTableView];
}
-(void)setUpTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screenW, screenH - 64)];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:(NSStringFromClass([INGPushInfoCell class])) bundle:nil] forCellReuseIdentifier:cellID];
    
    self.tableView = tableView;
    [self.view addSubview:tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    INGPushInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}
@end
