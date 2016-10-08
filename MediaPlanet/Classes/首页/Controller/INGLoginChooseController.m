//
//  INGLoginChooseController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/9/5.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  登录选择

#import "INGLoginChooseController.h"
#import "INGTabBarController.h"

@interface INGLoginChooseController ()<UIGestureRecognizerDelegate,UITabBarControllerDelegate>
/** 图片 */
@property (nonatomic, strong) UIImageView *loginCheeseView;

@end

@implementation INGLoginChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBtn];
    // Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, screenW, screenH);
    self.view.backgroundColor = [UIColor clearColor];
    
    NSData *imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loginchooseBG" ofType:@"png"]];
    
    UIImage *chooseImage = [UIImage imageWithData:imageData];
    UIImageView *bgView = [[UIImageView alloc]initWithImage:chooseImage];
    bgView.frame = self.view.bounds;
    [self.view insertSubview:bgView atIndex:0];
    
}

-(void)setUpBtn
{
    UIButton *visitorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    visitorBtn.backgroundColor = [UIColor clearColor];
    visitorBtn.tag = 3;
    visitorBtn.width = (screenW - 20 * 3) / 2;
    visitorBtn.height = 30;
    visitorBtn.centerY = screenH * 0.85;
    visitorBtn.centerX = screenW * 1 / 4;
    [visitorBtn.layer setCornerRadius:visitorBtn.height *0.5];
    [visitorBtn.layer setMasksToBounds:YES];
    
//    [visitorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    visitorBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//    [visitorBtn setTitle:@"游客" forState:UIControlStateNormal];
    [visitorBtn addTarget:self action:@selector(clickVisitorBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:visitorBtn];
    
    UIButton *memberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    memberBtn.backgroundColor = [UIColor clearColor];
    memberBtn.tag = 0;
    memberBtn.width = (screenW - 20 * 3) / 2;
    memberBtn.height = 30;
    memberBtn.centerY = screenH * 0.85;
    memberBtn.centerX = screenW * 3 / 4;
    [memberBtn.layer setCornerRadius:memberBtn.height *0.5];
    [memberBtn.layer setMasksToBounds:YES];
    
//    [memberBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    memberBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//    [memberBtn setTitle:@"会员" forState:UIControlStateNormal];
    [memberBtn addTarget:self action:@selector(loginWithTag:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:memberBtn];
    /*
    UIImageView *loginCheeseView = [[UIImageView alloc]init];
    loginCheeseView.width = 300;
    loginCheeseView.height = 300;
    loginCheeseView.center = self.view.center;
    loginCheeseView.image = [UIImage imageNamed:@"center_bar"];
    
    loginCheeseView.layer.cornerRadius = 50;
    [loginCheeseView.layer setMasksToBounds:YES];
    
    UITapGestureRecognizer *loginGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choose:)];
    loginGR.delegate = self;
    
    [loginCheeseView addGestureRecognizer:loginGR];
    loginCheeseView.userInteractionEnabled = YES;
    self.loginCheeseView = loginCheeseView;
    [self.view addSubview:loginCheeseView];*/
}

-(void)choose:(UIGestureRecognizer *)gest
{
    [UIView transitionFromView:self.loginCheeseView toView:self.loginCheeseView duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft+UIViewAnimationOptionCurveEaseInOut completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击游客登录按钮
-(void)clickVisitorBtn
{
    //删除沙盒中的UToken
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"CFBundleUTokenString"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    UIWindow *window= [UIApplication sharedApplication].keyWindow;
    INGTabBarController *tabBar = [[INGTabBarController alloc]init];
    
    window.rootViewController = tabBar;
}
//点击会员登录按钮
-(void)loginWithTag:(UIButton *)button
{
    if ([NSString isMemberLogin])
    {
        UIWindow *window= [UIApplication sharedApplication].keyWindow;
        INGTabBarController *tabBar = [[INGTabBarController alloc]init];
        
        window.rootViewController = tabBar;
    }
    else
    {
        
    }
   

}

/** 设置控制器对应的状态栏是白色 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
