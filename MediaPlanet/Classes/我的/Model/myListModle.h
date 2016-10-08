//
//  myListModle.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/23.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myListModle : NSObject
/** 订单价格 */
@property (nonatomic, assign) CGFloat OrderAmount;

/** 会员价格 */
@property (nonatomic, assign) CGFloat MemberPrice;

/** 官方刊例价格 */
@property (nonatomic, assign) CGFloat Price;

/** 订单状态 */
@property (nonatomic, strong) NSString *OrderStateChar;

/** 广告公司名字 */
@property (nonatomic, strong) NSString *AdvertiserName;

/** 产品名字 */
@property (nonatomic, strong) NSString *ProductName;

/** 产品图片 */
@property (nonatomic, strong) NSString *PicName;

/** 订单编号 */
@property (nonatomic, strong) NSString *OrderNo;

/** 下单时间 */
@property (nonatomic, strong) NSString *OrderTime;

/** 发布日期 */
@property (nonatomic, strong) NSString *PublishTime;

/** 是否是拼单产品 */
@property (nonatomic, assign) BOOL IsGroup;

/** cell的高度 */
//@property (nonatomic, assign) CGFloat cellHeight;
/** cell中间详情的高度 */
//@property (nonatomic, assign) CGFloat middleHeight;

@end
