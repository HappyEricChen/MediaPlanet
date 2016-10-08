//
//  INGProducutBottomView.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/16.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class productInfo;

@interface INGProducutBottomView : UIView

+(instancetype)ProductBottom;
/** 数据模型 */
@property (nonatomic, strong) productInfo *infoModle;


@end
