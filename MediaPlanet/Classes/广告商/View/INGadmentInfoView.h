//
//  INGadmentInfoView.h
//  MediaPlanet
//
//  Created by jamesczy on 16/9/27.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class admentList;
@interface INGadmentInfoView : UIView

/** 广告商模型数据 */
@property (nonatomic, strong) admentList *admentModle;

+(INGadmentInfoView *)admentInfoView;
@end
