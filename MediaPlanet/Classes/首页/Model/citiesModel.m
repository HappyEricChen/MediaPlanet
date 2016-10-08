//
//  citiesModel.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/7.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "citiesModel.h"

@implementation citiesModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return  self;
}
+(instancetype)cityGroupWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}


+(NSArray *)cityGroupArray
{
    NSMutableArray *arrayM =[NSMutableArray array];
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"cityGroups.plist" ofType:nil ]];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self cityGroupWithDict:dict]];
    }
    return arrayM;
}

@end
