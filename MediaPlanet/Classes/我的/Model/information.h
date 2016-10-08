//
//  information.h
//  MediaPlanet
//
//  Created by jamesczy on 16/7/11.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface information : NSObject
/** 生日 */
@property (nonatomic, strong) NSString *Birth;
/** 会员编号 */
@property (nonatomic, strong) NSString *MemberTag;
/** 电话 */
@property (nonatomic, strong) NSString *Phone;
/** 性别 */
@property (nonatomic, assign) BOOL Gender; // YES：女（1） NO：男（0）
/** 头像 */
@property (nonatomic, strong) NSString *Headimg;
/** 昵称 */
@property (nonatomic, strong) NSString *MemberName;


@end
