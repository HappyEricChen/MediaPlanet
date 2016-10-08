//
//  INGPushInfoCell.m
//  MediaPlanet
//
//  Created by jamesczy on 16/8/25.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGPushInfoCell.h"
@interface INGPushInfoCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLable;

@property (weak, nonatomic) IBOutlet UILabel *msgLable;
@property (weak, nonatomic) IBOutlet UIView *msgInfoView;
@end

@implementation INGPushInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.width = screenW;
    self.dateLable.backgroundColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:0.5];
    self.msgLable.textColor = JCColor(112,176, 255);
    
}
-(void)layoutSubviews
{
    [self.dateLable.layer setCornerRadius:self.dateLable.height * 0.5];
    [self.dateLable.layer setMasksToBounds:YES];
    
    [self.msgInfoView.layer setCornerRadius:5.0f];
    self.msgInfoView.layer.borderColor = [UIColor lightTextColor].CGColor;
    self.msgInfoView.layer.borderWidth = 1.0f;
    [self.msgInfoView.layer setMasksToBounds:YES];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
