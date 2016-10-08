//
//  INGHomeController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/1.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGHomeController.h"
#import "INGSearchField.h"
#import "INGCitiesTableViewController.h"
#import "INGChooseCityController.h"
#import "INGSearchViewController.h"
#import "bannerModle.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import "INGAdCattegoryViewController.h"
#import "JCWebViewController.h"
#import "INGinformationCell.h"
#import "INGBigImageInformationCell.h"
#import "informationModle.h"

#import "INGMeTableViewController.h"
#import "INGNavigationController.h"
#import "INGLoginViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import <FLAnimatedImage.h>


#define kDegreesToRadian(x) (M_PI * (x) / 180.0 )

#define kRadianToDegrees(radian) (radian* 180.0 )/(M_PI)
static NSString * const smallCellID = @"smallImageCell";
static NSString * const bigCellID = @"bigImageCell";
@interface INGHomeController ()<UIScrollViewDelegate,AMapLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
//,AMapLocationManagerDelegate>
//选择的城市的名字
@property (nonatomic,copy) NSString * cityName;
/** 定位的城市的名字 */
@property (nonatomic, strong) NSString *locationCityName;

@property (weak, nonatomic)  UIScrollView *bannerScrollerView;
@property (weak, nonatomic)  UIView *topView;
@property (weak, nonatomic)  UIPageControl *pageView;

/** 旋转的图片 */
@property (nonatomic, strong) UIImageView *imageView;
/** 旋转的速度 */
@property (nonatomic, assign) CGFloat angle;
/** 首页底部View */
@property (nonatomic, weak) UIImageView *ballView;
/** 行业资讯的tableview */
@property (nonatomic, strong) UITableView *industryTableView;

/** 时钟控件 */
@property (nonatomic,weak) NSTimer *timer;
/** 时钟控件 */
@property (nonatomic,weak) NSTimer *timerView;

/** 地图管理者 */
@property (nonatomic, strong) AMapLocationManager *locationManager;

/** 模型数据 */
@property (nonatomic, strong) NSMutableArray *bannerArray;

/** 判断是否联网 */
@property (nonatomic, assign) BOOL isConncetNet;

/** tabBar当前选中的索引 */
@property (nonatomic, assign) NSInteger currentIndex;

/** 行业资讯数组 */
@property (nonatomic, strong) NSMutableArray *informationArray;

/** 行业资讯的请求页面 */
@property (nonatomic, assign) NSInteger infoPage;

/** 行业资讯的总数量 */
@property (nonatomic, assign) NSInteger Total;


@end
/** banner请求的数量 */
static NSInteger const pagesize = 6;
static NSInteger const infoPageSize = 10;
/** banner中要创建的view数量 */
static int const ImageViewCount = 3;

@implementation INGHomeController

-(NSMutableArray *)bannerArray
{
    if (_bannerArray == nil) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

-(NSMutableArray *)informationArray
{
    if (_informationArray == nil) {
        _informationArray = [NSMutableArray array];
    }
    return _informationArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGifBG];
    self.cityName = @"城市";
    [AMapLocationServices sharedServices].apiKey = @"92153914f24d72b25053a653c1d66224";
    [self loadBannerImage];
    [self setupTopView];
    [self setupNav];

//    [self setupContent];
    [self setUpIndustryView];
    
    [self configLocationManager];
    [self locateAction];
    
    [self setupRefresh];
//    [self loadINFORMATION];
//    [self startTimer];

}

-(void)setupGifBG
{
    CGRect frame = CGRectMake(0, 0, screenW, screenH);
    NSData *gif = nil;
    gif = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MEDIA-PLANET_new" ofType:@"gif"]];
    
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:gif];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    imageView.frame = frame;

    [self.view insertSubview:imageView atIndex:0];
    
}
/** 地图管理者初始化 */
- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];

    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，可修改，最小2s
    self.locationManager.locationTimeout = 3;
    //   逆地理请求超时时间，可修改，最小2s
    self.locationManager.reGeocodeTimeout = 3;
}
/** 定位 */
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
        if (regeocode && regeocode.province)
        {
//            NSLog(@"reGeocode:%@", regeocode.province);
            //发出通知，告诉控制器，选中了那个城市
            
            [[NSNotificationCenter defaultCenter] postNotificationName:INGCityDidSelectNotification object:nil userInfo:@{INGSelectCityName : regeocode.province}];
            self.locationCityName = regeocode.province;
        }
    }];
}

