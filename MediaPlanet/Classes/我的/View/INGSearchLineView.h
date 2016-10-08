//
//  INGSearchLineView.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/14.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface INGSearchLineView : UIView
/** 搜索框 */
@property (nonatomic, strong) UITextField *textField;
/** 占位文字 */
@property (nonatomic, strong) NSString *Placeholder;
+(instancetype)searchLine;

@end
