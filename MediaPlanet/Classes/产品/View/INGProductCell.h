//
//  INGProductCell.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/8.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class productList;
@interface INGProductCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UIButton *spellButton;
/** 数据源 */
@property (nonatomic, strong) productList *productModle;

@end
