//
//  INGAdCattegoryViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/7/4.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  广告分类

#import "INGAdCattegoryViewController.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import "adTypeModle.h"
#import "adFirstGrade.h"
#import "INGSecondaryController.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>

@interface INGAdCattegoryViewController ()<UIScrollViewDelegate>
/** scrollView */
@property (nonatomic, strong) UIScrollView *topScrollView;
/** 标签栏底部的红色指示器 */
@property (nonatomic,weak) UIView * indicatorView;
/** 导航栏标题数组 */
@property (nonatomic, strong) NSMutableArray *titleArray;
/** 标题按钮数组 */
@property (nonatomic, strong) NSMutableArray *titleBtnArray;

/** 选中按钮 */
@property (nonatomic,weak) UIButton * selectedBtn;
/** 底部所有的内容 */
@property (nonatomic,weak) UIScrollView * contentView;

/** 二级分类数数组 */
@property (nonatomic, strong) NSMutableArray *typeArray;

@end

static NSString *const ID = @"cell";

@implementation INGAdCattegoryViewController

-(NSMutableArray*)titleArray
{
    if (_titleArray == nil) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
-(NSMutableArray*)titleBtnArray
{
    if (_titleBtnArray == nil) {
        _titleBtnArray = [NSMutableArray array];
    }
    return _titleBtnArray;
}
-(NSMutableArray*)typeArray
{
    if (_typeArray == nil) {
        _typeArray = [NSMutableArray array];
    }
    return _typeArray;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"category_bg"]];
    bgView.frame = self.view.bounds;
    [self.view insertSubview:bgView atIndex:0];
    
    [self loadCattegory];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
//        NSLog(@"clicked navigationbar back button");
        
    }
}

-(void)setUpChildVc
{
    
    for (int i = 0; i< self.titleArray.count; i++) {
        adFirstGrade *firstModle = self.titleArray[i];
//        NSArray *array = [adTypeModle mj_objectArrayWithKeyValuesArray:firstModle.Nodes];
        
        INGSecondaryController *vc = [[INGSecondaryController alloc]init];
//        adTypeModle *modle = array[i];
        vc.secondArray = firstModle.Nodes;
        vc.view.backgroundColor = [UIColor clearColor];;
        vc.title = firstModle.AdTypeName;
        [self addChildViewController:vc];
    }
    
}

-(void)setuptopScrollView
{
    //设置标签栏
    UIScrollView *topScrollView = [[UIScrollView alloc]init];
    topScrollView.height = 35;
    topScrollView.width = self.view.width;
    topScrollView.x = 0;
    topScrollView.y = 64;
    topScrollView.backgroundColor = [UIColor whiteColor];
    topScrollView.contentSize = CGSizeMake(screenW / 3 * self.titleArray.count, 0);
    topScrollView.showsHorizontalScrollIndicator = NO;
    topScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topScrollView];
    topScrollView.delegate = self;
    self.topScrollView = topScrollView;
    //设置指示器
//    UIImageView *indicatorView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"category_line"]];
    UIView *indicatorView = [[UIView alloc]init];
    indicatorView.backgroundColor = [UIColor whiteColor];
    indicatorView.height = 2;
    indicatorView.tag = -1;
    indicatorView.y = self.topScrollView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    
    CGFloat btnHeight = topScrollView.height;
    CGFloat btnWidth = screenW / 3;//topScrollView.width / self.childViewControllers.count;
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        UIViewController *vc = self.childViewControllers[i];
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        btn.y = 0;
        btn.x = i * btnWidth;
        btn.width = btnWidth;
        btn.height = btnHeight;
        btn.tag = i ;
        [topScrollView addSubview:btn];
        [self.titleBtnArray addObject:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            btn.enabled = NO;
            self.selectedBtn = btn;
            
            //让按钮内部的label根据文字内容来计算尺寸
            [btn.titleLabel sizeToFit];
            self.indicatorView.width = btn.titleLabel.width;
            self.indicatorView.centerX = btn.centerX;
        }
    }
    
    [self.topScrollView addSubview:indicatorView];
}

-(void)setUpContentView
{
    UIScrollView *contentView = [[UIScrollView alloc]init];
    
    contentView.x = 0;
    contentView.y = CGRectGetMaxY(self.topScrollView.frame);
    contentView.width = screenW;
    contentView.height = screenH - contentView.y;
    
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    contentView.showsHorizontalScrollIndicator = NO;
    
    contentView.backgroundColor = [UIColor clearColor];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
//    contentView.contentInset = UIEdgeInsetsMake(35, 0, 44, 0);
    [self.view addSubview:contentView];
    self.contentView = contentView;
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}
#pragma mark - scrollerViewDelegete

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.contentView) {
        //当前的索引
        NSInteger index = scrollView.contentOffset.x / scrollView.width;
//        NSLog(@"%ld",(long)index);
        //取出子控制器
        UIViewController *vc = self.childViewControllers[index];
        vc.view.x = scrollView.contentOffset.x;
        vc.view.y = 0;
        vc.view.height = scrollView.height;
        [scrollView addSubview:vc.view];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    if (scrollView == self.contentView) {
        //点击按钮
        NSInteger index = scrollView.contentOffset.x / scrollView.width;
        
        [self btnClick:self.titleBtnArray[index]];
        //滚动
        CGPoint offset = self.topScrollView.contentOffset;
        if (index < self.titleArray.count - 2) {
            offset.x = index * self.selectedBtn.width;
            [self.topScrollView setContentOffset:offset animated:YES];
        }
    }
    
}
//头部按钮点击
-(void)btnClick:(UIButton *)button
{
    self.selectedBtn.enabled = YES;
    button.enabled = NO;
    self.selectedBtn = button;
    [self.typeArray removeAllObjects];
    
    adFirstGrade *modle = self.titleArray[button.tag];
    NSArray *array = [adTypeModle mj_objectArrayWithKeyValuesArray:modle.Nodes];
    [self.typeArray addObjectsFromArray:array];
    //动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
    }];
    //滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];

}
#pragma mark - 请求数据
-(void)loadCattegory
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSMutableString *cattegoryUrl = [NSMutableString string];
    [cattegoryUrl appendString:apiUrl];
    [cattegoryUrl appendString:@"hpage/adtypes"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
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
        [SVProgressHUD dismiss];
//        NSLog(@"%@",responseObject);
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        
        if (IsSuccess) {
            
            NSArray *array = [adFirstGrade mj_objectArrayWithKeyValuesArray:responseObject[@"Results"][@"Data"]] ;
            
            [self.titleArray addObjectsFromArray:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                [self setUpChildVc];
                [self setuptopScrollView];
                [self setUpContentView];
                
            });
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"请求失败"];

    }];
}



@end
