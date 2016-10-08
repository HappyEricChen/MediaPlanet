//
//  INGProductInfoTopView.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/9.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class productInfo;
@class INGProductInfoTopView;

@protocol INGProductInfoTopViewDelegate <NSObject>
/** 在详情界面登录 */
-(void)loginINGProductInfoTopView:(INGProductInfoTopView*)INGProductInfoTopView ;

@end


@interface INGProductInfoTopView : UIView

/** 模型 */
@property (nonatomic, strong) productInfo *productModle;

@property (weak, nonatomic) IBOutlet UIButton *lookPriceButton;

+(instancetype)productInfo;

@property (nonatomic,weak) id<INGProductInfoTopViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *GroupEndDateTimeLable;

@end
