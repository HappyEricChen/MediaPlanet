//
//  myColListModle.h
//  MediaPlanet
//
//  Created by jamesczy on 16/7/6.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myColListModle : NSObject
/** 是否收藏 */
@property (nonatomic, assign) BOOL IsCol;
/** 广告公司名字 */
@property (nonatomic, strong) NSString *AdvertiserName;
/** 会员价格 */
@property (nonatomic, assign) CGFloat ProductPrice0;
/** 产品编号 */
@property (nonatomic, strong) NSString *ProductNo;
/** 是否拼单 */
@property (nonatomic, assign) BOOL IsGroup;
/** 游客价格 */
@property (nonatomic, assign) CGFloat ProductPrice;
/** 产品图片 */
@property (nonatomic, strong) NSString *ProductPic;
/** 产品名称 */
@property (nonatomic, strong) NSString *ProductName;
/** 产品tag */
@property (nonatomic, strong) NSString *ProductTag;
/** 是否收藏 */
@property (nonatomic, assign) BOOL IsSoldout;
/** 发布日期 */
@property (nonatomic, strong) NSString *PublishTime;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

/** 是否显示选中 */
@property (nonatomic, assign) BOOL IsSelected;

@end
