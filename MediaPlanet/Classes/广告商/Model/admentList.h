//
//  admentList.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/29.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface admentList : NSObject
/** 广告商编号 */
@property (nonatomic, strong) NSString *AdvertiserNo;
/** 广告商名字 */
@property (nonatomic, strong) NSString *CompName;
/** 广告商简介 */
@property (nonatomic, strong) NSString *CompDesc;
/** 广告商Logo */
@property (nonatomic, strong) NSString *Logo;

/** 广告上简介的高度 */
@property (nonatomic, assign) CGFloat CompDescH;
/** 广告商名称的高度 */
@property (nonatomic, assign) CGFloat CompNameH;
@end
