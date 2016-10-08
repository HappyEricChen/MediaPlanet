//
//  INGMyListTableViewCell.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/3.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MGSwipeTableCell.h>

@class myListModle;
@interface INGMyListTableViewCell : MGSwipeTableCell
/** 数据模型 */
@property (nonatomic, strong) myListModle *modle;

@end
