//
//  INGCitiesTableViewCell.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/7.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGCitiesTableViewCell.h"
#import "citiesModel.h"

@interface INGCitiesTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *hotCitiesView;


@end

@implementation INGCitiesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.textLabel.textColor = [UIColor whiteColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
