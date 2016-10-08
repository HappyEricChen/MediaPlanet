//
//  ProductListViewController.h
//  MediaPlanet
//
//  Created by eric on 16/9/13.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductListViewController : UIViewController

/** 产品显示模式 */
@property (nonatomic, assign) productType loadType;
/** 搜索的关键字 */
@property (nonatomic, strong) NSString *searchText;
@end
