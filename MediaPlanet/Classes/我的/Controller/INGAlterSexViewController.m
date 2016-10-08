//
//  INGAlterSexViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/14.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  修改性别

#import "INGAlterSexViewController.h"
#import "NSMutableDictionary+Extension.h"
#import "NSString+INGExtension.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>

@interface INGAlterSexViewController ()

@property (weak, nonatomic) IBOutlet UIButton *manButton;

@property (weak, nonatomic) IBOutlet UIButton *womenButton;
@end

@implementation INGAlterSexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改性别";
    [self.view setupGifBG];
    
    if (self.gender) { //NO(0)：男 YES(1)：女
        self.womenButton.selected = YES;
        self.manButton.selected = NO;
    }else{
        self.womenButton.selected = NO;
        self.manButton.selected = YES;
    }
//    self.manButton.selected = YES;

    self.manButton.layer.borderWidth = 1.0f;
    self.manButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.manButton.layer setCornerRadius:5.0];
    [self.manButton.layer setMasksToBounds:YES];

    [self.manButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, screenW * 0.7)];
    [self.manButton setImageEdgeInsets:UIEdgeInsetsMake(0, screenW * 0.7, 0, 0)];
    
    self.womenButton.layer.borderWidth = 1.0f;
    self.womenButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.womenButton.layer setCornerRadius:5.0];
    [self.womenButton.layer setMasksToBounds:YES];
    
    [self.womenButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, screenW * 0.7)];
    [self.womenButton setImageEdgeInsets:UIEdgeInsetsMake(0, screenW * 0.7, 0, 0)];
}

/** 修改会员资料 */
-(void)updataInfo:(NSString *)gender
{
    NSMutableString *infoUrl = [NSMutableString string];
    [infoUrl appendString:apiUrl];
    [infoUrl appendString:@"pcenter/editmember"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"nick"] = nil;
    
    params[@"gender"] = gender;
    params[@"birth"] = nil;
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    //    params[@"pic"] = self.picStr;
    
    params[@"key"] = key;
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    
    [params removeObjectForKey:@"key"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求头
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:infoUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
}



- (IBAction)manClick:(id)sender {
    self.manButton.selected = YES;
    self.womenButton.selected = NO;
    NSString *gender = (self.manButton.isSelected == YES ? @"false" : @"true");
    [self updataInfo:gender];
    
    
}
- (IBAction)womenClick:(id)sender {
    self.womenButton.selected = YES;
    self.manButton.selected = NO;
    
    NSString *gender = (self.womenButton.isSelected == NO ? @"false" : @"true");
    [self updataInfo:gender];
    
    
}


@end
