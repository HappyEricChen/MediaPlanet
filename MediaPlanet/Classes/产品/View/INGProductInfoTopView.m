//
//  INGProductInfoTopView.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/9.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  详情View

#import "INGProductInfoTopView.h"
#import "INGNavigationController.h"
#import "INGMapViewController.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import "productInfo.h"
#import "NSDate+INGDateExtension.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>

@interface INGProductInfoTopView()
@property (weak, nonatomic) IBOutlet UIImageView *productBigView;

@property (weak, nonatomic) IBOutlet UILabel *productNameLable;

@property (weak, nonatomic) IBOutlet UILabel *adNameLable;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UILabel *productInfoLable;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@property (weak, nonatomic) IBOutlet UILabel *centerPriceLable;
/** 定位按钮 */
@property (weak, nonatomic) IBOutlet UIButton *LocateButton;
/** 拼单产品的提示 */
@property (weak, nonatomic) IBOutlet UILabel *SpelllistTip;

@property (weak, nonatomic) IBOutlet UILabel *centerTip;

@property (weak, nonatomic) IBOutlet UILabel *officialTip;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *officialPriceLeftLayout;
@end

@implementation INGProductInfoTopView

+(instancetype)productInfo
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    
}

/** 定位位置 */
- (IBAction)mapButtonClick:(id)sender {
//    NSLog(@"%s",__func__);
    INGMapViewController *mapVC = [[INGMapViewController alloc]init];
    mapVC.infoModle = self.productModle;
    INGNavigationController *nav = [[INGNavigationController alloc]initWithRootViewController:mapVC];
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [root presentViewController:nav animated:YES completion:nil];;
}
/** 收藏 */
- (IBAction)collectButtonClick:(id)sender {
    
    if (![NSString isMemberLogin]) {
        [SVProgressHUD showInfoWithStatus:@"您还未登录，请先登录!"];
        return;
    }
    
    self.collectButton.selected = !self.collectButton.isSelected;
    NSMutableString *collUr = [NSMutableString string];
    [collUr appendString:apiUrl];
    [collUr appendString:@"products/collections"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"product"] = _productModle.ProductNo;
    params[@"isdel"] = self.collectButton.isSelected == NO ? @"true":@"false";
    params[@"key"] = key;
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    
    [params removeObjectForKey:@"key"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:collUr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            if (self.collectButton.isSelected) {
                
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"取消成功"];
            }
        }else{
            if (self.collectButton.isSelected) {
                
                [SVProgressHUD showErrorWithStatus:@"收藏失败"];
            }else{
                [SVProgressHUD showErrorWithStatus:@"取消失败"];
            }
            
            self.collectButton.selected = !self.collectButton.isSelected;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showSuccessWithStatus:@"请求失败"];
        self.collectButton.selected = !self.collectButton.isSelected;
    }];
}
/** 登录 */
- (IBAction)loginButtonClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(loginINGProductInfoTopView: )]) {
        [self.delegate loginINGProductInfoTopView:self];
    }
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.width = screenW;
    [self.productBigView.layer setMasksToBounds:YES];
    if ([NSString isMemberLogin]) {
        
        //设置button的下划线
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc]initWithString:@"登录查看会员价格"];
        NSRange titleRange= {0,[title length]};
        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
        NSMutableDictionary *attribusDict = [NSMutableDictionary dictionary];
        
        //    attribusDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
        attribusDict[NSFontAttributeName] = [UIFont systemFontOfSize:13];
        
        [self.lookPriceButton setAttributedTitle:title forState:UIControlStateNormal];
        self.lookPriceButton.hidden = YES;
    }else{
        self.lookPriceButton.hidden = NO;
    }
    
    self.LocateButton.titleLabel.font = [UIFont fontWithName:@"迷你简楷体" size:14];
    
    self.SpelllistTip.text = @"  拼单产品  ";
    [self.SpelllistTip sizeToFit];
    self.SpelllistTip.layer.cornerRadius = self.SpelllistTip.height * 0.5;
    self.SpelllistTip.backgroundColor = JCColor(55, 61, 73);
    self.SpelllistTip.textColor = JCColor(255, 230, 115);
    [self.SpelllistTip.layer setMasksToBounds:YES];
    
    self.centerTip.text = @" 会员价 ";
    [self.centerTip sizeToFit];
    self.centerTip.layer.cornerRadius = self.centerTip.height * 0.5;
    self.centerTip.backgroundColor = JCColor(55, 61, 73);
    self.centerTip.textColor = JCColor(255, 230, 115);
    [self.centerTip.layer setMasksToBounds:YES];
    
    self.officialTip.text = @" 官方刊列价 ";
    [self.officialTip sizeToFit];
    self.officialTip.layer.cornerRadius = self.officialTip.height * 0.5;
    self.officialTip.backgroundColor = JCColor(55, 61, 73);
    self.officialTip.textColor = [UIColor lightGrayColor];
    [self.officialTip.layer setMasksToBounds:YES];
    
    self.height = self.productModle.cellTopHeight;
}

-(void)setProductModle:(productInfo *)productModle
{
    _productModle = productModle;
    self.collectButton.selected = productModle.IsCol;
    
    self.LocateButton.hidden = !productModle.IsLoc;
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *LocateAttr = [[NSMutableAttributedString alloc]initWithString:productModle.DetailProductLoc attributes:attribtDic];
    [self.LocateButton setAttributedTitle:LocateAttr forState:UIControlStateNormal];
    if (productModle.IsGroup) {
        self.SpelllistTip.hidden = NO;
        self.productNameLable.text = [NSString stringWithFormat:@"  拼单产品   %@",productModle.ProductName];
    }else{
        self.SpelllistTip.hidden = YES;
        self.productNameLable.text = [NSString stringWithFormat:@"%@",productModle.ProductName];
    }
    if (![productModle.AdvertiserName isEqualToString:@""]) {
        
        self.adNameLable.text = [NSString stringWithFormat:@"广告商：%@",productModle.AdvertiserName];
    }
    if ([NSString isMemberLogin]) {
        self.centerPriceLable.text = [NSString stringWithFormat:@"%0.2f元",productModle.ProductPrice0];
        [self.centerPriceLable sizeToFit];
        self.officialPriceLeftLayout.constant = (self.centerPriceLable.width + self.centerTip.width) + 20;
        self.centerPriceLable.hidden = NO;
        self.centerTip.hidden = NO;
    }else{
        self.officialPriceLeftLayout.constant =  0;
        self.centerPriceLable.hidden = YES;
        self.centerTip.hidden = YES;
    }
    
//    NSLog(@"左边约束 = %f",self.officialPriceLeftLayout.constant);
    NSDictionary *PriceAttribtDic = @{NSStrikethroughStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    self.priceLable.attributedText = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f元",productModle.ProductPrice] attributes:PriceAttribtDic];
    self.productInfoLable.text = productModle.ProductDesc;
    [self.productBigView sd_setImageWithURL:[NSURL URLWithString:productModle.ProductPic] placeholderImage:[UIImage imageNamed:@"product_detail_img0"]];

    self.GroupEndDateTimeLable.hidden = !productModle.IsGroup;
    if (productModle.IsGroup) {
        if ([productModle.deltaStr isEqualToString:@"拼单已结束"]) {
            self.GroupEndDateTimeLable.text = @"拼单已结束";
        }else{
            self.GroupEndDateTimeLable.text = [NSString stringWithFormat:@"距离拼单结束：%@",productModle.deltaStr];
            
        }
        
    }
}


@end
