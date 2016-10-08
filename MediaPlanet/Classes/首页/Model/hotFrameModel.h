//
//  hotFrameModel.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/12.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class citiesModel;
@interface hotFrameModel : NSObject
/** citiesModel */
@property (nonatomic, strong) citiesModel *citiesModel;


@property (nonatomic,assign) CGRect hotFrame;

@property (nonatomic,assign) CGFloat cellHeight;

@end
