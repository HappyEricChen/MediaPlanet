//
//  INGHotView.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/12.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class INGHotView;
@protocol INGHotViewDelegate<NSObject>
@optional
/** 代理方法，发送那个按钮被点击了 */
-(void)INGHotView:(INGHotView *)hotView DidClickButton:(UIButton *)button;

@end

@interface INGHotView : UIView

@property (nonatomic, strong) NSArray *cityNameArray;
/**
 *根据城市个数计算相册尺寸
 */
+(CGSize)sizeWithCount:(int)count;

@property (nonatomic,weak) id<INGHotViewDelegate> delegate;

@end
