//
//  adFirstGrade.h
//  MediaPlanet
//
//  Created by jamesczy on 16/7/5.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  一级分类

#import <Foundation/Foundation.h>
@class adTypeModle;
@interface adFirstGrade : NSObject
/** 类名 */
@property (nonatomic, strong) NSString *AdTypeName;

/** 分类数据 */
@property (nonatomic, strong) NSArray *Nodes;


@end
