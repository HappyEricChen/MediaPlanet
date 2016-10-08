//
//  INGadmentInfoView.m
//  MediaPlanet
//
//  Created by jamesczy on 16/9/27.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGadmentInfoView.h"
#import "admentList.h"
#import <UIImageView+WebCache.h>

@interface INGadmentInfoView()
@property (weak, nonatomic) IBOutlet UIImageView *adIcon;

@property (weak, nonatomic) IBOutlet UILabel *admentNameLable;
@property (weak, nonatomic) IBOutlet UITextView *adInfoText;
@end

@implementation INGadmentInfoView

+(INGadmentInfoView *)admentInfoView
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil].lastObject;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.adIcon.layer.borderWidth = 5.0f;
    self.adIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.adIcon.layer setMasksToBounds:YES];
    
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.8;
    self.admentNameLable.width += 10;
    self.admentNameLable.layer.borderColor = [UIColor whiteColor].CGColor;
    self.admentNameLable.layer.borderWidth = 1.0f;
    [self.admentNameLable.layer setMasksToBounds:YES];
}
-(void)setAdmentModle:(admentList *)admentModle
{
    _admentModle = admentModle;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更新界面
        self.adInfoText.text = admentModle.CompDesc;
        [self.adIcon sd_setImageWithURL:[NSURL URLWithString:admentModle.Logo]];
        self.admentNameLable.text = admentModle.CompName;
        

    });
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}
@end
