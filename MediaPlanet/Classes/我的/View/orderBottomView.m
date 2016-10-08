//
//  orderBottomView.m
//  MediaPlanet
//
//  Created by jamesczy on 16/8/1.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "orderBottomView.h"
#import "oderInfomation.h"

@interface orderBottomView()

@property (weak, nonatomic) IBOutlet UILabel *oderNoLable;
@property (weak, nonatomic) IBOutlet UILabel *oderTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *payTime;

@end

@implementation orderBottomView
+(instancetype)bottomInfo
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.width = screenW - 20;
    
}

-(void)setOderModle:(oderInfomation *)oderModle
{
    _oderModle = oderModle;
    
    self.oderNoLable.text = [NSString stringWithFormat:@"订单编号：%@",oderModle.OrderNo];
    self.oderTimeLable.text = [NSString stringWithFormat:@"下单时间：%@",oderModle.OrderTime];
    self.payTime.text = [NSString stringWithFormat:@"付款时间：%@",oderModle.PaymentTime];
}
@end
