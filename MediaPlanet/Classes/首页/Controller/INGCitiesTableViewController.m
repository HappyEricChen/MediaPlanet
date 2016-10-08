//
//  INGCitiesTableViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/7.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  城市选择

#import "INGCitiesTableViewController.h"
#import "citiesModel.h"
#import "INGCitiesTableViewCell.h"
#import "INGHotCitiesTableViewCell.h"
#import "hotFrameModel.h"
#import "INGHotView.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJExtension.h>

static NSString * const cellID = @"citiesID";
static NSString *const hotCell = @"hotCell";

@interface INGCitiesTableViewController ()<UITableViewDelegate,UITableViewDataSource,INGHotViewDelegate,AMapLocationManagerDelegate>
/** 城市分类 */
@property (nonatomic, strong) NSArray *citiesGroup;
/**  热门城市 */
@property (nonatomic, strong) NSMutableArray *hotCitiesArray;

/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** 地图管理者 */
@property (nonatomic, strong) AMapLocationManager *locationManager;

/** 定位城市的按钮 */
@property (nonatomic, strong) UIButton *loacationButton;

/** 支持的城市数组 */
@property (nonatomic, strong) NSArray *cityArray;
/** 后台传送的城市数据 */
@property (nonatomic, strong) NSMutableArray *mutCitiesArray;

@end

@implementation INGCitiesTableViewController
/** 懒加载 */
-(NSArray *)citiesGroup{
    if (_citiesGroup == nil) {
        _citiesGroup = [NSArray array];
        _citiesGroup = [citiesModel cityGroupArray];
    }
    return _citiesGroup;
}
-(NSArray *)cityArray
{
    if (_cityArray == nil) {
        _cityArray = @[@"上海",@"北京",@"广州"];
    }
    return _cityArray;
}
-(NSMutableArray *)hotCitiesArray
{
    if (_hotCitiesArray == nil) {
        _hotCitiesArray = [NSMutableArray array];
        for (citiesModel *model in self.citiesGroup) {
            hotFrameModel *f = [[hotFrameModel alloc]init];
            f.citiesModel = model;
            [_hotCitiesArray addObject:f];
        }
    }
    return _hotCitiesArray;
}

-(NSMutableArray *)mutCitiesArray
{
    if (_mutCitiesArray == nil) {
        _mutCitiesArray = [NSMutableArray array];
    }
    return _mutCitiesArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadCityData];
    [self setupTabelView];
    
    [self.view setupGifBG];
    [self performSelector:@selector(SVPdismiss) withObject:nil afterDelay:0.2];
    
    
//    UIImageView *verticalLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"col_verline"]];
//    verticalLine.x = screenW - 20;
//    verticalLine.y = 64;
//    verticalLine.width = 1;
//    verticalLine.height = screenH - 64;
//    [self.view addSubview:verticalLine];
//    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 64)];
//    topView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:topView];
    
}
-(void)SVPdismiss
{
    [SVProgressHUD dismiss];
}
/** 初始化tableview */
-(void)setupTabelView
{
    self.tableView = [[UITableView alloc]init];
    self.tableView.frame = [UIScreen mainScreen].bounds;
    self.tableView.y = 64;
    self.tableView.height = screenH - 64;
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.sectionIndexColor = [UIColor whiteColor];
//    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([INGCitiesTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    [self.tableView registerClass:[INGHotCitiesTableViewCell class] forCellReuseIdentifier:hotCell];
    [self.view addSubview:self.tableView];
    
    //当前定位城市
    UIView *headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 0, screenW, 70);
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *headerLable = [[UILabel alloc]init];
    headerLable.frame = CGRectMake(0, 3, screenW, 21);
    headerLable.backgroundColor = [UIColor clearColor];
    headerLable.textColor = [UIColor whiteColor];
    headerLable.text = @"    当前城市";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
//    [button addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
    if (self.locationCityName == nil) {
        
        [button setTitle:@"无法定位" forState:UIControlStateNormal];
    }else
    {
        [button setTitle:self.locationCityName forState:UIControlStateNormal];
    }
    [button addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"city_hot"] forState:UIControlStateNormal];
    button.frame = CGRectMake(30, CGRectGetMaxY(headerLable.frame)+ 5, 70, 33);
    self.loacationButton = button;
    [headerView addSubview:headerLable];
    [headerView addSubview:button];
    self.tableView.tableHeaderView = headerView;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

//    return self.citiesGroup.count ;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 1;
//    }
//    
//    citiesModel *groupCity = self.citiesGroup[section];
//    
//    return groupCity.cities.count;
//    return self.cityArray.count;
    return self.mutCitiesArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        INGHotCitiesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:hotCell ];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.hotFrame = self.hotCitiesArray[indexPath.section ];
