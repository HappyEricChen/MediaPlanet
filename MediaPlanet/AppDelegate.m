//
//  AppDelegate.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/1.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "AppDelegate.h"
#import "INGTabBarController.h"
#import "INGNewFeatrueViewController.h"
#import "INGLoginChooseController.h"
#import "UIWindow+Extension.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>

@interface AppDelegate ()

@end
static NSString *appKey = @"dab260b7ffa14a5af4d20a63";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;

//    INGLoginChooseController  *chooseVC = [[INGLoginChooseController alloc]init];
//    self.window.rootViewController = chooseVC;
    
    [self.window swithRootWindowController];
    [self.window makeKeyAndVisible];
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //       categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories    nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];

    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidLoginNotification object:nil];
    //kJPFNetworkDidLoginNotification
    //kJPFNetworkDidReceiveMessageNotification
    return YES;
}
- (void)networkDidReceiveMessage:(NSNotification *)notification {
//    NSDictionary * userInfo = [notification userInfo];
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
//    NSLog(@"%@,%@,%@",content,extras,customizeField1);
//    
//    [JPUSHService setTags:[NSSet setWithObject:@"users"] alias:@"testiphone6" callbackSelector:@selector(callback) object:nil];
}
-(void)callback
{
    NSLog(@"%s",__func__);
    
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required -    DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error { 
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error
          );
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
