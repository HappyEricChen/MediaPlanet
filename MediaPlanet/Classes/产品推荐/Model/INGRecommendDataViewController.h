//
//  INGRecommendDataViewController.h
//  MediaPlanet
//
//  Created by eric on 16/9/14.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CountDownView.h"

@interface INGRecommendDataViewController : NSObject

@property (nonatomic, strong) UICollectionView* collectionView;
/**
 *  限时抢购
 */
@property (nonatomic, strong) CountDownView* countDownView;
@end
