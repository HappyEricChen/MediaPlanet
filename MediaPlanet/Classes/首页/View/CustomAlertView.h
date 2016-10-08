//
//  CustomAlertView.h
//  CustomAlertView
//
//  Created by lanshang on 16/6/6.
//  Copyright © 2016年 luckyLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomAlertViewDelegate <NSObject>

@optional

-(void)clickLabelWithTag:(UIView *)label;

-(void)clickButtonWithTag:(UIButton *)button;

@end



@interface CustomAlertView : UIView

@property (nonatomic,strong)UIView *backGroundView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *detailLabel;
@property (nonatomic,strong)UILabel *bodyLabel;
@property (nonatomic,strong)UIButton *canleButton;
@property (nonatomic,strong)UIButton *otherButton;
@property (nonatomic,strong)UIImageView *horImage;
@property (nonatomic,strong)UIImageView *verImage;

@property (nonatomic,assign)id<CustomAlertViewDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title andDetail:(NSString *)detail andBody:(NSString *)body andCancelTitle:(NSString *)cancelTitel andOtherTitle:(NSString *)otherTitle;

@end
