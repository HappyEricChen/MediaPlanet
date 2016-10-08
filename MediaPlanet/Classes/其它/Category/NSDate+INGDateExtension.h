//
//  NSDate+INGDateExtension.h
//  MediaPlanet
//
//  Created by jamesczy on 16/7/20.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (INGDateExtension)
/**
 * 比较from和self的时间差值
 */
+(NSDateComponents *)deltaFrom:(NSDate *)from;

@end
