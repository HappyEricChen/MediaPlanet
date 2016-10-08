//
//  myListModle.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/23.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "myListModle.h"

@implementation myListModle
/*
-(CGFloat)cellHeight
{
    if (!_cellHeight) {
        CGSize maxSize = CGSizeMake(screenW - 105, MAXFLOAT);
        
        CGFloat OrderTimeH = [[NSString stringWithFormat:@"时间：%@ ",[self.OrderTime substringToIndex:10]]boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        //产品名称的文字高度
        CGFloat ProductNameH = [[NSString stringWithFormat:@"产品名称：%@",self.ProductName] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        if (ProductNameH > 33) {
            ProductNameH = 33;
        }
        //广告商的文字高度
        CGFloat AdvertiserNameH = 0;
        if (![self.AdvertiserName isEqualToString:@""]) {
            
            AdvertiserNameH = [[NSString stringWithFormat:@"广告商：%@",self.AdvertiserName] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
            if (AdvertiserNameH > 33) {
                AdvertiserNameH = 33;
            }
        }
        //官方刊例价格的文字高度
        CGFloat PriceH = [[NSString stringWithFormat:@"官方刊例价：%f元",self.Price ] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        if (PriceH > 33) {
            PriceH = 33;
        }
        //会员价格的文字高度
        CGFloat MemberPriceH = [[NSString stringWithFormat:@"会员价：%f元",self.MemberPrice ] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        if (MemberPriceH > 33) {
            MemberPriceH = 33;
        }
        //下单价格的文字高度
        CGFloat OrderAmountH = [[NSString stringWithFormat:@"下单价：%f元",self.OrderAmount ] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        if (OrderAmountH > 33) {
            OrderAmountH = 33;
        }
//        //上架时间的文字高度
//        CGFloat PublishTimeH = [[NSString stringWithFormat:@"上架日期：%@",self.PublishTime ] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
//        if (PublishTimeH > 33) {
//            PublishTimeH = 33;
//        }
        _cellHeight = MAX((OrderTimeH + 70 + 20), (OrderTimeH + ProductNameH + AdvertiserNameH +PriceH + MemberPriceH  + OrderAmountH + 50));

        if ([self.OrderStateChar isEqualToString:@"已预约"]) {
            _cellHeight = MAX(MAX((OrderTimeH + 70 + 20), (OrderTimeH + ProductNameH + AdvertiserNameH + PriceH + MemberPriceH + OrderAmountH  + 55)), (OrderTimeH + ProductNameH + AdvertiserNameH +PriceH + MemberPriceH + OrderAmountH  + 50) + 35);

        }

    }
//    NSLog(@"%0.2f",_cellHeight);
    return _cellHeight;
}
*/
@end
