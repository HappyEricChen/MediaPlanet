//
//  UIWindow+Extension.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/9.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  把版本号存到沙盒

#import "UIWindow+Extension.h"
#import "INGTabBarController.h"
#import "INGNewFeatrueViewController.h"
#import "INGLoginChooseController.h"

@interface UIWindow()<UITabBarControllerDelegate>

@end

@implementation UIWindow (Extension)

-(void)swithRootWindowController
{
    NSString *key = @"CFBundleShortVersionString";
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    if ([currentVersion isEqualToString:lastVersion]) {
//        INGTabBarController *tabBar = [[INGTabBarController alloc]init];
//        tabBar.delegate = self;
        INGLoginChooseController *chooseVC = [[INGLoginChooseController alloc]init];
        self.rootViewController = chooseVC;
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
        self.rootViewController = [[INGNewFeatrueViewController alloc]init];
    }
}

#pragma mark - UITabBarControllerDelegate

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:INGTabBarDidSelectNotification object:nil];
}

@end
