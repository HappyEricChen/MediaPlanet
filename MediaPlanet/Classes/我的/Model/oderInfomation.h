//
//  oderInfomation.h
//  MediaPlanet
//
//  Created by jamesczy on 16/7/14.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface oderInfomation : NSObject
/** 订单价格 */
@property (nonatomic, assign) CGFloat OrderAmount;
/** 会员价格 */
@property (nonatomic, assign) CGFloat MemberPrice;
/** 官方价格 */
@property (nonatomic, assign) CGFloat Price;
/** 订单状态 */
@property (nonatomic, strong) NSString *OrderStateChar;
/** 联系电话 */
@property (nonatomic, strong) NSString *ContactTel;
/** 付款时间 */
@property (nonatomic, strong) NSString *PaymentTime;
/** 广告公司 */
@property (nonatomic, strong) NSString *AdvertiserName;
/** 联系地址 */
@property (nonatomic, strong) NSString *ContactAddress;
/** 产品名称 */
@property (nonatomic, strong) NSString *ProductName;
/** 产品图片 */
@property (nonatomic, strong) NSString *PicName;
/** 联系人 */
@property (nonatomic, strong) NSString *Contact;
/** 订单编号 */
@property (nonatomic, strong) NSString *OrderNo;
/** 订单时间 */
@property (nonatomic, strong) NSString *OrderTime;
/** 发布日期 */
@property (nonatomic, strong) NSString *PublishTime;
/** 是否是拼单产品 */
@property (nonatomic, assign) BOOL IsGroup;

/** 详情页面topView的高度 */
@property (nonatomic, assign) CGFloat topHeight;
/** 详情页面middleView的高度 */
@property (nonatomic, assign) CGFloat middleHeight;
/** 详情页面bottomView的高度 */
@property (nonatomic, assign) CGFloat bottomHeight;

/** 详情页面的高度 */
@property (nonatomic, assign) CGFloat infoHeight;


@end
