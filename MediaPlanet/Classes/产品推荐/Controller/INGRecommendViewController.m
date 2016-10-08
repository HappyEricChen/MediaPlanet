//
//  INGRecommendViewController.m
//  MediaPlanet
//
//  Created by eric on 16/9/14.
//  Copyright © 2016年 jamesczy. All rights reserved.
// 我们帮你挑

#import "INGRecommendViewController.h"
#import "INGRecommendDataViewController.h"
#import "FirstRecommendCollectionViewCell.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "productList.h"
#import "CountDownView.h"
#import "FlashModel.h"

@interface INGRecommendViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) INGRecommendDataViewController* recommendDataViewController;
/** 请求页数 */
@property (nonatomic, assign) NSInteger pageIndex;

/** 模型数组 */
@property (nonatomic, strong) NSMutableArray *productArray;

/** 限时抢购数组 */
@property (nonatomic, strong) NSMutableArray *limitedArray;

/** 产品总数 */
@property (nonatomic, assign) NSInteger total;

/** 请求的参数 */
@property (nonatomic, strong) NSMutableDictionary *params;
/**
 *  倒计时
 */
@property (strong, nonatomic) CADisplayLink* countDownTimer;
/**
 *  倒计时秒数
 */
@property (nonatomic, assign) NSInteger countDown;

@end

static NSInteger const pagesize = 10;

@implementation INGRecommendViewController

-(NSMutableArray *)productArray
{
    if (_productArray == nil) {
        _productArray = [NSMutableArray array];
    }
    return _productArray;
}
-(NSMutableArray *)limitedArray
{
    if (_limitedArray == nil) {
        _limitedArray = [NSMutableArray array];
    }
    return _limitedArray;
}
-(NSMutableDictionary *)params
{
    if (_params == nil) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recommendDataViewController = [[INGRecommendDataViewController alloc]init];
    [self configureCollectionView];
    [self configureNavigationView];
    [self configureCountDownView];
    
    [self loadNew];
    [self loadFlash];
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee);
    
}
-(void)configureNavigationView
{
    self.navigationItem.title = @"我们帮你挑";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"left" highImage:@"navigationButtonReturn" target:self action:@selector(categoryDisplay)];
}
/**
 *  返回按钮
 */
-(void)categoryDisplay
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)configureCollectionView
{
    [self.view addSubview:self.recommendDataViewController.collectionView];
    
    self.recommendDataViewController.collectionView.delegate = self;
    self.recommendDataViewController.collectionView.dataSource = self;
    
    self.recommendDataViewController.collectionView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view,70).heightIs(screenH*0.45);
    
}

-(void)configureCountDownView
{
    [self.view addSubview:self.recommendDataViewController.countDownView];
    
    self.recommendDataViewController.countDownView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.recommendDataViewController.collectionView,8).bottomSpaceToView(self.view,10);
}

#pragma mark - 加载数据
/** 加载推荐数据 */
-(void)loadNew
{
    [SVProgressHUD showWithStatus:@"加载中"];
    
    [self.productArray removeAllObjects];
    
    NSMutableString *loadUrl = [NSMutableString string];
    [loadUrl appendString:apiUrl];
    [loadUrl appendString:@"products/qrecommend"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"]=  key;//@"4DB03900-7322-4C9C-A5D5-94AD7E8A5703";
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    params[@"pagesize"] = @(pagesize);
    params[@"pageindex"] = @(1);
    //获取当前选中的城市
    params[@"cityname"] = [[NSUserDefaults standardUserDefaults]objectForKey:CityNameKey];
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
   
    [params removeObjectForKey:@"key"];
   
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:loadUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress)
     {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         [self.productArray removeAllObjects];
         BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
         if (IsSuccess)
         {
             [SVProgressHUD showSuccessWithStatus:@"加载成功"];
             NSArray *array = [productList mj_objectArrayWithKeyValuesArray:responseObject[@"Results"][@"List"]];
             [self.productArray addObjectsFromArray:array];
             self.total = [responseObject[@"Results"][@"Total"] integerValue];
             
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"未查询到相关产品"];
         }
         [self.recommendDataViewController.collectionView reloadData];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         
         [self.productArray removeAllObjects];
         [self.recommendDataViewController.collectionView reloadData];
         [SVProgressHUD showErrorWithStatus:@"请求失败，稍后重试！"];
     }];
}

