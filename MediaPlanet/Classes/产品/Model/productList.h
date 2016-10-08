//
//  productList.h
//  MediaPlanet
//
//  Created by jamesczy on 16/7/11.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface productList : NSObject
/** 是否收藏 */
@property (nonatomic, assign) BOOL IsCol;
/** 广告公司名字 */
@property (nonatomic, strong) NSString *AdvertiserName;
/** 会员价格 */
@property (nonatomic, assign) CGFloat ProductPrice0;
/** 产品编号 */
@property (nonatomic, strong) NSString *ProductNo;
/** 能否拼单 */
@property (nonatomic, assign) BOOL IsGroup;
/** 游客价格 */
@property (nonatomic, assign) CGFloat ProductPrice;
/** 产品缩率图 */
@property (nonatomic, strong) NSString *ProductPic;
/** 产品名称 */
@property (nonatomic, strong) NSString *ProductName;
/** 是否售完 */
@property (nonatomic, assign) BOOL IsSoldout;
/** 是否过期 */
@property (nonatomic, assign) BOOL IsExpired;
/** 发布日期 */
@property (nonatomic, strong) NSString *PublishTime;
/**
 *  产品地址
 */
@property (nonatomic, strong) NSString* ProductLoc;

/** cell的高度  */
@property (nonatomic, assign) CGFloat cellHeight;

/** 广告商的高度  */
@property (nonatomic, assign) CGFloat AdvertiserNameH;

@end
