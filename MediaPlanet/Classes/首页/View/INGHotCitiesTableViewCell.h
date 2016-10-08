//
//  INGHotCitiesTableViewCell.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/7.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class hotFrameModel;
@class INGHotView;
@interface INGHotCitiesTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
/** frame */
@property (nonatomic, strong) hotFrameModel *hotFrame;

/** CELLView */
@property (nonatomic, strong) INGHotView *hotView;
@end
