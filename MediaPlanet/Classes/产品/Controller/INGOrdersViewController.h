//
//  INGOrdersViewController.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/15.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class productInfo;
@class checkOrder;
@interface INGOrdersViewController : UIViewController
/** 产品详情 */
@property (nonatomic, strong) productInfo *productModle;
/** 价格模型 */
@property (nonatomic, strong) checkOrder *orderPriceModle;

@end
