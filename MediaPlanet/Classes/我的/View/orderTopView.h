//
//  orderTopView.h
//  MediaPlanet
//
//  Created by jamesczy on 16/8/1.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class oderInfomation;
@interface orderTopView : UIView
/** 数据源 */
@property (nonatomic, strong) oderInfomation *oderModle;

+(instancetype)topInfo;
@end
