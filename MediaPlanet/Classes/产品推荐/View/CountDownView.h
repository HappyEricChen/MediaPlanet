//
//  CountDownView.h
//  MediaPlanet
//
//  Created by eric on 16/9/19.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountDownView : UIView

/**
 *  倒计时，每秒调用一次刷新
 */
-(void)layoutCountDown:(NSInteger)countDown;

-(void)layoutWithObject:(id)object;
@end
