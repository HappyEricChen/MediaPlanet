//
//  INGadMentButton.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/8.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class admentList;
@class menberList;

@interface INGadMentButton : UIButton
/** 按钮名称 */
@property (nonatomic, strong) NSString *titleName;
/** 按钮图片 */
@property (nonatomic, strong) NSString *imageName;
/** 数据源 */
@property (nonatomic, strong) menberList *modle;

@end
