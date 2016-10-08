//
//  INGcollectListTableViewCell.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/14.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MGSwipeTableCell.h>

@class myColListModle;

@interface INGcollectListTableViewCell : MGSwipeTableCell
/** 模型数据 */
@property (nonatomic, strong) myColListModle *modle;

@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

@end
