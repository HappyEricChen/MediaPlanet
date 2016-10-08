//
//  INGinformationCell.m
//  MediaPlanet
//
//  Created by jamesczy on 16/9/28.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  行业资讯

#import "INGinformationCell.h"
#import "informationModle.h"
#import <UIImageView+WebCache.h>

@interface INGinformationCell()

@property (weak, nonatomic) IBOutlet UIImageView *informationImageView;
@property (weak, nonatomic) IBOutlet UIButton *follwersButton;
@property (weak, nonatomic) IBOutlet UILabel *informationInfo;
@property (weak, nonatomic) IBOutlet UILabel *admentLable;

@end


@implementation INGinformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFrame:(CGRect)frame
{
    frame.origin.y += 10;
    frame.size.height -= 10;
    [super setFrame:frame];
}

-(void)setModle:(informationModle *)modle
{
    _modle = modle;
    [self.informationImageView sd_setImageWithURL:[NSURL URLWithString:modle.PicUrl] placeholderImage:[UIImage imageNamed:@"home_img1"]];
    self.informationInfo.text = modle.TitleAttribute;
}

@end
