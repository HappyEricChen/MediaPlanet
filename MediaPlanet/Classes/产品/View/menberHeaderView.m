//
//  menberHeaderView.m
//  MediaPlanet
//
//  Created by jamesczy on 16/7/21.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  拼单用户头像View

#import "menberHeaderView.h"
#import "menberList.h"
#import <UIImageView+WebCache.h>

@interface menberHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *headView;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
/** 下单次数 */
@property (weak, nonatomic) IBOutlet UILabel *orderCountLable;
@end

@implementation menberHeaderView
+(instancetype)menberHeaderView
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    
    
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.headView.layer.cornerRadius = self.headView.width * 0.5;
    [self.headView.layer setMasksToBounds:YES];
    self.orderCountLable.layer.cornerRadius = self.orderCountLable.height * 0.5;
    [self.orderCountLable.layer setMasksToBounds:YES];
}
-(void)setModle:(menberList *)modle{
    _modle = modle;
    
    self.titleLable.text = modle.MemberName;
    self.orderCountLable.text = [NSString stringWithFormat:@"x%ld份",(long)modle.PurchasedQuantity];
    [self.orderCountLable sizeToFit];
    [self.headView sd_setImageWithURL:[NSURL URLWithString:modle.Headimg] placeholderImage:[UIImage imageNamed:@"product_group_img0"]];
}
-(void)layoutSubviews{
    [super layoutSubviews];
//    self.headView.width = 60;
//    self.headView.height = 60;
//    self.titleLable.width = 60;
//    self.titleLable.height = 20;
    self.height = 90;
    self.width = 60;
}
@end
