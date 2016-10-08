//
//  productInfo.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/29.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface productInfo : NSObject
/** 是否收藏 */
@property (nonatomic, assign) BOOL IsCol;
/** 介绍 */
@property (nonatomic, strong) NSString *ProductDesc;
/** 详细介绍 */
@property (nonatomic, strong) NSString *FullDescription;
/** 产品名称 */
@property (nonatomic, strong) NSString *ProductName;
/** 是否拼单 */
@property (nonatomic, assign) BOOL IsGroup;
/** 凭单用户 */
@property (nonatomic, strong) NSArray *MemberList;

/** 图片 */
@property (nonatomic, strong) NSString *ProductPic;
/** 会员价格 */
@property (nonatomic, assign) CGFloat ProductPrice0;
/** 广告商名字 */
@property (nonatomic, strong) NSString *AdvertiserName;
/** 地址 */
@property (nonatomic, strong) NSString *Address;
/** 详细地址 */
@property (nonatomic, strong) NSString *DetailProductLoc;
/** 是否需要显示定位功能 */
@property (nonatomic, assign) BOOL IsLoc;
/** 发布日期 */
@property (nonatomic, strong) NSString *PublishTime;
/** 产品编号 */
@property (nonatomic, strong) NSString *ProductNo;
/** Logo */
@property (nonatomic, strong) NSString *Logo;
/** 游客价格 */
@property (nonatomic, assign) CGFloat ProductPrice;
/** 拼单结束时间 */
@property (nonatomic, strong) NSString *GroupEndDateTime;
/** 是否售完 */
@property (nonatomic, assign) BOOL IsSoldout;
/** 产品的tag */
@property (nonatomic, strong) NSString *ProductTag;
/** 其他图片 */
@property (nonatomic, strong) NSArray *OtherPics;

/** 产品详情头部高度 */
@property (nonatomic, assign) CGFloat cellTopHeight;

/** 产品详情拼单高度 */
@property (nonatomic, assign) CGFloat cellSpellHeight;

/** 产品详情底部详情高度 */
@property (nonatomic, assign) CGFloat cellBottomHeight;


/** 距离拼单结束的时间的字符串 */
@property (nonatomic, strong) NSString *deltaStr;

@end
