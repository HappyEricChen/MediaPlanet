//
//  INGProductInfoViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/9.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  详情页

#import "INGProductInfoViewController.h"
#import "INGProductInfoTopView.h"
#import "INGOrdersViewController.h"
#import "INGSpellUserView.h"
#import "INGadMentButton.h"
#import "INGProducutBottomView.h"
#import "INGMapViewController.h"
#import "INGLoginViewController.h"
#import "INGCertificationViewController.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import "productInfo.h"
#import "menberList.h"
#import "checkOrder.h"
#import "INGNavigationController.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>

@interface INGProductInfoViewController ()<INGProductInfoTopViewDelegate>
/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;

/** INGProductInfoTopView */
@property (nonatomic, strong) INGProductInfoTopView *topInfoView;

/** INGSpellUserView */
@property (nonatomic, strong) INGSpellUserView *spellView;

/** INGProducutBottomView */
@property (nonatomic, strong) INGProducutBottomView *BottomView;

/** 模型 */
@property (nonatomic, strong) productInfo *modle;
/** 立即下单按钮 */
@property (nonatomic, strong) UIButton *listButton;

@end

@implementation INGProductInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadProductInfo];
    
    self.view.backgroundColor = JCColor(238, 238, 238);
//    [self.view setupGifBG];
    
}

/** 初始化头部详情 */
-(void)setupInfoView
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 64)];
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.width = screenW;
    scrollView.height = screenH - 64;
    scrollView.y = 64;
    scrollView.height = screenH - 64;
    
    INGProductInfoTopView *productInfoView = [INGProductInfoTopView productInfo];
//    productInfo.frame = scrollView.bounds;
    productInfoView.delegate = self;
    productInfoView.x = 0;
    productInfoView.y = 0;
    productInfoView.width = screenW;
    
//    scrollView.contentSize = CGSizeMake(0, productInfo.height);
    scrollView.backgroundColor = JCColor(238, 238, 238);
    scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(productInfoView.frame));
    productInfoView.productModle = self.modle;
    if (!self.modle.cellTopHeight) {
         [self loadCellTopHeight];
        NSLog(@"cellTopHeight = %f",self.modle.cellTopHeight);
    }
    productInfoView.height = self.modle.cellTopHeight;
    [scrollView addSubview:productInfoView];
    self.scrollView = scrollView;
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.view addSubview:scrollView];
    self.topInfoView = productInfoView;
    //初始化底部立即下单