/** 设置首页顶部 */
-(void)setupTopView
{
    UIView *topView = [[UIView alloc]init];
    topView.frame = CGRectMake(0, 64, screenW, screenW * 1 / 3);
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    self.topView = topView;
    self.pageView.currentPage = 0;
    
    //监听城市改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityDidChange:) name:INGCityDidSelectNotification object:nil];
    
//    //监听tabBar的点击的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarClick) name:INGTabBarDidSelectNotification object:nil];

}
/** 设置导航栏 */
-(void)setupNav
{
//    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    //设置导航栏左边按钮
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 34)];
    titleView.backgroundColor = [UIColor clearColor];
    [titleView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseCity)]];

    UIImageView *mediaView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Media"]];
//    mediaView.y = (titleView.height - 30) * 0.5;
//    mediaView.height = 30;
    mediaView.centerY = titleView.centerY;
    [titleView addSubview:mediaView];
    
    
    UILabel *cityLable = [[UILabel alloc]init];
    if (![self.cityName isEqualToString:@"城市"]) {
        
        if ([[self.cityName substringFromIndex:(self.cityName.length - 1)] isEqualToString:@"市"]) {
            //        NSLog(@"%@",self.cityName);
            self.cityName = [self.cityName substringToIndex:(self.cityName.length - 1)];
        }
    }
    cityLable.text = self.cityName;
    cityLable.font = [UIFont systemFontOfSize:8];
    cityLable.textColor = [UIColor whiteColor];
    cityLable.backgroundColor = [UIColor clearColor];
    cityLable.textAlignment = NSTextAlignmentCenter;
    [cityLable sizeToFit];
//    cityLable.x = CGRectGetMaxX(mediaLable.frame);
//    cityLable.y = mediaLable.y + (mediaLable.height - cityLable.height) - 2;
    cityLable.x = CGRectGetMaxX(mediaView.frame);
    cityLable.y = mediaView.y + (mediaView.height - cityLable.height) + 2;
    
    [titleView addSubview:cityLable];
    
    self.navigationItem.titleView = titleView;
    
    //设置导航栏右边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"nav_select" highImage:@"MainTagSubIcon" target:self action:@selector(categoryDisplay)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"Search" highImage:@"Search" target:self action:@selector(searchClick)];
    
}

/** 设置scollerView */
-(void)setupBannerScorllerView
{
    UIScrollView *bannerScrollerView = [[UIScrollView alloc]init];
    bannerScrollerView.frame = self.topView.bounds;
    bannerScrollerView.contentSize = CGSizeMake(screenW * self.bannerArray.count, 0);
    bannerScrollerView.pagingEnabled = YES;
    bannerScrollerView.bounces = NO;
    bannerScrollerView.showsHorizontalScrollIndicator = NO;
    bannerScrollerView.showsVerticalScrollIndicator = NO;
    
    [self.topView addSubview:bannerScrollerView];
    self.bannerScrollerView = bannerScrollerView;
    self.bannerScrollerView.delegate = self;
    
    CGFloat scrollH = self.bannerScrollerView.height;
    CGFloat scrollW = screenW;
/**
    for (int i = 0; i < self.bannerArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i * self.bannerScrollerView.width;
        imageView.tag = i;
        
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadHttp:)]];
        
        bannerModle *modle = self.bannerArray[i];
        if (self.isConncetNet) {
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:modle.PicUrl] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"banner%d",1]]];
        }else{
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"banner%d",i + 1]];
        }
        
        [self.bannerScrollerView addSubview:imageView];
        
    }
 */
    for (int i = 0; i < ImageViewCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i * scrollW, 0, scrollW, scrollH);
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadHttp:)]];
        [self.bannerScrollerView addSubview:imageView];
    }
    UIPageControl *pageView = [[UIPageControl alloc]init];
    
    pageView.width = 100;
    pageView.height = 30;
    
    pageView.numberOfPages = self.bannerArray.count;
    pageView.centerX = scrollW * 0.5;
    pageView.centerY = CGRectGetMaxY(self.bannerScrollerView.frame) - 20;
    
    pageView.pageIndicatorTintColor = JCColor(189, 189, 189);
    pageView.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    [self.topView addSubview:pageView];
    
    self.pageView = pageView;

    
}
/** 行业资讯 */
-(void)setUpIndustryView
{
    CGFloat industryX = 0;
    CGFloat industryY = CGRectGetMaxY(self.topView.frame) + 10;
    CGFloat industryW = screenW - 2 * industryX;
    CGFloat industryH = screenH - industryY;
    CGRect industryRect = CGRectMake(industryX, industryY, industryW, industryH);
    UITableView *industryTableView = [[UITableView alloc]initWithFrame:industryRect];
    industryTableView.delegate = self;
    industryTableView.dataSource = self;
    [industryTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    industryTableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    self.industryTableView = industryTableView;
    self.industryTableView.backgroundColor = JCColor(238, 238, 238);
    
    [self.industryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([INGinformationCell class]) bundle:nil] forCellReuseIdentifier:smallCellID];
    [self.industryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([INGBigImageInformationCell class]) bundle:nil] forCellReuseIdentifier:bigCellID];
    
    [self.view addSubview:industryTableView];
}
-(void)setupRefresh
{
    self.industryTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadINFORMATION)];
    [self.industryTableView.mj_header beginRefreshing];
    self.industryTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreINFORMATION)];
}

