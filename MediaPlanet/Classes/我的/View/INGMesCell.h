//
//  INGMesCell.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/2.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class personalInfo;

@interface INGMesCell : UITableViewCell
/** 数据源 */
@property (nonatomic, strong) personalInfo *info;

@end
