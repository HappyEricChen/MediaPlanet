//
//  FlashModel.h
//  MediaPlanet
//
//  Created by eric on 16/9/27.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  限时抢购

#import <Foundation/Foundation.h>

@interface FlashModel : NSObject
/** 是否收藏 */
@property (nonatomic, assign) BOOL IsCol;
/** 广告公司名字 */
@property (nonatomic, strong) NSString *AdvertiserName;
/** 会员价格 */
@property (nonatomic, assign) CGFloat ProductPrice0;
/** 产品编号 */
@property (nonatomic, strong) NSString *ProductNo;
/** 游客价格 */
@property (nonatomic, assign) CGFloat ProductPrice;
/** 产品缩率图 */
@property (nonatomic, strong) NSString *ProductPic;
/** 产品名称 */
@property (nonatomic, strong) NSString *ProductName;
/** 结束时间 */
@property (nonatomic, strong) NSString *ProductEndTime;

/** 最大拼单人数  */
@property (nonatomic, assign) int MaxUserCount;

/** 已拼单人数  */
@property (nonatomic, assign) int OrderUserCount;

@end
