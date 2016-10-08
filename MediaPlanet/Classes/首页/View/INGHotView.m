//
//  INGHotView.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/12.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGHotView.h"

CGFloat buttonW = 71;
CGFloat buttonH = 33;
CGFloat buttonX = 30;
CGFloat buttonY = 5;
int maxCols = 3;

@implementation INGHotView

-(void)setCityNameArray:(NSArray *)cityNameArray
{
    _cityNameArray = cityNameArray;
    NSUInteger count = cityNameArray.count;
    self.backgroundColor = [UIColor clearColor];
    while (self.subviews.count < count ) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self addSubview:button];
    }
    
    for (int i = 0; i < self.subviews.count; i++) {
        
        NSString *str = NSStringFromClass([self.subviews[i] class]);
        
        
        if ([str isEqualToString:NSStringFromClass([UIButton class])]) {
            UIButton *button = self.subviews[i];
            button.tag = i;
            [button setTitle:[NSString stringWithFormat:@"%@",cityNameArray[i]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            //            [button setBackgroundColor:[UIColor whiteColor]];
            [button setBackgroundImage:[UIImage imageNamed:@"city_hot"] forState:UIControlStateNormal];
            
        }
        
    }
}
-(void)buttonClick:(UIButton *)button
{
    //发出通知，告诉控制器，选中了那个城市
    [[NSNotificationCenter defaultCenter] postNotificationName:INGCityDidSelectNotification object:nil userInfo:@{INGSelectCityName :self.cityNameArray[button.tag]}];
    
    if ([self.delegate respondsToSelector:@selector(INGHotView:DidClickButton:)]) {
        [self.delegate INGHotView:self DidClickButton:button];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat buttonMagin = (screenW - buttonX * 2 - buttonW * maxCols) / (maxCols -1);
    int count = (int)self.cityNameArray.count;

    for (int i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        int col = i % maxCols;
        int row = i / maxCols;
        
        btn.x = buttonX + col * (buttonW + buttonMagin);
        btn.y = buttonY + row * (buttonH + buttonY);
        btn.width = buttonW;
        btn.height = buttonH;
    }
//    NSLog(@"buttouH= %lf,%lf",buttonH,self.height);
}
+(CGSize)sizeWithCount:(int)count
{
    //    CGFloat buttonMagin = (screenW - buttonX * 2 - buttonW * maxCols) / (maxCols -1);
    CGFloat buttonMaginY = 5;
    //    int col = count % maxCols;
    int row = count / maxCols;
    
    CGFloat viewW = screenW;
    CGFloat viewH = row * (buttonH + buttonMaginY) + 2 * buttonX;
    
    return CGSizeMake(viewW, viewH);
}
@end
