//
//  citiesModel.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/7.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface citiesModel : NSObject
/** 城市数量 */
@property (nonatomic, assign) NSInteger Total;

/** 城市列表 */
@property (nonatomic, strong) NSArray *List;

@property (nonatomic,copy) NSString * title;

@property (nonatomic, strong) NSArray *cities;

-(instancetype)initWithDict:(NSDictionary *)dict;

+(instancetype)cityGroupWithDict:(NSDictionary *)dict;
/** 加载城市数据 */
+(NSArray *)cityGroupArray;

@end
