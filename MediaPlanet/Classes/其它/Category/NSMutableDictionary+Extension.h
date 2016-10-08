//
//  NSMutableDictionary+Extension.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/24.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Extension)
/** 按字典的key的升序排列，取出对应的value，转为小写，返回对应的字符串 */
-(NSString *)dictKeyAesSortGetValue;
@end
