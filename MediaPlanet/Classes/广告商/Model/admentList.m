//
//  admentList.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/29.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "admentList.h"

@implementation admentList
-(CGFloat)CompDescH
{
    if (!_CompDescH) {
        CGSize maxSize = CGSizeMake(screenW - 40, MAXFLOAT);
        _CompDescH = [self.CompDesc boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
    }
    return _CompDescH;
}

-(CGFloat)CompNameH
{
    if (!_CompNameH) {
        CGSize maxSize = CGSizeMake(screenW - 40, MAXFLOAT);
        _CompNameH = [self.CompName boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil].size.height;
    }
    return _CompNameH;
}
@end
