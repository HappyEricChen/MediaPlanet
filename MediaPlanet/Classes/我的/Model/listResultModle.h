//
//  listResultModle.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/24.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  在线留言回复列表

#import <Foundation/Foundation.h>

@interface listResultModle : NSObject
/** 留言信息 */
@property (nonatomic, strong) NSString *MessageTxt;
/** 回复信息 */
@property (nonatomic, strong) NSString *ReplyMessage;
/** 留言时间 */
@property (nonatomic, strong) NSString *MessageTime;
/** 回复时间 */
@property (nonatomic, strong) NSString *ReplyTime;
/** 是否回复 */
@property (nonatomic, strong) NSString *ReplyStateChar;
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** cell顶部view的高度 */
@property (nonatomic, assign) CGFloat topHeight;

@end
