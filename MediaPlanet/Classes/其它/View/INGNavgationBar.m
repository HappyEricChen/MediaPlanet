//
//  INGNavgationBar.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/2.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGNavgationBar.h"

@implementation INGNavgationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                [view removeFromSuperview];
            }
        }
    }
    return self;
}

@end
