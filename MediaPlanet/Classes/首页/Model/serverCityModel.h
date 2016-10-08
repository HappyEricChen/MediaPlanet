//
//  serverCityModel.h
//  MediaPlanet
//
//  Created by jamesczy on 16/9/14.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  服务器返回的城市数据

#import <Foundation/Foundation.h>

@interface serverCityModel : NSObject
/** 城市数量 */
@property (nonatomic, assign) NSInteger Total;
/** 城市名称数组 */
@property (nonatomic, strong) NSArray *CityName;
/** 城市分组 */
@property (nonatomic, strong) NSString *CityChar;


@end
