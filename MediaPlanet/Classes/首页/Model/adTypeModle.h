//
//  adTypeModle.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/22.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  广告分类模型（二级分类）

#import <Foundation/Foundation.h>

@interface adTypeModle : NSObject
/** id */
@property (nonatomic, assign) NSInteger Id;

/** 名称 */
@property (nonatomic, strong) NSString *Name;

@end
