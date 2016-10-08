//
//  INGProductCell.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/8.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGProductCell.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import "productList.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>

@interface INGProductCell()

@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *proIcon;

@property (weak, nonatomic) IBOutlet UILabel *productName;

@property (weak, nonatomic) IBOutlet UILabel *adName;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UIButton *isGroupBtn;
@property (weak, nonatomic) IBOutlet UIImageView *soldOutView;
@property (weak, nonatomic) IBOutlet UILabel *centerPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *putawayDateLable;

@end

@implementation INGProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.proIcon.layer setCornerRadius:self.proIcon.width * 0.5];
    [self.proIcon.layer setMasksToBounds:YES];
    
//    self.spellButton.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/** 收藏 */
- (IBAction)collectionClick:(id)sender {
    
    if (![NSString isMemberLogin]) {
        [SVProgressHUD showInfoWithStatus:@"您还未登录，请先登录!"];
        return;
    }
    self.collectionBtn.selected = !self.collectionBtn.isSelected;
    NSMutableString *collUr = [NSMutableString string];
    [collUr appendString:apiUrl];
    [collUr appendString:@"products/collections"];
    [SVProgressHUD showWithStatus:@"请求中"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"product"] = _productModle.ProductNo;
    params[@"isdel"] = self.collectionBtn.isSelected == NO ? @"true":@"false";
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
            if (self.productModle.IsCol) {
                [SVProgressHUD showSuccessWithStatus:@"取消成功"];
            }else{
                
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            }
            self.productModle.IsCol = !self.productModle.IsCol;
        }else{
            [SVProgressHUD showErrorWithStatus:@"收藏失败"];
            self.collectionBtn.selected = !self.collectionBtn.isSelected;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"请求失败,请稍后重试!"];
        self.collectionBtn.selected = !self.collectionBtn.isSelected;

    }];
}


-(void)setProductModle:(productList *)productModle
{
    _productModle = productModle;
    
    self.centerPriceLable.textColor = [UIColor whiteColor];
    self.priceLable.textColor = [UIColor whiteColor];
    self.centerPriceLable.textColor = [UIColor whiteColor];
    
    self.isGroupBtn.hidden = !productModle.IsGroup;
    self.collectionBtn.selected = productModle.IsCol;
    [self.proIcon sd_setImageWithURL:[NSURL URLWithString:productModle.ProductPic] placeholderImage:[UIImage imageNamed:@"order_img0"]];
    self.soldOutView.hidden = !productModle.IsSoldout;
    self.productName.text = [NSString stringWithFormat:@"产品名称：%@",productModle.ProductName];
    
    if (![productModle.AdvertiserName isEqualToString:@""]) {
        self.adName.text = [NSString stringWithFormat:@"广告商：%@",productModle.AdvertiserName];
        
        self.priceLable.text = [NSString stringWithFormat:@"官方刊例价：%.2f元",productModle.ProductPrice];
        if ([NSString isMemberLogin]) {
            self.centerPriceLable.text = [NSString stringWithFormat:@"会员价：%.2f元",productModle.ProductPrice0];
            self.putawayDateLable.text = [NSString stringWithFormat:@"上架日期：%@",productModle.PublishTime];
            self.putawayDateLable.textColor = JCColor(112,176, 255);
            self.putawayDateLable.hidden = NO;
        }else{
            self.centerPriceLable.text = [NSString stringWithFormat:@"上架日期：%@",productModle.PublishTime];
            self.centerPriceLable.textColor = JCColor(112,176, 255);
            self.putawayDateLable.hidden = YES;
        }
        self.priceLable.hidden = NO;
        self.centerPriceLable.hidden = NO;
    }else{
        
        self.adName.text = [NSString stringWithFormat:@"官方刊例价：%.2f元",productModle.ProductPrice];
        if ([NSString isMemberLogin]) {
            self.priceLable.text = [NSString stringWithFormat:@"会员价：%.2f元",productModle.ProductPrice0];
            self.centerPriceLable.text = [NSString stringWithFormat:@"上架日期：%@",productModle.PublishTime];
            self.centerPriceLable.textColor = JCColor(112,176, 255);
            self.centerPriceLable.hidden = NO;
        }else{
            self.priceLable.text = [NSString stringWithFormat:@"上架日期：%@",productModle.PublishTime];
            self.centerPriceLable.hidden = YES;
            self.priceLable.textColor = JCColor(112,176, 255);
        }
        self.putawayDateLable.hidden = YES;
    }
    
}
@end
