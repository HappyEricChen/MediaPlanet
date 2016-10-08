//
//  INGDatePickerView.h
//  MediaPlanet
//
//  Created by jamesczy on 16/6/15.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    // 开始日期
    DateTypeOfStart = 0,
    
    // 结束日期
    DateTypeOfEnd,
    
}DateType;
@protocol INGDatePickerViewDelegate <NSObject>

/**
 *  选择日期确定后的代理事件
 *
 *  @param date 日期
 *  @param type 时间选择器状态
 */
- (void)getSelectDate:(NSString *)date type:(DateType)type;

@end

@interface INGDatePickerView : UIView
+ (INGDatePickerView *)instanceDatePickerView;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;

@property (nonatomic, weak) id<INGDatePickerViewDelegate> delegate;

@property (nonatomic, assign) DateType Datetype;

@end
