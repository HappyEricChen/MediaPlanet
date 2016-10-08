//
//  INGSettingTableViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/3.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  设置界面

#import "INGSettingTableViewController.h"
#import "INGMesCell.h"
#import "personalInfo.h"
#import "INGLoginViewController.h"
#import "INGFeedbackViewController.h"
//#import "INGOnlineLvaveViewController.h"
#import "INGNavigationController.h"
#import "NSString+INGExtension.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>

@interface INGSettingTableViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 标题数组 */
@property (nonatomic, strong) NSArray *titleArray;
/** icon数组 */
@property (nonatomic, strong) NSArray *imgArray;
/** 模型数组 */
@property (nonatomic, strong) NSMutableArray *infoArray;
/** 数组 */
@property (nonatomic, strong) NSArray *connectArray;

/** tableView */
@property (nonatomic, strong) UITableView *tableView;

@end


static NSString *const MeinfoCell = @"MeinfoCell";

@implementation INGSettingTableViewController
/** 懒加载 */
-(NSArray *)titleArray
{
    if (_titleArray == nil) {
        _titleArray = @[@"意见反馈"];
    }
    return _titleArray;
}

-(NSArray *)imgArray
{
    if (_imgArray == nil) {
        _imgArray = @[@"contect_1"];
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
    
    self.navigationItem.title = @"系统设置";
    [self setupTabView];
    [self.view setupGifBG];
    
    self.connectArray = [personalInfo mj_objectArrayWithKeyValuesArray:self.infoArray];
    
    [self performSelector:@selector(SVPdismiss) withObject:nil afterDelay:0.2];
}
-(void)SVPdismiss
{
    
    [SVProgressHUD dismiss];
}
-(void)setupTabView
{
    self.tableView = [[UITableView alloc]init];
    self.tableView.x = 0;
    self.tableView.y = 64;
    self.tableView.width = screenW;
    self.tableView.height = screenH - 64 - 44;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([INGMesCell class]) bundle:nil] forCellReuseIdentifier:MeinfoCell];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //footerView
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 70)];
    
    UIImage *buttonView = [UIImage imageNamed:@"email_button"];
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    exitButton.frame = CGRectMake(20, 20, screenW - 40, 44);
    [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitButton setBackgroundImage:[buttonView stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    //设置button的背景图不被拉伸
    [exitButton addTarget:self action:@selector(loginShow) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:exitButton];

    self.tableView.tableFooterView = footerView;
}
//退出登录
-(void)loginShow
{
    //删除已存在的账号信息
    
    //账号的key
    NSString *userKey = @"CFBundleUserNameString";
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:userKey];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:strStander];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //发出退出通知
    [[NSNotificationCenter defaultCenter]postNotificationName:INGUserLoginOrOutNotification object:nil];
    
    [SVProgressHUD showInfoWithStatus:@"您已退出登录"];
    //跳转到登录界面
    
    INGLoginViewController *loginViewController = [[INGLoginViewController alloc]init];
//    loginViewController.navigationItem.hidesBackButton = YES;
//    [self.navigationController pushViewController:loginViewController animated:YES];
    INGNavigationController *nav = [[INGNavigationController alloc]initWithRootViewController:loginViewController];
    
    [self presentViewController:nav animated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:NO];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    INGMesCell *cell = [tableView dequeueReusableCellWithIdentifier:MeinfoCell];
    
    cell.info = self.connectArray[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    INGFeedbackViewController *vc = [[INGFeedbackViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
