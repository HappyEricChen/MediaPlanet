//
//  hotFrameModel.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/12.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "hotFrameModel.h"
#import "citiesModel.h"
#import "INGHotView.h"

@implementation hotFrameModel

-(void)setCitiesModel:(citiesModel *)citiesModel
{
    _citiesModel = citiesModel;
    if (self.citiesModel.cities.count) {
        CGSize viewSize = [INGHotView sizeWithCount:(int)self.citiesModel.cities.count];
        self.hotFrame = (CGRect){{0, 0}, viewSize};
    }
    self.cellHeight = self.hotFrame.size.height + 5;
}

@end
