//
//  INGNavigationController.m
//  媒体星球
//
//  Created by jamesczy on 16/5/30.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGNavigationController.h"

@interface INGNavigationController ()<UINavigationControllerDelegate>
//// 记录push标志
//@property (nonatomic, getter=isPushing) BOOL pushing;
@end

@implementation INGNavigationController

+(void)initialize
{
    //appearance 统一设置
    UINavigationBar *bar = [UINavigationBar appearance];
//    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
//    [bar setBackgroundColor:[UIColor clearColor]];
    [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *itemAttries =  [NSMutableDictionary dictionary];
    itemAttries[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    itemAttries[NSForegroundColorAttributeName] = [UIColor whiteColor];
    NSMutableDictionary *itemDisabledAttries = [NSMutableDictionary dictionary];
    itemDisabledAttries[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    
    [item setTitleTextAttributes:itemAttries forState:UIControlStateNormal];
    [item setTitleTextAttributes:itemDisabledAttries forState:UIControlStateDisabled];
    //设置导航栏的背景为透明
//    [bar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsCompact];
//    bar.shadowImage = [[UIImage alloc]init];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.navigationBar.barTintColor = [UIColor blackColor];

    //如果右滑不能移除控制器, 清空代理
//    self.interactivePopGestureRecognizer.delegate = nil;
    
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.childViewControllers.count > 0) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [button setBackgroundColor:[UIColor redColor]];
        [button setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        //设置导航栏的右边按钮的文字和颜色
        //        [button setTitle:@"返回" forState:UIControlStateNormal];
        //        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        button.bounds = CGRectMake(0, 0, 40, 30);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        
        
        viewController.hidesBottomBarWhenPushed = YES;
    }

    [super pushViewController:viewController animated:animated];
}

-(void)back
{
    [self popViewControllerAnimated:YES];
}
#pragma mark - UINavigationControllerDelegate
//-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    self.pushing = NO;
//}
/** 设置控制器对应的状态栏是白色 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
