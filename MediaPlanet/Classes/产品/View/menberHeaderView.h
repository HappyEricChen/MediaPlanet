//
//  menberHeaderView.h
//  MediaPlanet
//
//  Created by jamesczy on 16/7/21.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class menberList;
@interface menberHeaderView : UIView
/** 模型 */
@property (nonatomic, strong) menberList *modle;
+(instancetype)menberHeaderView;
@end
