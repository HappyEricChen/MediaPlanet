//
//  INGSpellUserView.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/15.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class productInfo;

@interface INGSpellUserView : UIView
/** 数据模型 */
@property (nonatomic, strong) productInfo *infoModle;

+(instancetype)spellUserShow;
@end
