//
//  NSDate+INGDateExtension.m
//  MediaPlanet
//
//  Created by jamesczy on 16/7/20.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "NSDate+INGDateExtension.h"

@implementation NSDate (INGDateExtension)

+(NSDateComponents *)deltaFrom:(NSDate *)from
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:unit fromDate:[NSDate date] toDate:from options:0];

    return cmps;
}

@end
