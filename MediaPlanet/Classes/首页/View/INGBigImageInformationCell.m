//
//  INGBigImageInformationCell.m
//  MediaPlanet
//
//  Created by jamesczy on 16/9/28.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGBigImageInformationCell.h"
#import "informationModle.h"
#import <UIImageView+WebCache.h>

@interface INGBigImageInformationCell()

@property (weak, nonatomic) IBOutlet UIImageView *informationImageView;
@property (weak, nonatomic) IBOutlet UILabel *informationLable;

@end

@implementation INGBigImageInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFrame:(CGRect)frame
{
    frame.origin.y += 10;
    frame.size.height -= 10;
    [super setFrame:frame];
}

-(void)setModle:(informationModle *)modle
{
    _modle = modle;
    [self.informationImageView sd_setImageWithURL:[NSURL URLWithString:modle.PicUrl] placeholderImage:[UIImage imageNamed:@"home_img"]];
    self.informationLable.text = modle.TitleAttribute;
}
@end
