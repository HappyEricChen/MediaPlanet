//
//  INGadMentButton.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/8.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGadMentButton.h"
#import "menberList.h"
#import <UIImageView+WebCache.h>

@implementation INGadMentButton

-(void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setImage:[UIImage imageNamed:@"partner_img0"] forState:UIControlStateNormal];
    [self setTitle:@"我是按钮" forState:UIControlStateNormal];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.layer setCornerRadius:self.width * 0.5];
    [self.layer setMasksToBounds:YES];
}
-(void)setTitleName:(NSString *)titleName
{
    [self setTitle:titleName forState:UIControlStateNormal];
    
}
-(void)setImageName:(NSString *)imageName
{
//    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"partner_img0"]];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //图片的frame
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.width;
    
    //文字的frame
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.imageView.height;
    
    
}

-(void)setModle:(menberList *)modle
{
    _modle = modle;
    [self setTitleName:modle.MemberName];
    [self setImageName:modle.Headimg];
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:modle.Headimg] placeholderImage:[UIImage imageNamed:@"personal_head"]];
}

@end
