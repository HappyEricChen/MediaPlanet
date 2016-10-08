//
//  INGGenderPicker.h
//  MediaPlanet
//
//  Created by jamesczy on 16/9/9.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol INGGenderPickerDelegate <NSObject>

/**
 * 选择性别
 */
- (void)getSelectGender:(NSString *)gender;

@end

@interface INGGenderPicker : UIView
@property (weak, nonatomic) IBOutlet UIPickerView *genderPicker;

@property (nonatomic, weak) id<INGGenderPickerDelegate> delegate;

+ (INGGenderPicker *)instanceGenderPickerView;

@end
