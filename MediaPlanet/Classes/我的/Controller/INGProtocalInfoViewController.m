//
//  INGProtocalInfoViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/6.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  用户协议信息界面

#import "INGProtocalInfoViewController.h"
#import "loginMedel.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import <MJExtension.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>

@interface INGProtocalInfoViewController ()

/** textView */
//@property (nonatomic, strong) UITextView *protocalText;

@property (weak, nonatomic) IBOutlet UITextView *protocalTextView;

@end

@implementation INGProtocalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setupGifBG];
    
    [self loadProtocal];
}
-(void)loadProtocal
{
    [SVProgressHUD showWithStatus:@"加载中"];
    //请求URL
    NSMutableString *urlStr = [NSMutableString string];
    [urlStr appendString:apiUrl];
    if (self.isRegsiter) {
        
        [urlStr appendString:@"pcenter/qregprotocol"];
    }else{
        [urlStr appendFormat:@"pcenter/qorderprotocol"];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"key"]=  key;//@"4DB03900-7322-4C9C-A5D5-94AD7E8A5703";
    params[@"ts"] = timeSp;
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"]; 
    
    [[AFHTTPSessionManager manager]POST:urlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

//        NSLog(@"%@",responseObject);
        [SVProgressHUD dismiss];
        loginMedel *modle = [loginMedel mj_objectWithKeyValues:responseObject];
    
        if (modle.IsSuccess) {
            NSString *protocalHTMLStr = responseObject[@"Results"];
            
            // 创建一个富文本对象
            NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
            // 设置富文本对象的颜色
            //这句代码没有效果
            attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
            attributes[NSBackgroundColorAttributeName] = [UIColor clearColor];
            attributes[NSFontAttributeName] = [UIFont systemFontOfSize:14];
            
            NSAttributedString *attrStr =[[NSAttributedString alloc]initWithData:[protocalHTMLStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            NSString *protocallStr = [attrStr string];
            NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc]initWithString:protocallStr attributes:attributes];
            self.protocalTextView.attributedText = mutableStr;
        }else{
            [SVProgressHUD showErrorWithStatus:modle.ErrorMessage];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"未查询到相关的数据"];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** 设置控制器对应的状态栏是白色 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
