//
//  NSMutableDictionary+Extension.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/24.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "NSMutableDictionary+Extension.h"

@implementation NSMutableDictionary (Extension)
/** 按字典的key的升序排列，取出对应的value，转为小写，返回对应的字符串 */
-(NSString *)dictKeyAesSortGetValue
{
    NSMutableString *valueStr = [NSMutableString string];
    //对字典的key排序
    NSArray *array = [self allKeys];
    array = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result == NSOrderedDescending;
    }];
    for (NSString *key in array) {
        [valueStr appendFormat:@"%@=%@&",key,[self valueForKey:key]];
    }

    return [[valueStr substringToIndex:valueStr.length - 1] lowercaseString];
}
@end
