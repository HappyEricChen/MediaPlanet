//
//  INGMyListTableViewCell.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/3.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  我的订单CELL

#import "INGMyListTableViewCell.h"
#import "myListModle.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>

@interface INGMyListTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *cellContentView;

@property (weak, nonatomic) IBOutlet UILabel *listDate;
@property (weak, nonatomic) IBOutlet UILabel *peoductName;
@property (weak, nonatomic) IBOutlet UILabel *listStatus;
@property (weak, nonatomic) IBOutlet UIImageView *productIcon;
/** 广告商 */
@property (weak, nonatomic) IBOutlet UILabel *adName;
@property (weak, nonatomic) IBOutlet UIButton *listButton;

//@property (weak, nonatomic) IBOutlet UILabel *menberPriceLable;
//@property (weak, nonatomic) IBOutlet UILabel *visitorPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLable;

@property (weak, nonatomic) IBOutlet UIView *middleInfoView;

@end

@implementation INGMyListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.middleInfoView.backgroundColor = JCColor(238, 238, 238);
//    [self.productIcon.layer setCornerRadius:self.productIcon.width * 0.5];
    [self.productIcon.layer setMasksToBounds:YES];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)listButtonClick:(id)sender {
    
    [self cancelOrder];
}
/** 取消订单 */
-(void)cancelOrder
{
    [SVProgressHUD showWithStatus:@"发送中"];
    NSMutableString *loadUrl = [NSMutableString string];
    [loadUrl appendString:apiUrl];
    [loadUrl appendString:@"products/cancelorder"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"orderNo"] = self.modle.OrderNo;
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
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            
            [SVProgressHUD showInfoWithStatus:@"取消成功"];
            self.listButton.hidden = YES;
            self.modle.OrderStateChar = @"已取消";
            self.listStatus.text = @"已取消";
        }else{
            /**
             
             1	已付款
             2	已签约
             3	已取消
             4	已预约
             
             */
            [SVProgressHUD showInfoWithStatus:@"订单状态已改变"];
            if (responseObject[@"Results"]) {
                NSInteger Results = [responseObject[@"Results"] integerValue];
                switch (Results) {
                    case 1:
                        self.listButton.hidden = YES;
                        self.modle.OrderStateChar = @"已付款";
                        self.listStatus.text = @"已付款";
                        break;
                    case 2:
                        self.listButton.hidden = YES;
                        self.modle.OrderStateChar = @"已签约";
                        self.listStatus.text = @"已签约";
                        break;
                    case 3:
                        self.listButton.hidden = NO;
                        self.modle.OrderStateChar = @"已取消";
                        self.listStatus.text = @"已取消";
                        break;
                    case 4:
                        self.listButton.hidden = NO;
                        self.modle.OrderStateChar = @"已预约";
                        self.listStatus.text = @"已预约";
                        break;
                    default:
                        break;
                }
            }
            
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络错误，请稍后重试"];
    }];
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

-(void)layoutSubviews{
//    self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
//    [self.contentView.layer setCornerRadius:5.0f];
//    self.contentView.layer.borderWidth = 0.8f;

    [self.contentView.layer setMasksToBounds:YES];
}

-(void)setModle:(myListModle *)modle
{
    _modle = modle;

//    self.listDate.text = [NSString stringWithFormat:@"时间：%@",[modle.OrderTime substringToIndex:10]];
//    self.listStatus.text = modle.OrderStateChar;
    self.peoductName.text = [NSString stringWithFormat:@"产品名称：%@",modle.ProductName];
    [self.productIcon sd_setImageWithURL:[NSURL URLWithString:modle.PicName] placeholderImage:[UIImage imageNamed:@"order_img0"]];
    self.adName.textColor = [UIColor blackColor];
    if (![modle.AdvertiserName isEqualToString:@""]) {
        
        self.adName.text = [NSString stringWithFormat:@"广告商：%@",modle.AdvertiserName];
        self.orderPriceLable.hidden = NO;
        self.orderPriceLable.textColor = [UIColor redColor];
        self.orderPriceLable.text = [NSString stringWithFormat:@"订单价：%0.2f元",modle.OrderAmount];
//        self.menberPriceLable.text = [NSString stringWithFormat:@"会员价：%0.2f元",modle.MemberPrice];
//        self.visitorPriceLable.hidden = NO;
//        self.visitorPriceLable.text = [NSString stringWithFormat:@"官方刊例价：%0.2f元",modle.Price];

    }else{
        self.adName.textColor = [UIColor redColor];
        self.adName.text = [NSString stringWithFormat:@"订单价：%0.2f元",modle.OrderAmount];
        self.orderPriceLable.hidden = YES;
        
//        self.menberPriceLable.text = [NSString stringWithFormat:@"会员价：%0.2f元",modle.MemberPrice];
//        self.visitorPriceLable.text = [NSString stringWithFormat:@"官方刊例价：%0.2f元",modle.Price];
//        self.visitorPriceLable.hidden = YES;

    }

//    if ([modle.OrderStateChar isEqualToString:@"已预约"]) {
//        self.listButton.hidden = NO;
//    }else{
//        self.listButton.hidden = YES;
//    }
}
@end
