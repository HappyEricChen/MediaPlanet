//
//  TypeSelectedView.h
//  MediaPlanet
//
//  Created by eric on 16/9/13.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TypeSelectedView;

@protocol TypeSelectedViewDelegate <NSObject>

@optional
/**
 *  点击了普通产品
 */
-(void)didClickWashCarButtonWithTypeSelectedView:(TypeSelectedView*)typeSelectedView;
/**
 *  点击了拼单产品
 */
-(void)didClickMaintenanceButtonWithTypeSelectedView:(TypeSelectedView*)typeSelectedView;

@end
@interface TypeSelectedView : UIView

@property (nonatomic, weak) id <TypeSelectedViewDelegate> delegate;

@end
