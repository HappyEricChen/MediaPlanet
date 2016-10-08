//
//  INGPushMSGCell.m
//  MediaPlanet
//
//  Created by jamesczy on 16/8/25.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGPushMSGCell.h"

@interface INGPushMSGCell()

@property (weak, nonatomic) IBOutlet UILabel *msgTitleLable;

@property (weak, nonatomic) IBOutlet UILabel *msgInfoLable;

@property (weak, nonatomic) IBOutlet UILabel *msgTimeLable;

@end


@implementation INGPushMSGCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
