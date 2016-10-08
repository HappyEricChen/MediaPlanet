//
//  INGOderInfoView.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/15.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class INGOderInfoView;
@class productInfo;
@class checkOrder;

@protocol INGOderInfoViewDelegate <NSObject>
//下单协议
-(void)INGOderInfoViewProtocol:(INGOderInfoView *)INGOderInfoView;
//提交
-(void)INGOderInfoViewCommit:(INGOderInfoView *)INGOderInfoView;
@end

@interface INGOderInfoView : UIView

/** 产品数据源 */
@property (nonatomic, strong) productInfo *productModle;
/** 价格数据源 */
@property (nonatomic, strong) checkOrder *orderModle;

+(instancetype)oderInfo;

@property (nonatomic,weak) id<INGOderInfoViewDelegate> delegate;


@property (weak, nonatomic) IBOutlet UILabel *productName;

@property (weak, nonatomic) IBOutlet UIImageView *productIcon;
@property (weak, nonatomic) IBOutlet UILabel *admentName;
/** 游客价格 */
@property (weak, nonatomic) IBOutlet UILabel *visitorPriceLable;
/** 会员价格 */
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
/** 订单价格 */
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLable;

@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (weak, nonatomic) IBOutlet UITextField *linkManTextField;

@property (weak, nonatomic) IBOutlet UITextField *phoneLable;
@property (weak, nonatomic) IBOutlet UITextField *addTextField;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIButton *oderInfo;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UIButton *subtractionButton;
@property (weak, nonatomic) IBOutlet UITextField *numOfOrderText;
@property (weak, nonatomic) IBOutlet UIButton *additionButton;
@property (weak, nonatomic) IBOutlet UILabel *putAwayTimeLbale;

@end
