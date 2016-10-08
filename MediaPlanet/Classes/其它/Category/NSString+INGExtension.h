//
//  NSString+INGExtension.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/20.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (INGExtension)
/** 使用MD5加密字符串 */
+ ( NSString *)md5String:( NSString *)str;

/** 使用SHA1加密字符串 */
+ (NSString *)sha1String:(NSString *)str;

/** 判断是否为会员登录 */
+(BOOL)isMemberLogin;

/** 存入沙盒 */
-(void)settingStandard:(NSString *)str;

/** 取出沙盒中的数据 */
-(NSString *)getOutStandard;


@end
