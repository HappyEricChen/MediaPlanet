//
//  loginMedel.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/21.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  登录注册返回模型

#import <Foundation/Foundation.h>

@interface loginMedel : NSObject

/** 是否登录成功 */
@property (nonatomic, assign) BOOL IsSuccess;

/** 错误信息 */
@property (nonatomic, strong) NSString *ErrorMessage;
/** 返回结果 */
@property (nonatomic, strong) NSString *Results;


@end