/** 加载限时抢购数据 */
-(void)loadFlash
{
    [SVProgressHUD showWithStatus:@"加载中"];
    
    NSMutableString *loadUrl = [NSMutableString string];
    [loadUrl appendString:apiUrl];
    [loadUrl appendString:@"products/qlimited"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"]=  key;//@"4DB03900-7322-4C9C-A5D5-94AD7E8A5703";
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    params[@"pagesize"] = @(pagesize);
    params[@"pageindex"] = @(1);
    //获取当前选中的城市
    params[@"cityname"] = [[NSUserDefaults standardUserDefaults]objectForKey:CityNameKey];
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    
   
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:loadUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress)
     {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         [self.limitedArray removeAllObjects];
         BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
         if (IsSuccess)
         {
             [SVProgressHUD showSuccessWithStatus:@"加载成功"];
             NSArray *array = [FlashModel mj_objectArrayWithKeyValuesArray:responseObject[@"Results"][@"List"]];
             [self.limitedArray addObjectsFromArray:array];
             
             [self refreshCountDownView];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"未查询到相关产品"];
         }
    
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         [SVProgressHUD showErrorWithStatus:@"请求失败，稍后重试！"];
     }];
}


#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.productArray.count>0?self.productArray.count:0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FirstRecommendCollectionViewCell* cell = [FirstRecommendCollectionViewCell collectionView:collectionView forIndexPath:indexPath];
    [cell layoutWithObject:self.productArray[indexPath.row]];
    return cell;
}
#pragma mark - UICollectionViewFlowLayoutDelegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(screenW*0.9, self.recommendDataViewController.collectionView.height);
}

//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}


#pragma mark - UICollectionViewDelegate
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}
-(void)refreshCountDownView
{
    FlashModel* flashModel = self.limitedArray[0];
    
    if (flashModel.ProductEndTime)
    {
//        self.countDown = [self transferTimeStringToIntervalWith:@"2016-09-19 9:03:00"];
        self.countDown = [self transferTimeStringToIntervalWith:flashModel.ProductEndTime];
        
        if (self.countDownTimer == nil)
        {
            self.countDownTimer = [CADisplayLink displayLinkWithTarget:self
                                                              selector:@selector(updateDisplay:)];
            self.countDownTimer.frameInterval = 60;
            [self.countDownTimer addToRunLoop:[NSRunLoop currentRunLoop]
                                      forMode:NSDefaultRunLoopMode];
        }
    }
    /**
     *  传值更新界面
     */
    [self.recommendDataViewController.countDownView layoutWithObject:flashModel];

 }
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.countDownTimer)
    {
        [self.countDownTimer removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
}

-(void)updateDisplay:(CADisplayLink*)displayLink
{
    
    if (self.countDown>0)
    {
        self.countDown-=1;
//        NSLog(@"%ld",self.countDown);
    }
    else
    {
        /**
         *  倒计时结束 显示00：00：00
         */
        if (self.countDownTimer)
        {
            [self.countDownTimer removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [self.countDownTimer invalidate];
            self.countDownTimer = nil;
        }
    }
    [self.recommendDataViewController.countDownView layoutCountDown:self.countDown];
}

#pragma mark - 计算倒计时的秒数，必须是今天以后的日期才计算，昨天的全部为0s
- (NSInteger)transferTimeStringToIntervalWith:(NSString *)timeString
{
    if(!timeString||timeString.length==0)
    {
        return 0;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *tZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:tZone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //字符串转换为时间
    NSDate *postDate = [formatter dateFromString:timeString];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval countDown = [postDate timeIntervalSinceDate:currentDate];
    NSInteger countDownTime = round(countDown);
    
    
    if (countDownTime>0)
    {
        return countDownTime;
    }
    else
    {
        return 0;
    }
}
@end
