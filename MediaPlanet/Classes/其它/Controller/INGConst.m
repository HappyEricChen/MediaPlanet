//
//  INGConst.m
//  媒体星球
//
//  Created by jamesczy on 16/5/31.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  常量和常用的头文件

#import "INGConst.h"

@implementation INGConst
/** 选中城市发出的通知 */
NSString *const INGCityDidSelectNotification = @"INGCityDidSelectNotification";
/** 选中城市发出城市名字通知 */
NSString *const INGSelectCityName  = @"INGSelectCityName";

/** 定位城市发出的通知 */
NSString *const INGCityLocationNotification = @"INGCityLocationNotification";
/** 定位城市发出城市名字通知 */
NSString *const INGLocationCityName = @"INGLocationCityName";

///** 选择性别发出的通知 */
//NSString *const INGSexDidSelectNotification = @"INGSexDidSelectNotification";
///** 选择的性别的通知 */
//NSString *const INGSelectedSex = @"INGSelectedSex";
//
///** 修改昵称发出的通知 */
//NSString *const INGNickNameChangeNotification = @"INGNickNameChangeNotification";
///** 昵称的通知 */
//NSString *const INGNickName = @"INGNickName";

/** 删除收藏发出的通知 */
NSString *const INGCancelCollectionNotification = @"INGCancelCollectionNotification";
/** 通知 */
NSString *const INGCancelCollection = @"INGCancelCollection";

/** 收藏cell选中发出的通知 */
NSString *const INGIsSelectedCollectionNotification = @"INGIsSelectedCollectionNotification";
/** 选中的通知 */
NSString *const INGSelectedCollection = @"INGSelectedCollection";

/** tabBar被选中的通知名字 */
NSString * const INGTabBarDidSelectNotification = @"INGTabBarDidSelectNotification";
/** tabBar被选中的通知 - 被选中的控制器的index key */
NSString * const INGSelectedControllerIndexKey = @"INGSelectedControllerIndexKey";
/** tabBar被选中的通知 - 被选中的控制器 key */
NSString * const INGSelectedControllerKey = @"INGSelectedControllerKey";

/** 用户登录或者退出的通知 */
NSString * const INGUserLoginOrOutNotification = @"INGUserLoginOrOutNotification";

@end
