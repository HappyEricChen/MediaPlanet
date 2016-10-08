//
//  INGMeInfoCell.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/3.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class information;
@interface INGMeInfoCell : UITableViewCell
/** 模型 */
@property (nonatomic, strong)information  *info;

@property (weak, nonatomic) IBOutlet UILabel *infoTitleLable;
@property (weak, nonatomic) IBOutlet UIImageView *rightView;
@property (weak, nonatomic) IBOutlet UIImageView *infoHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *infoLable;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumLable;
-(void)setHeaderImage:(UIImage *)image;
@end
