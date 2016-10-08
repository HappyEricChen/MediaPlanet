//
//  INGMeInfoCell.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/3.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  个人信息cell

#import "INGMeInfoCell.h"
#import "information.h"
#import <UIImageView+WebCache.h>

@interface INGMeInfoCell()

@end

@implementation INGMeInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setInfo:(information *)info
{
    _info = info;
    
    [self.infoHeaderView sd_setImageWithURL:[NSURL URLWithString:info.Headimg] placeholderImage:[UIImage imageNamed:@"pic_img"]];

    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.textLabel.x = 42;

}

-(void)setHeaderImage:(UIImage *)image
{
    self.infoHeaderView.image = image;
}
@end