/** 设置首页的底部显示内容(旋转的球体) */
-(void)setupContent
{
    UIImageView *ballView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"center_bar"]];
    ballView.x = 20;
    ballView.y = CGRectGetMaxY(self.topView.frame);
    ballView.width = screenW - ballView.x * 2;
    ballView.height = ballView.width * 261 / 258;
    [self.view addSubview:ballView];
    self.ballView = ballView;
    
    [self rotate360DegreeWithImageView:ballView];
}
#pragma mark - tabBar的点击监听事件
/** tabBar的点击监听事件 */
//-(void)tabBarClick
//{
//    UIViewController *tempViewController = self.tabBarController.selectedViewController.childViewControllers.firstObject;
//    self.currentIndex = self.tabBarController.selectedIndex;
//    if ([tempViewController isKindOfClass:[INGMeTableViewController class]]) {
//        if ([strStander getOutStandard]) {
//            return;
//        }else{
//            self.tabBarController.selectedIndex = 0 ;
//            INGLoginViewController *loginVC = [[INGLoginViewController alloc]init];
//            INGNavigationController *nav = [[INGNavigationController alloc]initWithRootViewController:loginVC];
//            [self presentViewController:nav animated:YES completion:nil];
////            [tempViewController.navigationController pushViewController:loginVC animated:YES];
//        }
//    }
//    
//}
/** banner点击事件 */
-(void)loadHttp:(UITapGestureRecognizer *)gestureRecoginzer
{
    
    if (![self.bannerArray[gestureRecoginzer.view.tag] isKindOfClass:[NSString class]]) {
        
        JCWebViewController *jcWebVC = [[JCWebViewController alloc]init];
        bannerModle *modle = self.bannerArray[gestureRecoginzer.view.tag];
        jcWebVC.url = modle.LinkUrl;
        jcWebVC.title = modle.TitleAttribute;
        [self.navigationController pushViewController:jcWebVC animated:YES];
    }
}
/** 请求banner网络图片数据 */
-(void)loadBannerImage
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithHue:99/255 saturation:99/255 brightness:99/255 alpha:0.5]];
    
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@"SVP_right"]];
    [SVProgressHUD showWithStatus:@"加载中"];
    
    [self.bannerArray removeAllObjects];
    
    NSMutableString *bannerUrl = [NSMutableString string];
    [bannerUrl appendString:apiUrl];
    [bannerUrl appendString:@"hpage/banners"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"]=  key;//@"4DB03900-7322-4C9C-A5D5-94AD7E8A5703";
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    params[@"pagesize"] = @(pagesize);
    params[@"pageindex"] = @(1);
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:bannerUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"%@",responseObject);
        [SVProgressHUD dismiss];
        self.isConncetNet = YES;
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        
        if (IsSuccess) {
            
            self.bannerArray = [bannerModle mj_objectArrayWithKeyValuesArray:responseObject[@"Results"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                [self setupBannerScorllerView];
                [self updateContent];
                [self startTimer];
            });
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        self.isConncetNet = NO;
        NSArray *array = @[@"banner1",@"banner2",@"banner3"];
        [self.bannerArray addObjectsFromArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [self setupBannerScorllerView];
            [self updateContent];
            [self startTimer];
        });
    }];
}
/** 加载行业资讯 */
-(void)loadINFORMATION
{
    self.infoPage = 1;
    NSMutableString *bannerUrl = [NSMutableString string];
    [bannerUrl appendString:apiUrl];
    [bannerUrl appendString:@"/hpage/QueryIndustryInfoData"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"]=  key;//@"4DB03900-7322-4C9C-A5D5-94AD7E8A5703";
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    params[@"pagesize"] = @(infoPageSize);
    params[@"pageindex"] = @(self.infoPage);
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:bannerUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [SVProgressHUD dismiss];
        [self.industryTableView.mj_header endRefreshing];
        self.isConncetNet = YES;
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        self.Total = [responseObject[@"Results"][@"Total"] integerValue];
        if (IsSuccess) {
            NSArray *modleArray = [informationModle mj_objectArrayWithKeyValuesArray:responseObject[@"Results"][@"List"]];
            [self.informationArray removeAllObjects];
            [self.informationArray addObjectsFromArray:modleArray];
            [self.industryTableView reloadData];
            self.infoPage ++;
        }
        if (self.Total < pagesize) {

            [self.industryTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
  
            [self.industryTableView.mj_footer endRefreshing];
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [self.industryTableView.mj_header endRefreshing];
        
    }];
    
}

-(void)loadMoreINFORMATION
{
    NSMutableString *bannerUrl = [NSMutableString string];
    [bannerUrl appendString:apiUrl];
    [bannerUrl appendString:@"/hpage/QueryIndustryInfoData"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"]=  key;//@"4DB03900-7322-4C9C-A5D5-94AD7E8A5703";
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    params[@"pagesize"] = @(infoPageSize);
    params[@"pageindex"] = @(self.infoPage);
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:bannerUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"%@",responseObject);
        [SVProgressHUD dismiss];
        [self.industryTableView.mj_footer endRefreshing];
        self.isConncetNet = YES;
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        
        if (IsSuccess) {
            NSArray *modleArray = [informationModle mj_objectArrayWithKeyValuesArray:responseObject[@"Results"][@"List"]];
//            [self.informationArray removeAllObjects];
            [self.informationArray addObjectsFromArray:modleArray];
            [self.industryTableView reloadData];
            self.infoPage ++;
        }
        
        NSInteger total = (self.Total - self.infoPage * pagesize);
        if (total < pagesize) {
            //            self.tableView.mj_footer.hidden = YES;
            [self.industryTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            //            self.tableView.mj_footer.hidden = NO;
            [self.industryTableView.mj_footer endRefreshing];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [self.industryTableView.mj_footer endRefreshing];
        
    }];
    
}
#pragma mark - 监听城市名字的改变 -
-(void)cityDidChange: (NSNotification *)notification
{
    //选中城市后，设置导航栏中的城市名字
    self.cityName = notification.userInfo[INGSelectCityName];
    [self settingStandard];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 更新界面
        [self setupNav];
    });
}

