//
//  informationModle.h
//  MediaPlanet
//
//  Created by jamesczy on 16/9/28.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  行业资讯模型

#import <Foundation/Foundation.h>

@interface informationModle : NSObject
/** 图片链接 */
@property (nonatomic, strong) NSString *PicUrl;
/** 标题 */
@property (nonatomic, strong) NSString *TitleAttribute;

/** 样式 */
@property (nonatomic, assign) NSInteger Style;

/** 链接 */
@property (nonatomic, strong) NSString *LinkUrl;

/** 显示的顺序 */
@property (nonatomic, assign) NSInteger DisplayOrder;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
