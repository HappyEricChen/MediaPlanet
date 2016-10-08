//
//  INGHotCitiesTableViewCell.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/7.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGHotCitiesTableViewCell.h"
#import "INGHotView.h"
#import "hotFrameModel.h"
#import "citiesModel.h"

@interface INGHotCitiesTableViewCell()


@end

@implementation INGHotCitiesTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *ID = @"status";
    INGHotCitiesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[INGHotCitiesTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
    
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
    }
    return  self;
}
-(void)setHotView
{
    INGHotView *view = [[INGHotView alloc]init];
    view.backgroundColor = [UIColor blackColor];
    view.cityNameArray = self.hotFrame.citiesModel.cities;
    [self.contentView addSubview:view];
    UIImageView *lineView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
    
//    NSLog(@"view.height = %f",view.height);
    lineView.frame = CGRectMake(0, self.hotFrame.cellHeight - 1, screenW, 1);
    
    [self.contentView addSubview:lineView];
    self.hotView = view;
}
-(void)setHotFrame:(hotFrameModel *)hotFrame
{
    
    _hotFrame = hotFrame;
    [self setHotView];
    self.hotView.frame = hotFrame.hotFrame;
    
}



@end
