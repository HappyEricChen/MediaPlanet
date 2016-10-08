//
//  checkOrder.h
//  MediaPlanet
//
//  Created by jamesczy on 16/8/14.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  校验的模型

#import <Foundation/Foundation.h>

@interface checkOrder : NSObject
/** 会员价格 */
@property (nonatomic, assign) CGFloat MemberPrice;
/** 下单价格 */
@property (nonatomic, assign) CGFloat Price;
/** 剩余的数量 */
@property (nonatomic, assign) NSInteger SQuantity;
/** 允许下单的最大值 */
@property (nonatomic, assign) NSInteger MaxQuantity;

@end
