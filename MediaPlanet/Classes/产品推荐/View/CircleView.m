//
//  CircleView.m
//  MediaPlanet
//
//  Created by eric on 16/9/27.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "CircleView.h"
#import <QuartzCore/QuartzCore.h>

#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式

@interface CircleView()
@property(strong,nonatomic)UIBezierPath *path;
@property(strong,nonatomic)CAShapeLayer *shapeLayer;
@property(strong,nonatomic)CAShapeLayer *bgLayer;
@property (nonatomic, strong) CAGradientLayer *colorlayer;

@end

@implementation CircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect box = CGRectInset(self.bounds, self.bounds.size.width*0.1f, self.bounds.size.height*0.1f);
        _path = [UIBezierPath bezierPathWithOvalInRect:box];
        /**
         *  背景的圆
         */
        _bgLayer = [CAShapeLayer layer];
        _bgLayer.frame = self.bounds;
        _bgLayer.fillColor = [UIColor clearColor].CGColor;
        _bgLayer.lineWidth = 2.f;
        _bgLayer.strokeColor = UIColorFromRGB(0xe0e0e0).CGColor;
        _bgLayer.strokeStart = 0.f;
        _bgLayer.strokeEnd = 1.f;
        _bgLayer.path = _path.CGPath;
        [self.layer addSublayer:_bgLayer];
        
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = self.bounds;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.lineWidth = 2.f;
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.strokeColor = [UIColor redColor].CGColor;
        _shapeLayer.strokeStart = 0.f;
        _shapeLayer.strokeEnd = 0.f;
        
        _colorlayer = [CAGradientLayer new];
        [_colorlayer setColors:[NSArray arrayWithObjects:(id)[UIColorFromRGB(0x1c64c5) CGColor],(id)[UIColorFromRGB(0x87b9f0) CGColor], nil]];
        _colorlayer.startPoint = CGPointMake(0.5, 0);
        _colorlayer.endPoint = CGPointMake(0.5, 1);
        _colorlayer.frame = CGRectMake(0, 0, self.width+6, self.height+6);
        
        _shapeLayer.path = _path.CGPath;
        [self.layer addSublayer:_shapeLayer];
        [_colorlayer setMask:_shapeLayer];
        [self.layer addSublayer:_colorlayer];
        /**
         *  有时候我们需要开始点在顶部，即（3/2）π 处，其中一个思路是将整个View逆时针旋转90度即可，在CircleView.m的initWithFrame中添加以下代码即可：
         */
        CGAffineTransform transform = CGAffineTransformIdentity;
        self.transform = CGAffineTransformRotate(transform, -M_PI / 2);
        
    }
    return self;
}

@synthesize value = _value;
-(void)setValue:(CGFloat)value{
    _value = value;
    _shapeLayer.strokeEnd = value;
}
-(CGFloat)value{
    return _value;
}

@synthesize lineColr = _lineColr;
-(void)setLineColr:(UIColor *)lineColr{
    _lineColr = lineColr;
    _shapeLayer.strokeColor = lineColr.CGColor;
}
-(UIColor*)lineColr{
    return _lineColr;
}

@synthesize lineWidth = _lineWidth;
-(void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    _shapeLayer.lineWidth = lineWidth;
    _bgLayer.lineWidth = lineWidth;
}
-(CGFloat)lineWidth{
    return _lineWidth;
}

@end
