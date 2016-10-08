//
//  productList.m
//  MediaPlanet
//
//  Created by jamesczy on 16/7/11.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "productList.h"

@implementation productList

-(CGFloat)cellHeight
{
    if (!_cellHeight) {
        CGSize maxSize = CGSizeMake(screenW - 150, MAXFLOAT);
//        CGSize maxSizePrice = CGSizeMake(screenW - 150 - 55, MAXFLOAT);

        CGFloat ProductNameH = [[NSString stringWithFormat:@"产品名产：%@",self.ProductName] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        if (ProductNameH > 33) {
            ProductNameH = 33;
        }
        //游客价
        CGFloat ProductPriceH = [[NSString stringWithFormat:@"官方刊例价：%.2f元",self.ProductPrice] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        if (ProductPriceH > 33) {
            ProductPriceH = 33;
        }
        //会员价
        CGFloat ProductPrice0H = 0;
        if ([NSString isMemberLogin]) {
            ProductPrice0H = [[NSString stringWithFormat:@"会员价：%.2f元",self.ProductPrice0] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height + 5;
            
        }
        //        NSLog(@"%f",ProductPrice0H);
        if (ProductPrice0H > 33) {
            ProductPrice0H = 33;
        }
        CGFloat PublishTimeH = [[NSString stringWithFormat:@"上架日期：%@",self.PublishTime] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        _AdvertiserNameH = 0;
        if (![self.AdvertiserName isEqualToString:@""]) {
            _AdvertiserNameH = [[NSString stringWithFormat:@"广告商：%@",self.AdvertiserName] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
            if (_AdvertiserNameH > 33) {
                _AdvertiserNameH = 33;
            }
        }
        
        _cellHeight = MAX(130, (ProductNameH + _AdvertiserNameH + ProductPriceH + ProductPrice0H + PublishTimeH + 35)) ;

    }
    
    return _cellHeight;
}
@end
