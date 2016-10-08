//
//  NSString+INGExtension.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/20.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  简单的MD5加密

#import "NSString+INGExtension.h"

@implementation NSString (INGExtension)
#pragma mark - 简单的MD5加密
+ ( NSString *)md5String:( NSString *)str

{
    
    const char *myPasswd = [str UTF8String ];
    
    unsigned char mdc[ 16 ];
    
    CC_MD5 (myPasswd, ( CC_LONG ) strlen (myPasswd), mdc);
    
    NSMutableString *md5String = [ NSMutableString string ];
    
    for ( int i = 0 ; i< 16 ; i++) {
        
        [md5String appendFormat : @"%02x" ,mdc[i]];
        
    }
    
    return md5String;
    
}
#pragma mark - 使用SHA1加密字符串
/** 使用SHA1加密字符串 */
+ (NSString*) sha1String:(NSString *)str
{
    if (str==nil) {
        return nil;
    }
//    const char *myPasswd = [str cStringUsingEncoding:NSUTF8StringEncoding];
//        NSData *data = [NSData dataWithBytes:myPasswd length:str.length];
     NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, (unsigned)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

/** 存入沙盒 */
-(void)settingStandard:(NSString *)str
{
    //UToken的key
    NSString *UToken = str;
    //删除沙盒中的同名数据
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:UToken];
    
    //存入沙盒
    [[NSUserDefaults standardUserDefaults]setObject:self forKey:UToken];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
/** 取出沙盒中的数据 */
-(NSString *)getOutStandard
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:self];
    
}

#pragma mark - 判断是否为会员登录
/**
 *  YES为会员登录：NO为游客登录
 */
+ (BOOL)isMemberLogin{
    NSString *str = [strStander getOutStandard];
    if (str == nil) {
        return NO;
    }
    return YES;
}
@end
