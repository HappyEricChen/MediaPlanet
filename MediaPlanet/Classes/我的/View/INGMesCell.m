//
//  INGMesCell.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/2.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGMesCell.h"
#import "personalInfo.h"

@interface INGMesCell()

@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end

@implementation INGMesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setInfo:(personalInfo *)info
{
    _info = info;
//    NSLog(@"%@,%@",info.titleText,info.headerIcon);
    self.titleLable.text = info.titleText;
    self.headerIcon.image = [UIImage imageNamed:info.headerIcon];
    
}


@end
