
//
//  INGCitiesCategoryHeaderView.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/7.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface INGCitiesCategoryHeaderView : UITableViewHeaderFooterView

/** 标题 */
@property (nonatomic, copy) NSString *title;

+(instancetype)headerViewWithTableView:(UITableView *)tableView;

@end