//        [cell.hotView setDelegate:self];
//        return cell;
//    }
    INGCitiesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    citiesModel *citiesGroup = self.citiesGroup[indexPath.section];
//    cell.textLabel.text = citiesGroup.cities[indexPath.row];
//    cell.textLabel.text = self.cityArray[indexPath.row];
    cell.textLabel.text = self.mutCitiesArray[indexPath.row];
    return cell;
    
    
}

#pragma mark - tableView的代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        hotFrameModel *model = self.hotCitiesArray[indexPath.section];
//        return model.hotFrame.size.height + 5;
//    }
    return 44.0f;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

//    citiesModel *groupCity = self.citiesGroup[section];
//    return groupCity.title;
   return @"服务开通城市";

}
//-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    
//    NSArray *array = [self.citiesGroup valueForKey:@"title"];
//    NSMutableArray *Marray = [NSMutableArray array];
//    
//    for (int i = 0; i < array.count; i ++) {
//        NSString *str = array[i];
//        if ([str isEqualToString:@"热门"]) {
//            str = @"#";
//        }
//        [Marray addObject:str];
//    }
//    NSArray *resultArray = Marray;
//    return resultArray;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        
//    }else{
//        
//        citiesModel *group = self.citiesGroup[indexPath.section ];
//        //发出通知，告诉控制器，选中了那个城市
//        [[NSNotificationCenter defaultCenter] postNotificationName:INGCityDidSelectNotification object:nil userInfo:@{INGSelectCityName :group.cities[indexPath.row]}];
//        
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    //发出通知，告诉控制器，选中了那个城市
    [[NSNotificationCenter defaultCenter] postNotificationName:INGCityDidSelectNotification object:nil userInfo:@{INGSelectCityName :self.mutCitiesArray[indexPath.row]}];

    [self.navigationController popViewControllerAnimated:YES];

}
/** 设置tableView Section的headerview */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
    [header setBackgroundColor:[UIColor clearColor]];
    UILabel *title = [[UILabel alloc]init];
//    citiesModel *groupCity = self.citiesGroup[section];
    title.textColor = [UIColor whiteColor];
    title.frame = CGRectMake(18, 0, 200, 30);
    title.text = @"服务开通城市";
    [header addSubview:title];
    return header;
}

#pragma mark - 地图相关
//点击定位按钮
-(void)locationClick
{

    [self.loacationButton setTitle:@"定位中..." forState:UIControlStateNormal];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self configLocationManager];
        [self locateAction];
        if (self.locationCityName == nil) {

            [self.loacationButton setTitle:@"无法定位" forState:UIControlStateNormal];
        }else
        {
            [self.loacationButton setTitle:self.locationCityName forState:UIControlStateNormal];
        }
        
    });
}

- (void)configLocationManager
{
    [AMapLocationServices sharedServices].apiKey = @"92153914f24d72b25053a653c1d66224";
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，可修改，最小2s
    self.locationManager.locationTimeout = 3;
    //   逆地理请求超时时间，可修改，最小2s
    self.locationManager.reGeocodeTimeout = 3;
}
- (void)locateAction
{
    //带逆地理的单次定位
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            //            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        //定位信息
        //        NSLog(@"location:%@", location);
        
        //逆地理信息
        if (regeocode)
        {
            //            NSLog(@"reGeocode:%@", regeocode.province);
            //发出通知，告诉控制器，选中了那个城市
            [[NSNotificationCenter defaultCenter] postNotificationName:INGCityDidSelectNotification object:nil userInfo:@{INGSelectCityName : regeocode.province}];
            self.locationCityName = regeocode.province;
        }else{
            self.locationCityName = nil;
        }
    }];
}
#pragma mark - 热门城市的代理

-(void)INGHotView:(INGHotView *)hotView DidClickButton:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求网络数据
-(void)loadCityData
{
    [SVProgressHUD showWithStatus:@"加载中"];
    
    NSMutableString *bannerUrl = [NSMutableString string];
    [bannerUrl appendString:apiUrl];
    [bannerUrl appendString:@"hpage/qcity"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"]=  key;//@"4DB03900-7322-4C9C-A5D5-94AD7E8A5703";
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;

    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:bannerUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        [SVProgressHUD showSuccessWithStatus:@"加载完成"];

        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            
            [self.mutCitiesArray removeAllObjects];
            
            citiesModel *model = [citiesModel mj_objectWithKeyValues:responseObject[@"Results"]];
            [self.mutCitiesArray addObjectsFromArray:model.List];
            [self.tableView reloadData];
        }else{
            [self.mutCitiesArray removeAllObjects];
            [self.mutCitiesArray addObjectsFromArray:self.cityArray];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络异常，请稍后重试!"];
        
    }];
}

@end