//    CGFloat buttonW = 78;
    CGFloat buttonH = 44;
    
    listButton.frame = CGRectMake(0, screenH - buttonH, screenW, buttonH);
    [listButton setBackgroundColor:JCColor(26, 24, 43)];
    [listButton setTitle:@"立即下单" forState:UIControlStateNormal];
    [listButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [listButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [listButton addTarget:self action:@selector(oderListClick) forControlEvents:UIControlEventTouchUpInside];
    self.listButton = listButton;
    [self.view addSubview:listButton];
    if (!self.modle.IsSoldout) {
        if (!self.modle.IsGroup) {
            self.listButton.hidden = NO;
        }
    }
    
    
    self.listButton.hidden = self.modle.IsSoldout;
}
/** 初始化中间凭单用户 */
-(void)setupSpellView
{
    CGFloat itemHeight = 90;
    
    INGSpellUserView *spellView = [INGSpellUserView spellUserShow];
    spellView.infoModle = self.modle;
    spellView.x = 0;
    spellView.y = CGRectGetMaxY(self.topInfoView.frame) + 10;
    NSInteger count = self.modle.MemberList.count;
//    NSInteger count = 5;
    
    NSInteger cols = count % 4 == 0 ?count / 4 : count / 4 +1;
    spellView.width = screenW;
    spellView.height = cols * (itemHeight + 5) + 29;
    self.spellView = spellView;
    [self.scrollView addSubview:spellView];
    
    
}
/** 初始化底部详情 */
-(void)setupBottomView
{
    INGProducutBottomView *bottomView = [INGProducutBottomView ProductBottom];
    bottomView.infoModle = self.modle;
    bottomView.x = 0;
    bottomView.width = screenW;
    if (self.modle.IsGroup) {
        bottomView.y = CGRectGetMaxY(self.spellView.frame) + 10;
    }else{
        bottomView.y = CGRectGetMaxY(self.topInfoView.frame) + 10;
    }
    if (!self.modle.cellBottomHeight) {
        [self loadCellBottomHeight];
//        NSLog(@"cellBottomHeight = %f",self.modle.cellBottomHeight);
    }
    bottomView.height = self.modle.cellBottomHeight;
    [self.scrollView addSubview:bottomView];
    self.BottomView = bottomView;
    if (self.modle.OtherPics.count) {
        
        for (int i = 0; i < self.modle.OtherPics.count; i++) {
            UIImageView *picView = [[UIImageView alloc]init];
            picView.width = screenW - 20;
            picView.height = picView.width * 370 / 596;
            picView.x = 10;
            picView.y = CGRectGetMaxY(self.BottomView.frame)+ 5 + i * (picView.height + 5) ;
            
            [picView sd_setImageWithURL:[NSURL URLWithString:self.modle.OtherPics[i]] placeholderImage:[UIImage imageNamed:@"product_detail_img0"]];
            [self.scrollView addSubview:picView];
            
        }
    }
    self.scrollView.contentSize = CGSizeMake(0, bottomView.y +bottomView.height + ((screenW - 20) * 370 / 596 + 5) * self.modle.OtherPics.count );
}

-(CGFloat)loadCellTopHeight
{
    return self.modle.cellTopHeight;
}
-(CGFloat)loadCellBottomHeight
{
    return self.modle.cellBottomHeight;
}
-(void)oderListClick
{
    if ([NSString isMemberLogin]) {
        [self loadUserStatus];
        
    }else{
//        [SVProgressHUD showInfoWithStatus:@"普通用户无法下单，请先升级为认证用户"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还未登录，请先登录" preferredStyle:UIAlertControllerStyleAlert];
        [alert.view setBackgroundColor:[UIColor colorWithHue:99/255 saturation:99/255 brightness:99/255 alpha:0.5]];
        UIAlertAction *certificationAction = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            INGLoginViewController *loginVC = [[INGLoginViewController alloc]init];
            INGNavigationController *nav = [[INGNavigationController alloc]initWithRootViewController:loginVC];
            //    [self.navigationController pushViewController:loginVC animated:YES];
            [self presentViewController:nav animated:YES completion:nil];
        }];

        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"再逛逛" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:cancleAction];
        [alert addAction:certificationAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark - 请求网络数据
-(void)loadProductInfo
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSMutableString *infoUrl = [NSMutableString string];
    [infoUrl appendString:apiUrl];
    [infoUrl appendString:@"products/detail"];
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"product"] = self.productName;//1337  //2101
    params[@"key"]=  key;//@"4DB03900-7322-4C9C-A5D5-94AD7E8A5703";
    params[@"ts"] = timeSp;
   
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:infoUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"加载完成"];
            self.modle = [productInfo mj_objectWithKeyValues:responseObject[@"Results"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                [self setupInfoView];
                
                if (self.modle.IsGroup) {
                    
                    [self setupSpellView];
                }
                
                [self setupBottomView];
                [self timeCountDown];
            });
        }else{
            [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试"];
    }];
}
/** 判断用户当前状态 */
-(void)loadUserStatus
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSMutableString *infoUrl = [NSMutableString string];
    [infoUrl appendString:apiUrl];
    [infoUrl appendString:@"products/chkorder"];
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"product"] = self.productName;
    params[@"key"]=  key;//@"4DB03900-7322-4C9C-A5D5-94AD7E8A5703";
    params[@"ts"] = timeSp;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:infoUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [SVProgressHUD dismiss];
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            INGOrdersViewController *vc = [[INGOrdersViewController alloc]init];
            
            vc.productModle = self.modle;
            if (responseObject[@"Results"] != NULL) {
                
                vc.orderPriceModle = [checkOrder mj_objectWithKeyValues:responseObject[@"Results"]];
            }
            
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"普通用户无法下单，请先升级为认证用户" preferredStyle:UIAlertControllerStyleAlert];
            [alert.view setBackgroundColor:[UIColor colorWithHue:99/255 saturation:99/255 brightness:99/255 alpha:0.5]];
            UIAlertAction *certificationAction = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                INGCertificationViewController *certificationVC = [[INGCertificationViewController alloc]init];
                certificationVC.title = @"申请认证";
                [self.navigationController pushViewController:certificationVC animated:YES];
            }];
            
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"再逛逛" style:UIAlertActionStyleDefault handler:nil];
            
            [alert addAction:cancleAction];
            [alert addAction:certificationAction];
            
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试"];
    }];
}
#pragma mark - productInfoView 代理

