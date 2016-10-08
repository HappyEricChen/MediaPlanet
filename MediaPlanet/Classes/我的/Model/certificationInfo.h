//
//  certificationInfo.h
//  MediaPlanet
//
//  Created by jamesczy on 16/8/29.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  申请认证模型

#import <Foundation/Foundation.h>

@interface certificationInfo : NSObject
/** 认证返回的类型 */
@property (nonatomic, assign) NSInteger RegSt;
/** 座机电话 */
@property (nonatomic, strong) NSString *ContactTel;
/** 公司地址 */
@property (nonatomic, strong) NSString *CompDetailAddress;
/** 公司名称 */
@property (nonatomic, strong) NSString *CompName;
/** 联系人 */
@property (nonatomic, strong) NSString *Contact;
/** 手机号 */
@property (nonatomic, strong) NSString *ContactPhone;
/** 申请的图片数组 */
@property (nonatomic, strong) NSArray *Pics;
/** 不通过的原因 */
@property (nonatomic, strong) NSString *AuditMemo;

/** tag：备用 */
@property (nonatomic, assign) NSInteger Tag;

@end
