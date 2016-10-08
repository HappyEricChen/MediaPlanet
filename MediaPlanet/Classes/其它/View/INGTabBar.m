//
//  INGTabBar.m
//  媒体星球
//
//  Created by jamesczy on 16/6/1.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGTabBar.h"
#import "INGRecommendViewController.h"
#import "INGNavigationController.h"

@interface INGTabBar()

@property (nonatomic ,weak)UIButton *publishButton;

@end


@implementation INGTabBar

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //添加中间的按钮
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];

        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabl_center"] forState:UIControlStateNormal];

        publishButton.size = publishButton.currentBackgroundImage.size;
        [publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publishButton];
        self.publishButton = publishButton;
        
    }
    return self;
}
-(void)publishClick
{
    
    [self animationWithIndex];
    [self performSelector:@selector(RecommendViewShow) withObject:nil afterDelay:0.3];
}

-(void)RecommendViewShow
{
    INGRecommendViewController* recommendViewController = [[INGRecommendViewController alloc]init];
    INGNavigationController *nav = [[INGNavigationController alloc]initWithRootViewController:recommendViewController];
    recommendViewController.loadType = NormalProductType;
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    root.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [root presentViewController:nav animated:YES completion:nil];
    
}
// 动画
- (void)animationWithIndex
{
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    
    pulse.duration = 0.5;
    pulse.repeatCount= 1;
    //    pulse.autoreverses= YES;
    //    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:-screenH];
    pulse.removedOnCompletion = NO;
    pulse.fillMode = kCAFillModeRemoved;//kCAFillModeForwards;
    
    [self.publishButton.layer addAnimation:pulse forKey:nil];
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    //设置发布按钮的frame
    self.publishButton.center =  CGPointMake(width * 0.5, height * 0.3);
    //设置其它tabbar的frame
    CGFloat buttonY = 0;
    CGFloat buttonW = width / 5;
    CGFloat buttonH = height;
    NSInteger index = 0;
    for (UIView *button in self.subviews) {
        if (![button isKindOfClass:[UIControl class]] || button == self.publishButton) continue;
        
        // 计算按钮的x值
        CGFloat buttonX = buttonW * ((index > 1)?(index + 1):index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        // 增加索引
        index++;
    }
}




@end