/** 城市存入沙盒 */
-(void)settingStandard
{
    if ([self.cityName isEqualToString:@""]) {
        self.cityName = @"上海";
    }
    
    //城市的key
    NSString *CityNameKey = @"CFBundleCityNameString";
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:CityNameKey];
    
    //存入沙盒
    [[NSUserDefaults standardUserDefaults]setObject:self.cityName forKey:CityNameKey];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

#pragma mark - 旋转动画
-(void)rotate360DegreeWithImageView:(UIImageView *)imageView{
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         
                         CATransform3DMakeRotation(-M_PI/350.f, 0.0, 0.0, 1.0) ];
    animation.duration = 1;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = HUGE_VALF;
    animation.removedOnCompletion = NO; 
    //在图片边缘添加一个像素的透明区域，去图片锯齿
        CGRect imageRrect = CGRectMake(0, 0,imageView.frame.size.width, imageView.frame.size.height);
        UIGraphicsBeginImageContext(imageRrect.size);
        [imageView.image drawInRect:CGRectMake(1,1,imageView.frame.size.width-2,imageView.frame.size.height-2)];
        imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    
    [imageView.layer addAnimation:animation forKey:nil];
    
}
/** 城市选择 */
-(void)chooseCity
{
//    [SVProgressHUD show];
    
//    INGCitiesTableViewController *cityViewController = [[INGCitiesTableViewController alloc]init];
    INGChooseCityController *cityViewController = [[INGChooseCityController alloc]init];
    cityViewController.locationCityName = self.locationCityName;
    cityViewController.title = @"选择城市";
    
    [self.navigationController pushViewController:cityViewController animated:YES];
}

-(void)categoryDisplay
{
    
    INGAdCattegoryViewController *vc = [[INGAdCattegoryViewController alloc]init];
    vc.title = @"分类信息";
    [self.navigationController pushViewController:vc animated:YES];
    [SVProgressHUD show];

}

