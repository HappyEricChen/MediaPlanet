//
//  INGPersonaHeaderView.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/2.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class pCenterInfoModle;
@class INGPersonaHeaderView;

@protocol INGPersonaHeaderViewDelegate <NSObject>

/** 点击头像弹出头像选择  */
-(void)loadPersonHeaderView:(INGPersonaHeaderView*)INGPersonaHeaderView ;

@end


@interface INGPersonaHeaderView : UIView

/** 会员数据 */
@property (nonatomic, strong) pCenterInfoModle *modle;
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (nonatomic,weak) id<INGPersonaHeaderViewDelegate> delegate;
@end
