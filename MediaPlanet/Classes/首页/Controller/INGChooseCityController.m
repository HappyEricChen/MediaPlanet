//
//  INGChooseCityController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/9/12.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  城市列表

#import "INGChooseCityController.h"
//#import "citiesModel.h"
#import "serverCityModel.h"
#import "INGHotView.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJExtension.h>

@interface INGChooseCityController ()<UITableViewDelegate,UITableViewDataSource,INGHotViewDelegate,AMapLocationManagerDelegate>
/** tableview */
@property (nonatomic, strong) UITableView *tableView;
/** 定位城市的按钮 */
@property (nonatomic, strong) UIButton *loacationButton;
/** 地图管理者 */
@property (nonatomic, strong) AMapLocationManager *locationManager;
/** 城市分类 */
@property (nonatomic, strong) NSArray *citiesGroup;

/** 后台传送的城市数据 */
@property (nonatomic, strong) NSMutableArray *mutCitiesArray;

@end
static NSString * const cellID = @"cell";

@implementation INGChooseCityController
/** 懒加载 */
//-(NSArray *)citiesGroup{
//    if (_citiesGroup == nil) {
//        _citiesGroup = [NSArray array];
//        _citiesGroup = [citiesModel cityGroupArray];
//    }
//    return _citiesGroup;
//}
-(NSMutableArray *)mutCitiesArray
{
    if (_mutCitiesArray == nil) {
        _mutCitiesArray = [NSMutableArray array];
    }
    return _mutCitiesArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTableView];
    [self loadCityData];
}
-(void)setupTableView
{
    self.tableView = [[UITableView alloc]init];
    self.tableView.frame = [UIScreen mainScreen].bounds;
//    self.tableView.y = 64;
//    self.tableView.height = screenH - 64;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:self.tableView];
    
    //当前定位城市
    UIView *headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 0, screenW, 105);
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *headerLable = [[UILabel alloc]init];
    headerLable.frame = CGRectMake(20, 3, screenW - 20, 21);
    headerLable.backgroundColor = [UIColor clearColor];
    headerLable.textColor = [UIColor blackColor];
    headerLable.text = @"当前城市";
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
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"city_hot"] forState:UIControlStateNormal];
    button.frame = CGRectMake(20, CGRectGetMaxY(headerLable.frame)+ 5, 70, 33);
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    [button.layer setMasksToBounds:YES];
    
    self.loacationButton = button;
    [headerView addSubview:headerLable];
    [headerView addSubview:button];
    
    UIImageView *lineImage = [[UIImageView alloc]init];
    lineImage.backgroundColor = JCColor(238, 238, 238);
    lineImage.frame = CGRectMake(20, CGRectGetMaxY(button.frame) + 10, screenW - 40, 1);
    [headerView addSubview:lineImage];
    
    UILabel *serviceLbale = [[UILabel alloc]init];
    serviceLbale.text = @"服务开通城市";
    serviceLbale.backgroundColor = [UIColor clearColor];
    serviceLbale.textColor = [UIColor blackColor];
    [serviceLbale sizeToFit];
    serviceLbale.font = [UIFont systemFontOfSize:17];
    serviceLbale.x = 20;
    serviceLbale.y = CGRectGetMaxY(lineImage.frame) + 5;
    
    [headerView addSubview:serviceLbale];
    
    self.tableView.tableHeaderView = headerView;
}
#pragma mark - 请求后台数据
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
        NSLog(@"%@",responseObject);
        [SVProgressHUD showSuccessWithStatus:@"加载完成"];
        
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            
            [self.mutCitiesArray removeAllObjects];
            
            self.mutCitiesArray = [serverCityModel mj_objectArrayWithKeyValuesArray:responseObject[@"Results"][@"List"]];
            [self.tableView reloadData];
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络异常，请稍后重试!"];
        
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    serverCityModel *groupCity = self.mutCitiesArray[section];
    
    return groupCity.CityName.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.mutCitiesArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    serverCityModel *citiesGroup = self.mutCitiesArray[indexPath.section];
    cell.textLabel.text = citiesGroup.CityName[indexPath.row];
    return cell;
}
#pragma mark - tableViewDelegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    serverCityModel *groupCity = self.mutCitiesArray[section];
    return groupCity.CityChar;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    serverCityModel *groupCity = self.mutCitiesArray[indexPath.section];
    //发出通知，告诉控制器，选中了那个城市
    [[NSNotificationCenter defaultCenter] postNotificationName:INGCityDidSelectNotification object:nil userInfo:@{INGSelectCityName :groupCity.CityName[indexPath.row]}];
    
    [self.navigationController popViewControllerAnimated:YES];
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

@end
