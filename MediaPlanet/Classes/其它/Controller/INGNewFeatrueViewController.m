//
//  INGNewFeatrueViewController.m
//  媒体星球
//
//  Created by jamesczy on 16/5/31.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  引导页面

#import "INGNewFeatrueViewController.h"
#import "INGTabBarController.h"
#import "INGLoginChooseController.h"

#define JCNewfeatrueCount 4

@interface INGNewFeatrueViewController ()<UIScrollViewDelegate,UITabBarControllerDelegate>

@property (nonatomic , strong)UIPageControl *pageControl;

/** 时钟 */
@property (nonatomic, strong) NSTimer *timer;

/** 跳过按钮 */
@property (nonatomic, strong) UIButton *junmpButton;

/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;

@end
static NSInteger secondsCount = 8;

@implementation INGNewFeatrueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
 
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerThread) userInfo:nil repeats:YES];
    
    [self startTimer];
}


-(void)timerThread
{
    secondsCount -= 2 ;
    [self.junmpButton setTitle:[NSString stringWithFormat:@"跳过%ld",(long)secondsCount] forState:UIControlStateNormal];
    if (secondsCount == 0) {
        [self startClick];
    }
}
#pragma mark - 定时器
-(void)startTimer
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(imageNext) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    self.timer = timer;
}

-(void)stopTimer
{
    [self.timer invalidate];
    
    self.timer = nil;
    
}
//初始化
-(void)setup
{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.delegate =self;
    scrollView.frame = self.view.bounds;
    scrollView.contentSize = CGSizeMake(JCNewfeatrueCount * scrollView.width, 0);
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    CGFloat scrollH = scrollView.height;
    CGFloat scrollW = scrollView.width;
    for (int i = 0; i < JCNewfeatrueCount; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.height = scrollH;
        imageView.width = scrollW;
        imageView.y = 0;
        imageView.x = i * scrollView.width;
        //显示图片
        NSString *name = [NSString stringWithFormat:@"%d",i+1];
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        if (i == JCNewfeatrueCount - 1) {
            [self setupLastView:imageView];
        }
        
    }
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    UIPageControl *page = [[UIPageControl alloc]init];
    page.numberOfPages = JCNewfeatrueCount;
    page.height = 50;
    page.width = 100;
    page.centerX = scrollW * 0.5;
    //    NSLog(@"%f--%f",page.centerX,scrollW);
    page.centerY = scrollH - 50;
    //    page.backgroundColor = [UIColor redColor];
    page.pageIndicatorTintColor = JCColor(189, 189, 189);
    page.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self.view addSubview:page];
    self.pageControl = page;
    
    UIButton *junmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    junmpButton.width = 100;
    junmpButton.height = 35;
    junmpButton.y = 30;
    junmpButton.x = screenW - junmpButton.width - 20;
    
    [junmpButton setBackgroundColor:[UIColor clearColor]];
    junmpButton.layer.borderColor = [UIColor whiteColor].CGColor;\
    junmpButton.layer.borderWidth = 1.0f;
    [junmpButton.layer setMasksToBounds:YES];
    [junmpButton.layer setCornerRadius:5];
    
    [junmpButton setTitle:@"跳过" forState:UIControlStateNormal];
    junmpButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [junmpButton setTintColor:[UIColor whiteColor]];
    
    [junmpButton addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    self.junmpButton = junmpButton;
    [self.view addSubview:junmpButton];
}
-(void)setupLastView:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES;
    
    //开始体验
    UIButton *startBtn = [[UIButton alloc]init];
    [startBtn setBackgroundColor:[UIColor clearColor]];
    
    startBtn.width = 215;
    startBtn.height = 50;
    startBtn.centerX = imageView.width * 0.5;
    startBtn.centerY = imageView.height * 0.75;
    
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
}
//下一页
-(void)imageNext
{
    [self timerThread];
    
    int page = (int)self.pageControl.currentPage;
    page == 3 ? page = 0 : page++;
    CGFloat x = page * self.scrollView.width;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [self.scrollView setContentOffset:CGPointMake(x, 0.0f) animated:YES];
    [UIView commitAnimations];
}

-(void)startClick
{
    [self.timer invalidate];
    UIWindow *window= [UIApplication sharedApplication].keyWindow;
//    INGTabBarController *tabBar = [[INGTabBarController alloc]init];
//    tabBar.delegate = self;
    INGLoginChooseController *chooseVC = [[INGLoginChooseController alloc]init];
    window.rootViewController = chooseVC;
}
#pragma mark - sccrollView的代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage =((int)(scrollView.contentOffset.x / scrollView.width + 0.5)) % JCNewfeatrueCount;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self startTimer];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self stopTimer];
    self.timer = nil;
}

//-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    //发出通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:INGTabBarDidSelectNotification object:nil];
//}

/** 设置控制器对应的状态栏是白色 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
