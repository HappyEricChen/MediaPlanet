//
//  oderInfomation.m
//  MediaPlanet
//
//  Created by jamesczy on 16/7/14.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "oderInfomation.h"

@implementation oderInfomation

-(CGFloat)infoHeight
{
    if (!_infoHeight) {
        CGSize maxSize = CGSizeMake(screenW - 20, MAXFLOAT);
        CGSize msxSizeAddress = CGSizeMake(screenW - 95, MAXFLOAT);
        CGSize msxSizeM = CGSizeMake(screenW - 20 - 111 , MAXFLOAT);
        //联系人
        CGFloat ContactH = [[NSString stringWithFormat:@"联系人：%@",self.Contact]boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        //联系电话
        CGFloat ContactTelH = [[NSString stringWithFormat:@"联系电话：%@",self.ContactTel]boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        //联系地址
        CGFloat ContactAddressH = [[NSString stringWithFormat:@"联系地址：%@",self.ContactAddress]boundingRectWithSize:msxSizeAddress options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        //产品名称
        CGFloat ProductNameH = [[NSString stringWithFormat:@"产品名称：%@",self.ProductName]boundingRectWithSize:msxSizeM options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        //广告商
        CGFloat AdvertiserNameH = [[NSString stringWithFormat:@"广告商：%@",self.AdvertiserName]boundingRectWithSize:msxSizeM options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        //官方刊例价
        CGFloat PriceH = [[NSString stringWithFormat:@"官方刊例价：%.02f",self.Price]boundingRectWithSize:msxSizeM options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        //会员价
        CGFloat MemberPriceH = [[NSString stringWithFormat:@"会员价：%.02f",self.MemberPrice]boundingRectWithSize:msxSizeM options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        //下单价
        CGFloat OrderAmountH = [[NSString stringWithFormat:@"下单价：%.02f",self.OrderAmount]boundingRectWithSize:msxSizeM options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        //上架日期
        CGFloat PublishTimeH = [[NSString stringWithFormat:@"上架日期：%@",self.PublishTime]boundingRectWithSize:msxSizeM options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        //订单编号
        CGFloat OrderNoH = [[NSString stringWithFormat:@"订单编号：%@",self.OrderNo]boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        //下单时间
        CGFloat OrderTimeH = [[NSString stringWithFormat:@"下单时间：%@",self.OrderTime]boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        //付款时间
        CGFloat PaymentTimeH = [[NSString stringWithFormat:@"付款时间：%@",self.PaymentTime]boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        _topHeight = ContactH + ContactTelH +ContactAddressH + 30;
        _middleHeight = MAX(121,ProductNameH + AdvertiserNameH + PriceH + MemberPriceH +OrderAmountH + PublishTimeH + 45);
        _bottomHeight = OrderNoH + OrderTimeH + PaymentTimeH + 30;
        _infoHeight = _topHeight + _middleHeight + _bottomHeight;
    }
    
    return _infoHeight;
}

@end