/** 退出键盘 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - 定时器
-(void)startTimer
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(next) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    self.timer = timer;
}

-(void)stopTimer
{
    [self.timer invalidate];
    
    self.timer = nil;
    
}
#pragma mark - 内容更新
- (void)updateContent
{
    // 设置图片
    for (int i = 0; i<self.bannerScrollerView.subviews.count; i++) {
        UIImageView *imageView = self.bannerScrollerView.subviews[i];
        NSInteger index = self.pageView.currentPage;
        if (i == 0) {
            index--;
        } else if (i == 2) {
            index++;
        }
        if (index < 0) {
            index = self.pageView.numberOfPages - 1;
        } else if (index >= self.pageView.numberOfPages) {
            index = 0;
        }
        imageView.tag = index;
        bannerModle *modle = self.bannerArray[index];
        if (self.isConncetNet) {
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:modle.PicUrl] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"banner%d",1]]];
        }else{
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"banner%d",i + 1]];
        }
//        [imageView sd_setImageWithURL:[NSURL URLWithString:modle.PicUrl] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"banner%d",1]]];
    }
    
    // 设置偏移量在中间
    
    self.bannerScrollerView.contentOffset = CGPointMake(self.bannerScrollerView.width, 0);
    
}

- (void)next
{
    
    [self.bannerScrollerView setContentOffset:CGPointMake(2 * self.bannerScrollerView.frame.size.width, 0) animated:YES];
    
}
/**
-(void)imageNext
{
    int page = (int)self.pageView.currentPage;

    page == self.bannerArray.count - 1 ? page = 0 : page++;
    
    CGFloat x = page * self.bannerScrollerView.width;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [self.bannerScrollerView setContentOffset:CGPointMake(x, 0.0f) animated:YES];
    [UIView commitAnimations];
    
}
*/
#pragma mark - sccrollView的代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

//    self.pageView.currentPage =((int)(self.bannerScrollerView.contentOffset.x / self.bannerScrollerView.width + 0.5)) % MAX(1, self.bannerArray.count);
    if (![scrollView.class isSubclassOfClass:self.industryTableView.class]) {
    
        // 找出最中间的那个图片控件
        NSInteger page = 0;
        CGFloat minDistance = MAXFLOAT;
        for (int i = 0; i<self.bannerScrollerView.subviews.count; i++) {
            UIImageView *imageView = self.bannerScrollerView.subviews[i];
            CGFloat distance = 0;
            
            distance = ABS(imageView.frame.origin.x - scrollView.contentOffset.x);
            
            if (distance < minDistance) {
                minDistance = distance;
                page = imageView.tag;
            }
        }
        self.pageView.currentPage = page;
    
    }
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (![scrollView.class isSubclassOfClass:self.industryTableView.class]) {
        
        [self stopTimer];
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (![scrollView.class isSubclassOfClass:self.industryTableView.class]) {
    
        [self startTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (![scrollView.class isSubclassOfClass:self.industryTableView.class]) {
        
        [self updateContent];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (![scrollView.class isSubclassOfClass:self.industryTableView.class]) {
        
        [self updateContent];
    }
}
#pragma  mark - textField代理

-(void)searchClick
{
    INGSearchViewController *searchVC = [[INGSearchViewController alloc]init];
    [self presentViewController:searchVC animated:YES completion:nil];
    
}

#pragma mark - tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.informationArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    INGinformationCell *smallCell = [tableView dequeueReusableCellWithIdentifier:smallCellID];
    INGBigImageInformationCell *bigCell = [tableView dequeueReusableCellWithIdentifier:bigCellID];
    
    informationModle *modle = self.informationArray[indexPath.row];
    
    if (modle.Style == 0) {
//        smallCell.backgroundColor = [UIColor redColor];
        smallCell.modle = modle;
        return smallCell;
    }else{
        bigCell.modle = modle;
//        bigCell.backgroundColor = [UIColor blueColor];
        return bigCell;
    }

}

#pragma mark - tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    informationModle *modle = self.informationArray[indexPath.row];
    if (modle.Style == 0) {
        return 155.0f;
    }else{
        return 222.0f;
    }
        
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JCWebViewController *jcWebVC = [[JCWebViewController alloc]init];
//    jcWebVC.view.frame = self.view.bounds;
    informationModle *modle = self.informationArray[indexPath.row];
    
    jcWebVC.url = modle.LinkUrl;
    jcWebVC.title = modle.TitleAttribute;
    [self.navigationController pushViewController:jcWebVC animated:YES];

}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:INGCityDidSelectNotification object:nil];

    
}

@end
