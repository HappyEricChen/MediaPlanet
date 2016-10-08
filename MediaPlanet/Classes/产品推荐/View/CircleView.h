//
//  CircleView.h
//  MediaPlanet
//
//  Created by eric on 16/9/27.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView

@property(assign,nonatomic)CGFloat startValue;
@property(assign,nonatomic)CGFloat lineWidth;
@property(assign,nonatomic)CGFloat value;
@property(strong,nonatomic)UIColor *lineColr;

/**
 *  颜色渐变
 */
//@property (nonatomic) CGPoint inputPoint0;
//@property (nonatomic) CGPoint inputPoint1;
@property (nonatomic) UIColor *inputColor0;
@property (nonatomic) UIColor *inputColor1;
@end
