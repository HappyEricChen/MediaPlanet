//
//  lineView.m
//  MediaPlanet
//
//  Created by jamesczy on 16/9/26.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "lineView.h"

@implementation lineView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 1);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, 238.0 / 255.0, 238.0 / 255.0, 238.0 / 255.0, 1.0);  //线的颜色
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, 20, self.height);  //起点坐标
    CGContextAddLineToPoint(context, screenW - 20, self.height);   //终点坐标
    
    CGContextStrokePath(context);
}


@end
