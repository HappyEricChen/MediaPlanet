//
//  myColListModle.m
//  MediaPlanet
//
//  Created by jamesczy on 16/7/6.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "myColListModle.h"

@implementation myColListModle
-(CGFloat)cellHeight
{
    if (!_cellHeight) {
        CGSize maxSize = CGSizeMake(screenW - 146, MAXFLOAT);
        CGFloat ProductNameH = [[NSString stringWithFormat:@"产品名称：%@",self.ProductName]boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        if (ProductNameH > 33) {
            ProductNameH = 33;
        }
        CGFloat AdvertiserNameH = 0;
        if (![self.AdvertiserName isEqualToString:@""]) {
            
            AdvertiserNameH = [[NSString stringWithFormat:@"广告商：%@",self.AdvertiserName]boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
            if (AdvertiserNameH > 33) {
                AdvertiserNameH = 33;
            }
        }
        //会员价
        CGFloat ProductPrice0H = [[NSString stringWithFormat:@"会员价：%0.2f元",self.ProductPrice0]boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        if (ProductPrice0H > 33) {
            ProductPrice0H = 33;
        }
        //游客价格
        CGFloat ProductPriceH = [[NSString stringWithFormat:@"官方刊例价：%0.2f元",self.ProductPrice]boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        if (ProductPriceH > 33) {
            ProductPriceH = 33;
        }
        
        _cellHeight = MAX(130, ProductNameH + AdvertiserNameH + ProductPrice0H + ProductPriceH + 50) ;
 
    }
    return _cellHeight;
}
@end
