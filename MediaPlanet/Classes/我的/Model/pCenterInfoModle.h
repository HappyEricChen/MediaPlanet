//
//  pCenterInfoModle.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/23.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pCenterInfoModle : NSObject
/** 是否认证 */
@property (nonatomic, assign) BOOL IsSign;

/** 收藏数量 */
@property (nonatomic, assign) NSUInteger ColProductCount;

/** 头像 */
@property (nonatomic, strong) NSString *Headimg;

/** 名字 */
@property (nonatomic, strong) NSString *MemberName;

@end
