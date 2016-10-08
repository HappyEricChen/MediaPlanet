//
//  INGOrdersViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/15.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  立即下单

#import "INGOrdersViewController.h"
#import "INGOderInfoView.h"
#import "productInfo.h"
#import "checkOrder.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import "INGProtocalInfoViewController.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>

@interface INGOrdersViewController ()<INGOderInfoViewDelegate,UIScrollViewDelegate>

/** INGOderInfoView */
@property (nonatomic, strong) INGOderInfoView *infoView;
/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *params;

@end

@implementation INGOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"立即下单";
    [self.view setupGifBG];
    [self setscroll];
}

-(void)setscroll
{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.x = 0;
    scrollView.y = 64;
    scrollView.width = screenW;
    scrollView.height = screenH - 64;
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(0, screenH);
    scrollView.delegate = self;
    self.scrollView = scrollView;
    
    
    INGOderInfoView *infoView = [INGOderInfoView oderInfo];
    infoView.productModle = self.productModle;
    infoView.orderModle = self.orderPriceModle;
    infoView.delegate = self;
    self.infoView = infoView;
    
    [scrollView addSubview:infoView];
    
    scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(scrollView.frame)+ 10);
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.view.frame = [UIScreen mainScreen].bounds;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    NSLog(@"%s",__func__);
    [self.view endEditing:YES];
}
#pragma mark - INGOderInfoViewDelegate
-(void)INGOderInfoViewProtocol:(INGOderInfoView *)INGOderInfoView
{
    INGProtocalInfoViewController *protocalVC = [[INGProtocalInfoViewController alloc]init];
    protocalVC.title = @"下单须知";
    [self.navigationController pushViewController:protocalVC animated:YES];
//    NSLog(@"%s",__func__);
}
/** 提交订单 */
-(void)INGOderInfoViewCommit:(INGOderInfoView *)INGOderInfoView
{
    NSMutableString *orderUrl = [NSMutableString string];
    [orderUrl appendString:apiUrl];
    [orderUrl appendString:@"products/neworder"];
    [SVProgressHUD showWithStatus:@"发送中"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = key;
    params[@"product"] = self.productModle.ProductNo;
    params[@"phone"] = self.infoView.phoneLable.text;
    params[@"contact"] = self.infoView.linkManTextField.text;
    params[@"address"] = self.infoView.addTextField.text;
    params[@"cnt"] = @([self.infoView.numOfOrderText.text integerValue]);
    
    params[@"price"] = [NSString stringWithFormat:@"%0.2f",self.orderPriceModle.Price / [self.infoView.numOfOrderText.text integerValue]];
    params[@"memberprice"] = [NSString stringWithFormat:@"%0.2f",self.orderPriceModle.MemberPrice];
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    self.params = params;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:orderUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if (self.params != params) {
            return ;
        }
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"下单成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [SVProgressHUD dismiss];
            
            NSString *resultStr = responseObject[@"Results"];
            NSString *messageStr = nil;
            if (![resultStr isKindOfClass:[NSNull class]]) {
                self.orderPriceModle = [checkOrder mj_objectWithKeyValues:responseObject[@"Results"]];
                if ([responseObject[@"ErrorMessage"] isEqualToString:@"当前产品的会员价格已变更"]) {
                    
                    messageStr = [NSString stringWithFormat:@"%@,价格为%0.2f元,订单价格为%0.2f元",responseObject[@"ErrorMessage"],self.orderPriceModle.MemberPrice,self.orderPriceModle.Price];
                }else{
                    messageStr = [NSString stringWithFormat:@"%@,价格为%0.2f元,订单价格为%0.2f元",responseObject[@"ErrorMessage"],self.orderPriceModle.Price,self.orderPriceModle.Price];
                }
            }else{
                
                messageStr = [NSString stringWithFormat:@"%@",responseObject[@"ErrorMessage"]];
            }
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:messageStr preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alertVC addAction:cancelAction];
            
            if (![resultStr isKindOfClass:[NSNull class]]) {
                
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"继续下单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    self.orderPriceModle = [checkOrder mj_objectWithKeyValues:responseObject[@"Results"]];
                    
                    [self INGOderInfoViewCommit:self.infoView];
                }];
                [alertVC addAction:sureAction];
            }
            
            [self presentViewController:alertVC animated:YES completion:nil];
//            [SVProgressHUD showErrorWithStatus:responseObject[@"ErrorMessage"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) {
            return ;
        }
        [SVProgressHUD showErrorWithStatus:@"请求错误,请稍后重试"];
    }];
    
//    [self.navigationController popViewControllerAnimated:YES];
//    NSLog(@"%s",__func__);
}
-(void)setProductModle:(productInfo *)productModle
{
    _productModle = productModle;
    
}
@end
