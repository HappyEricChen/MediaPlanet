//
//  orderMiddleView.m
//  MediaPlanet
//
//  Created by jamesczy on 16/8/1.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "orderMiddleView.h"
#import "oderInfomation.h"
#import <UIImageView+WebCache.h>

@interface orderMiddleView()

@property (weak, nonatomic) IBOutlet UIImageView *productIcon;
@property (weak, nonatomic) IBOutlet UILabel *productNameLable;
@property (weak, nonatomic) IBOutlet UILabel *admentNameLable;
@property (weak, nonatomic) IBOutlet UILabel *centerPiceLable;
@property (weak, nonatomic) IBOutlet UILabel *visitorPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *putAwayTimeLable;
@property (weak, nonatomic) IBOutlet UIButton *isGroupShowBtn;

@end

@implementation orderMiddleView

+(instancetype)middleInfo
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    
    
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.width = screenW;
    [self.productIcon.layer setCornerRadius:self.productIcon.width * 0.5];
    [self.productIcon.layer setMasksToBounds:YES];
    self.putAwayTimeLable.textColor = JCColor(112,176, 255);
    
}
-(void)setOderModle:(oderInfomation *)oderModle
{
    _oderModle = oderModle;
    self.productNameLable.text = [NSString stringWithFormat:@"产品名称：%@",oderModle.ProductName];
    if (![oderModle.AdvertiserName isEqualToString:@""]) {
        
        self.admentNameLable.text = [NSString stringWithFormat:@"广告商：%@",oderModle.AdvertiserName];
    }
    self.visitorPriceLable.text = [NSString stringWithFormat:@"官方刊例价：%0.2f元",oderModle.Price];
    self.centerPiceLable.text = [NSString stringWithFormat:@"会员价：%.2f元",oderModle.MemberPrice];
    self.orderPriceLable.text = [NSString stringWithFormat:@"订单价：%0.2f元",oderModle.OrderAmount];
    self.putAwayTimeLable.text = [NSString stringWithFormat:@"上架日期：%@",oderModle.PublishTime];
    [self.productIcon sd_setImageWithURL:[NSURL URLWithString:oderModle.PicName] placeholderImage:[UIImage imageNamed:@"col_img0"]];
    self.isGroupShowBtn.hidden = !oderModle.IsGroup;
}

@end
