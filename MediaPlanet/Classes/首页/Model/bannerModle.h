//
//  bannerModle.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/22.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  banner数据模型

#import <Foundation/Foundation.h>

@interface bannerModle : NSObject
/** 连接URL */
@property (nonatomic, strong) NSString *LinkUrl;

/** 图片URL */
@property (nonatomic, strong) NSString *PicUrl;

/** 图片名字 */
@property (nonatomic, strong) NSString *TitleAttribute;



@end
