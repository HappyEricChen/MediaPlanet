//
//  INGProductViewController.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/8.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface INGProductViewController : UIViewController
/** 产品显示模式 */
@property (nonatomic, assign) productType loadType;
/** 搜索的关键字 */
@property (nonatomic, strong) NSString *searchText;

@end
