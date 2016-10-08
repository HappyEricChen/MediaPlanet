//
//  INGcollectListTableViewCell.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/14.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGcollectListTableViewCell.h"
#import "myColListModle.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>

@interface INGcollectListTableViewCell()


@property (weak, nonatomic) IBOutlet UIImageView *productIcon;

@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *adName;
@property (weak, nonatomic) IBOutlet UILabel *centerPrice;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UIImageView *isSoldoutImage;

@property (weak, nonatomic) IBOutlet UIButton *isGroupShowBtn;

@property (weak, nonatomic) IBOutlet UIImageView *splitView;
@property (weak, nonatomic) IBOutlet UILabel *publicationTip;
@property (weak, nonatomic) IBOutlet UILabel *centerTip;
@property (weak, nonatomic) IBOutlet UILabel *adCenterTip;
@property (weak, nonatomic) IBOutlet UILabel *groupTip;

@end


@implementation INGcollectListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    [self.productIcon.layer setCornerRadius:self.productIcon.width * 0.5];
    [self.productIcon.layer setMasksToBounds:YES];
    
    self.splitView.backgroundColor = JCColor(238, 238, 238);
    self.publicationTip.backgroundColor = JCColor(55, 61, 73);
    self.centerTip.backgroundColor = JCColor(55, 61, 73);
    self.adCenterTip.backgroundColor = JCColor(55, 61, 73);
    
    self.groupTip.backgroundColor = JCColor(55, 61, 73);
    
}

//取消收藏
- (IBAction)cancelCol:(id)sender {
    NSMutableString *collUr = [NSMutableString string];
    [collUr appendString:apiUrl];
    [collUr appendString:@"products/collections"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"product"] = _modle.ProductNo;
    params[@"isdel"] = @"true";
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
            [SVProgressHUD showSuccessWithStatus:@"取消成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:INGCancelCollectionNotification object:nil userInfo:@{INGCancelCollection:self.modle.ProductNo}];
        }else{
            [SVProgressHUD showErrorWithStatus:@"取消失败"];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试"];
        
        
    }];
}

- (IBAction)collectClick:(id)sender {
    self.collectBtn.selected = !self.collectBtn.isSelected;
    self.modle.IsSelected = self.collectBtn.isSelected;
    NSString *IsSelectedStr = self.collectBtn.isSelected == YES ? @"true" : @"false";
    [[NSNotificationCenter defaultCenter]postNotificationName:INGIsSelectedCollectionNotification object:nil userInfo:@{INGSelectedCollection : IsSelectedStr}];

}
-(void)setFrame:(CGRect)frame
{
    frame.origin.x = 0 ;
    if (frame.size.width == screenW) {
        
        //        frame.size.width -= 2 * 10  ;
        frame.size.height -= 10;
        frame.origin.y += 10;
    }
    
    
    [super setFrame:frame];
}
-(void)setModle:(myColListModle *)modle
{
    _modle = modle;
    self.centerPrice.textColor = [UIColor blackColor];
    
    self.collectBtn.selected = modle.IsCol;
    [self.productIcon sd_setImageWithURL:[NSURL URLWithString:modle.ProductPic] placeholderImage:[UIImage imageNamed:@"col_img0"]];
    self.collectBtn.selected = modle.IsSelected;
    self.isSoldoutImage.hidden = YES;//!modle.IsSoldout;
    if (modle.IsGroup) {
        self.productName.text = [NSString stringWithFormat:@" 拼单产品  %@",modle.ProductName];
        self.groupTip.hidden = NO;
    }else{
        self.productName.text = modle.ProductName;
        self.groupTip.hidden = YES;
    }
    self.groupTip.text = @" 拼单产品 ";
    [self.groupTip sizeToFit];
    self.groupTip.textColor = JCColor(255, 230, 115);
    [self.groupTip.layer setCornerRadius:self.groupTip.height * 0.5];
    [self.groupTip.layer setMasksToBounds:YES];
    
    
    //格式化官方刊列价
    NSString *ProductPriceStr = [NSString string];
    if (modle.ProductPrice > 100) {
        ProductPriceStr = [NSString stringWithFormat:@"%0.2f万元",modle.ProductPrice / 10000];
    }else{
        ProductPriceStr = [NSString stringWithFormat:@"%f元",modle.ProductPrice];;
    }
    //格式化会员价
    NSString *centerPriceStr = [NSString string];
    if (modle.ProductPrice > 100) {
        centerPriceStr = [NSString stringWithFormat:@"%0.2f万元",modle.ProductPrice0 / 10000];
    }else{
        centerPriceStr = [NSString stringWithFormat:@"%f元",modle.ProductPrice0];;
    }
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *ProductPriceAttr = [[NSMutableAttributedString alloc]initWithString:ProductPriceStr attributes:attribtDic];
    
    self.adName.textColor = [UIColor blackColor];
    self.priceLable.textColor = [UIColor blackColor];
    
    self.adCenterTip.textColor = JCColor(255, 230, 115);
    self.centerTip.textColor = JCColor(255, 230, 115);
    self.publicationTip.textColor = [UIColor lightGrayColor];

    if (![modle.AdvertiserName isEqualToString:@""]) {
        
        self.adName.text = [NSString stringWithFormat:@"广告商：%@",modle.AdvertiserName];
        self.adCenterTip.hidden = YES;
        self.publicationTip.hidden = NO;
        //self.adCenterTip.text = @" 会员价 ";
        self.centerTip.text = @" 会员价 ";
        self.publicationTip.text = @" 官方刊列价 ";
        
        self.priceLable.attributedText = ProductPriceAttr;
        self.priceLable.textColor = [UIColor lightGrayColor];
        self.centerPrice.text = centerPriceStr;
        self.priceLable.hidden = NO;

    }else{
        self.adCenterTip.hidden = NO;
        self.publicationTip.hidden = YES;
        self.adCenterTip.text = @" 会员价 ";
        self.centerTip.text = @" 官方刊列价 ";
        self.centerTip.textColor = [UIColor lightGrayColor];
        //self.publicationTip.text = @" 官方刊列价 ";
        
        self.adName.text = centerPriceStr;
        self.adName.textColor = [UIColor lightGrayColor];
        self.centerPrice.attributedText = ProductPriceAttr;
        self.centerPrice.textColor = [UIColor lightGrayColor];
        self.priceLable.hidden = YES;
        
        self.priceLable.text = centerPriceStr;

    }
    
    [self.publicationTip sizeToFit];
    [self.centerTip sizeToFit];
    [self.adCenterTip sizeToFit];
    
    self.publicationTip.layer.cornerRadius = self.publicationTip.height * 0.5;
    [self.centerTip.layer setCornerRadius:self.centerTip.height * 0.5];
    [self.adCenterTip.layer setCornerRadius:self.adCenterTip.height * 0.5];

    [self.publicationTip.layer setMasksToBounds:YES];
    [self.centerTip.layer setMasksToBounds:YES];
    [self.adCenterTip.layer setMasksToBounds:YES];
    
    self.isGroupShowBtn.hidden = YES;//!modle.IsGroup;
    

}


@end
