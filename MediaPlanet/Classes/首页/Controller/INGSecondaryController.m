//
//  INGSecondaryController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/7/6.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  二级分类

#import "INGSecondaryController.h"
//#import "INGProductViewController.h"
#import "ProductListViewController.h"
#import "adTypeModle.h"
#import "INGSecondClassesCell.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import <MJExtension.h>
#import <AFNetworking.h>

@interface INGSecondaryController ()
/** 二级分类数据模型数组 */
@property (nonatomic, strong) NSMutableArray *typeArray;

@end
static NSString *const ID = @"SecondID";

@implementation INGSecondaryController

-(NSMutableArray *)typeArray
{
    if (_typeArray == nil) {
        _typeArray = [NSMutableArray array];
    }
    return _typeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //NSLog(@"secondArray = %@",self.secondArray);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([INGSecondClassesCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
//    [self.tableView registerClass:[INGSecondClassesCell class] forCellReuseIdentifier:ID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.secondArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    INGSecondClassesCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.modle = self.typeArray[indexPath.row];
    return cell;
}

-(void)setSecondArray:(NSArray *)secondArray
{
    _secondArray = secondArray;
    self.typeArray = [adTypeModle mj_objectArrayWithKeyValuesArray:secondArray];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    adTypeModle *modle = self.typeArray[indexPath.row];
    ProductListViewController *productVC = [[ProductListViewController alloc]init];

    productVC.loadType = SearchCategoryType;
    productVC.searchText = [NSString stringWithFormat:@"%ld",(long)modle.Id];
    [self.navigationController pushViewController:productVC animated:YES];
    /*
    NSMutableString *cattegoryUrl = [NSMutableString string];
    [cattegoryUrl appendString:apiUrl];
    [cattegoryUrl appendString:@"products/list"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //cityname:string,adtype:int,pageindex:int,pagesize:int
    NSString *cityName = [CityNameKey getOutStandard];
    params[@"cityname"] = cityName;
    adTypeModle *modle = self.typeArray[indexPath.row];
    params[@"adtype"] = @(modle.Id);
    params[@"pageindex"] = @ 1;
    params[@"pagesize"] = @ 10;
    params[@"key"] = key;
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    
    [manager POST:cattegoryUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
     */
}
@end
