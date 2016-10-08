//
//  menberList.h
//  MediaPlanet
//
//  Created by jamesczy on 16/7/21.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface menberList : NSObject
/** 拼单用户名 */
@property (nonatomic, strong) NSString *MemberName;
/** 拼单用户头像 */
@property (nonatomic, strong) NSString *Headimg;
/** 用户下单次数 */
@property (nonatomic, assign) NSInteger PurchasedQuantity;

@end
