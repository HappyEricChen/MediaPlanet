//
//  INGSecondClassesCell.m
//  MediaPlanet
//
//  Created by jamesczy on 16/7/6.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  二级分类cell

#import "INGSecondClassesCell.h"
#import "adTypeModle.h"

@interface INGSecondClassesCell()

@property (weak, nonatomic) IBOutlet UILabel *SecondName;

@end

@implementation INGSecondClassesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModle:(adTypeModle *)modle
{
    _modle = modle;
    self.SecondName.text = modle.Name;
}

@end
