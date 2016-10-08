//
//  INGConst.h
//  媒体星球
//
//  Created by jamesczy on 16/5/31.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INGConst : NSObject
/** 选中城市发出的通知 */
extern NSString *const INGCityDidSelectNotification;
/** 选中城市发出城市名字通知 */
extern NSString *const INGSelectCityName;

/** 定位城市发出的通知 */
extern NSString *const INGCityLocationNotification;
/** 定位城市发出城市名字通知 */
extern NSString *const INGLocationCityName;

///** 选择性别发出的通知 */
//extern NSString *const INGSexDidSelectNotification;
///** 选择的性别的通知 */
//extern NSString *const INGSelectedSex;
//
//
///** 修改昵称发出的通知 */
//extern NSString *const INGNickNameChangeNotification;
///** 昵称的通知 */
//extern NSString *const INGNickName;


/** 取消收藏发出的通知 */
extern NSString *const INGCancelCollectionNotification;
/** 取消的通知 */
extern NSString *const INGCancelCollection;

/** 收藏cell选中发出的通知 */
extern NSString *const INGIsSelectedCollectionNotification;
/** 选中的通知 */
extern NSString *const INGSelectedCollection;

/** tabBar被选中的通知名字 */
UIKIT_EXTERN NSString * const INGTabBarDidSelectNotification;
/** tabBar被选中的通知 - 被选中的控制器的index key */
UIKIT_EXTERN NSString * const INGSelectedControllerIndexKey;
/** tabBar被选中的通知 - 被选中的控制器 key */
UIKIT_EXTERN NSString * const INGSelectedControllerKey;

/** 用户登录或者退出的通知 */
UIKIT_EXTERN NSString * const INGUserLoginOrOutNotification;

#define fontSize 14

/**
 *  适配机型
 *
 */


#define iPHone6Plus ([UIScreen mainScreen].bounds.size.height == 736) ? YES : NO

#define iPHone6 ([UIScreen mainScreen].bounds.size.height == 667) ? YES : NO

#define iPHone5 ([UIScreen mainScreen].bounds.size.height == 568) ? YES : NO

#define iPHone4oriPHone4s ([UIScreen mainScreen].bounds.size.height == 480) ? YES : NO

@end
