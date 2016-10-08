//
//  adMentCell.m
//  MediaPlanet
//
//  Created by jamesczy on 16/7/12.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  广告上cell

#import "adMentCell.h"
#import "admentList.h"
#import <UIImageView+WebCache.h>

@interface adMentCell()

@property (weak, nonatomic) IBOutlet UIImageView *adMentIcon;

@property (weak, nonatomic) IBOutlet UILabel *adMentName;


@end

@implementation adMentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.size = CGSizeMake((screenW - 3)/ 4, (screenW - 3)/ 4 + 30);
    // Initialization code
//    self.adMentIcon.layer.cornerRadius = self.width * 0.5;
    self.adMentIcon.layer.borderWidth = 3.0f;
    self.adMentIcon.layer.borderColor = JCColor(228, 228, 228).CGColor;
    [self.adMentIcon.layer setMasksToBounds:YES];
//    self.transform = CGAffineTransformMakeRotation(M_PI );
    

}

-(void)setListModle:(admentList *)listModle
{
    _listModle = listModle;
    self.adMentName.text = listModle.CompName;
    [self.adMentIcon sd_setImageWithURL:[NSURL URLWithString:listModle.Logo] placeholderImage:[UIImage imageNamed:@"partner_img0"]];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
}
@end
