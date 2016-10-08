//
//  productInfo.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/29.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "productInfo.h"
#import "NSString+INGExtension.h"
#import "NSDate+INGDateExtension.h"

@implementation productInfo


-(CGFloat)cellTopHeight
{
    if (!_cellTopHeight) {
        CGSize maxSize = CGSizeMake(screenW - 20, MAXFLOAT);
        CGFloat productNameH = [self.ProductName boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil].size.height;
        CGFloat AdvertiserNameH = 0;
        if (![self.AdvertiserName isEqualToString:@""]) {
            AdvertiserNameH = [[NSString stringWithFormat:@"广告商：%@",self.AdvertiserName] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
            
        }
        CGSize maxSizePrice = CGSizeMake(screenW - 147, MAXFLOAT);
        CGFloat ProductPrice0H = 0;
        if ([NSString isMemberLogin]) {
            ProductPrice0H = [[NSString stringWithFormat:@"%0.2f元",self.ProductPrice0] boundingRectWithSize:maxSizePrice options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height + 5;
            
        }
            
        CGFloat ProductPriceH = [[NSString stringWithFormat:@"%.2f元",self.ProductPrice] boundingRectWithSize:maxSizePrice options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        
//        CGFloat PublishTimeH = [[NSString stringWithFormat:@"上架日期：%@",self.PublishTime] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
//        
        CGFloat ProductDescH = [self.ProductDesc boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        _cellTopHeight = ProductPriceH + AdvertiserNameH + ProductPrice0H + productNameH +  ProductDescH + 6 * 5 + screenW * 370 / 596 + 30;/* 30为定位按钮的高度加间隔 */
    }
//    NSLog(@"%f",_cellTopHeight + 190);
    return _cellTopHeight ;
}

-(CGFloat)cellSpellHeight
{
    if (!_cellSpellHeight) {
        
    }
    
    return _cellSpellHeight;
}


-(CGFloat)cellBottomHeight
{
    if (!_cellBottomHeight) {
        CGSize maxSize = CGSizeMake(screenW - 20, MAXFLOAT);
        CGFloat productInfoH = [@"产品详情：" boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        // 创建一个富文本对象
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        // 设置富文本对象的颜色
        //这句代码没有效果
        attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
        attributes[NSBackgroundColorAttributeName] = [UIColor clearColor];
        attributes[NSFontAttributeName] = [UIFont systemFontOfSize:14];
        
        NSAttributedString *attrStr =[[NSAttributedString alloc]initWithData:[self.FullDescription dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        NSString *protocallStr = [[attrStr string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//        NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc]initWithString:protocallStr attributes:attributes];
//        self.protocalTextView.attributedText = mutableStr;
        
        CGFloat FullDescriptionH = [protocallStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        
//        if (self.OtherPics.count > 0) {//596 * 370
//            CGFloat picH = (screenW - 20) * 0.5 * self.OtherPics.count;
//            _cellBottomHeight = productInfoH + FullDescriptionH + picH;
//        }
        _cellBottomHeight = productInfoH + FullDescriptionH + 25;
        
    }
    return _cellBottomHeight;
}
-(NSString *)deltaStr
{
    if (_deltaStr == nil) {
        //时间格式处理
        NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *GroupEndDate = [fmt dateFromString:self.GroupEndDateTime];
        
        if ([GroupEndDate compare:[NSDate date]] == NSOrderedDescending) {//NSOrderedAscending
            NSDateComponents *cmps = [NSDate deltaFrom:GroupEndDate];
            NSMutableString * cmpsStr = [NSMutableString string];
            if (cmps.year > 0) {
                [cmpsStr appendString:[NSString stringWithFormat:@"%ld年",(long)cmps.year]];
            }
            if (cmps.month > 0){
                [cmpsStr appendString:[NSString stringWithFormat:@"%ld月",(long)cmps.month]];
            }
            if (cmps.day > 0){
                [cmpsStr appendString:[NSString stringWithFormat:@"%ld天",(long)cmps.day]];
            }
            if (cmps.hour > 0){
                [cmpsStr appendString:[NSString stringWithFormat:@"%02ld小时",(long)cmps.hour]];
            }
            if (cmps.hour > 0){
                [cmpsStr appendString:[NSString stringWithFormat:@"%02ld分",(long)cmps.hour]];
            }
            if (cmps.second > 0){
                [cmpsStr appendString:[NSString stringWithFormat:@"%02ld秒",(long)cmps.second]];
            }
            _deltaStr = cmpsStr;
        }else{
            _deltaStr = @"拼单也结束";
        }
    
    }
    
    return _deltaStr;
}

@end
