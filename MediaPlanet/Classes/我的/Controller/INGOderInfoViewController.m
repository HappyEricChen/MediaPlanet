//
//  INGOderInfoViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/16.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  订单详情

#import "INGOderInfoViewController.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import "oderInfomation.h"
#import "orderTopView.h"
#import "orderMiddleView.h"
#import "orderBottomView.h"
#import <MJExtension.h>
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import <SVProgressHUD.h>

@interface INGOderInfoViewController ()

/** 顶部view */
@property (nonatomic, strong) orderTopView *topView;
/** 中间View */
@property (nonatomic, strong) orderMiddleView *middleView;
/** 底部View */
@property (nonatomic, strong) orderBottomView *bottomView;

/** 总View */
@property (nonatomic, strong) UIView *contentView;

/** 模型数据 */
@property (nonatomic, strong) oderInfomation *oderModle;

@end

@implementation INGOderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setupGifBG];
    
    self.navigationItem.title = @"订单详情";
    
    [self loadOderInfo];
    
}
-(void)setupContentView
{
    self.contentView = [[UIView alloc]init];
    self.contentView.x = 10;
    self.contentView.y = 64;
    self.contentView.width = screenW - 20;
    self.contentView.height = self.oderModle.infoHeight;
    [self.view addSubview:self.contentView];
    
    self.topView = [orderTopView topInfo];
    self.topView.oderModle = self.oderModle;
    self.topView.x = 0;
    self.topView.y = 0;
    self.topView.width = self.contentView.width;
    self.topView.height = self.oderModle.topHeight;
    [self.contentView addSubview:self.topView];
    
    self.middleView = [orderMiddleView middleInfo];
    self.middleView.oderModle = self.oderModle;
    self.middleView.x = 0;
    self.middleView.y = CGRectGetMaxY(self.topView.frame);
    self.middleView.width = self.contentView.width;
    self.middleView.height = self.oderModle.middleHeight;
    [self.contentView addSubview:self.middleView];
    
    self.bottomView = [orderBottomView bottomInfo];
    self.bottomView.oderModle = self.oderModle;
    self.bottomView.x = 0;
    self.bottomView.y = CGRectGetMaxY(self.middleView.frame);
    self.bottomView.width = self.contentView.width;
    self.bottomView.height = self.oderModle.bottomHeight;
    [self.contentView addSubview:self.bottomView];
    
//    self.topView.height = self.oderModle.topHeight;
//    self.middleView.height = self.oderModle.middleHeight;
//    self.bottomView.height = self.oderModle.bottomHeight;

    self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.contentView.layer.borderWidth = 1.0f;
    [self.contentView.layer setMasksToBounds:YES];
    
}
-(void)loadOderInfo
{
    NSMutableString *loadUrl = [NSMutableString string];
    [loadUrl appendString:apiUrl];
    [loadUrl appendString:@"products/qorderdetail"];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"orderNo"] = self.orderNo;
    params[@"ts"] = timeSp;
    params[@"key"] = key;
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    
    params[@"sign"] = sign;
    
    [params removeObjectForKey:@"key"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求头
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    
    [manager POST:loadUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        self.oderModle = [oderInfomation mj_objectWithKeyValues:responseObject[@"Results"]];
        if (!self.oderModle.infoHeight) {
            [self loadOrderHeight];
        }
        [self setupContentView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络异常，请稍后重试"];
        [self setupContentView];
    }];
}
-(void)setOderModle:(oderInfomation *)oderModle
{
    _oderModle = oderModle;
    
}

-(CGFloat)loadOrderHeight
{
    return self.oderModle.infoHeight;
}
@end