-(void)loginINGProductInfoTopView:(INGProductInfoTopView *)INGProductInfoTopView
{
    INGLoginViewController *loginVC = [[INGLoginViewController alloc]init];
    INGNavigationController *nav = [[INGNavigationController alloc]initWithRootViewController:loginVC];
//    [self.navigationController pushViewController:loginVC animated:YES];
    [self presentViewController:nav animated:YES completion:^{
        [self.navigationController popViewControllerAnimated:NO];
    }];
}


-(void)timeCountDown
{
    //时间格式处理
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *GroupEndDate = [fmt dateFromString:self.modle.GroupEndDateTime];
    __block NSInteger timeout = [GroupEndDate timeIntervalSinceNow];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            NSMutableString *strTime = [NSMutableString string];
            [strTime appendString:@"拼单已结束"];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.topInfoView.GroupEndDateTimeLable.text = strTime;
                
                if ([self.topInfoView.GroupEndDateTimeLable.text isEqualToString:@"拼单已结束"] && self.topInfoView.GroupEndDateTimeLable.isHidden == NO) {
                    self.listButton.hidden = YES;
                }
            });
            dispatch_source_cancel(_timer);
            
        }else{
            NSInteger days  = timeout / (3600 * 24);
            NSInteger hours = (timeout % (3600 * 24))/3600;
            NSInteger minutes = (timeout%3600)/60;
            NSInteger seconds = timeout % 60;
            NSMutableString *strTime = [NSMutableString string];
            
            [strTime appendString:@"距离拼单结束："];
            if (days > 0) {
                [strTime appendString:[NSString stringWithFormat:@"%ld天",(long)days]];
                if (hours > 0) {
                    [strTime appendString:[NSString stringWithFormat:@"%02ld小时",(long)hours]];
                    if (minutes > 0) {
                        [strTime appendString:[NSString stringWithFormat:@"%02ld分%02ld秒",(long)minutes,seconds]];

                    }else{
                        [strTime appendString:[NSString stringWithFormat:@"00分%02ld秒",(long)seconds]];
                    }
                }else{
                    [strTime appendString:[NSString stringWithFormat:@"00小时"]];
                    if (minutes > 0) {
                        [strTime appendString:[NSString stringWithFormat:@"%02ld分%02ld秒",(long)minutes,seconds]];
                        
                    }else{
                        [strTime appendString:[NSString stringWithFormat:@"00分%02ld秒",(long)seconds]];
                    }
                }
            }else{
                [strTime appendString:[NSString stringWithFormat:@"000天"]];
                if (hours > 0) {
                    [strTime appendString:[NSString stringWithFormat:@"%02ld小时",(long)hours]];
                    if (minutes > 0) {
                        [strTime appendString:[NSString stringWithFormat:@"%02ld分%02ld秒",(long)minutes,seconds]];
                        
                    }else{
                        [strTime appendString:[NSString stringWithFormat:@"%02ld秒",(long)seconds]];
                    }
                }else{
                    [strTime appendString:[NSString stringWithFormat:@"00小时"]];
                    if (minutes > 0) {
                        [strTime appendString:[NSString stringWithFormat:@"%02ld分%02ld秒",(long)minutes,seconds]];
                        
                    }else{
                        [strTime appendString:[NSString stringWithFormat:@"00分%02ld秒",(long)seconds]];
                        
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.topInfoView.GroupEndDateTimeLable.text = strTime;
                if ([self.topInfoView.GroupEndDateTimeLable.text isEqualToString:@"拼单已结束"]) {
                    self.listButton.hidden = YES;
                }

            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);

}

@end
