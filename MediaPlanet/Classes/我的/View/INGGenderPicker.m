//
//  INGGenderPicker.m
//  MediaPlanet
//
//  Created by jamesczy on 16/9/9.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGGenderPicker.h"
@interface INGGenderPicker()<UIPickerViewDataSource,UIPickerViewDelegate>
/** 选择的性别 */
@property (nonatomic, strong) NSString *gender;
/** 性别数组 */
@property (nonatomic, strong) NSArray *genderArray;

@end

@implementation INGGenderPicker

-(NSArray *)genderArray
{
    if (_genderArray == nil) {
        _genderArray = @[@"男",@"女"];
    }
    return _genderArray;
}
+ (INGGenderPicker *)instanceGenderPickerView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"INGGenderPicker" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.frame = [UIScreen mainScreen].bounds;
    self.genderPicker.delegate = self;
    self.genderPicker.dataSource = self;
}
- (IBAction)cancelClick:(id)sender {
    [self animationbegin:sender];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (IBAction)doneClick:(id)sender {
    [self animationbegin:sender];
    
    NSInteger selecteRow = [self.genderPicker selectedRowInComponent:0];
    
    self.gender = self.genderArray[selecteRow];
    
    [self.delegate getSelectGender:self.gender];
    
    NSLog(@"当前选中的性别：%@",self.gender);
    
    [self cancelClick:nil];
}
- (void)animationbegin:(UIView *)view
{
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项设定
    animation.duration = 0.1; // 动画持续时间
    animation.repeatCount = -1; // 重复次数
    animation.autoreverses = YES; // 动画结束时执行逆动画
    
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:0.9]; // 结束时的倍率
    
    // 添加动画
    [view.layer addAnimation:animation forKey:@"scale-layer"];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self cancelClick:nil];
}

#pragma mark - PickerViewDataSource
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.genderArray.count;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.textColor = [UIColor blackColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont boldSystemFontOfSize:16];
    titleLable.text = self.genderArray[row];
    return titleLable;
}
#pragma mark - PickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    self.gender = [self.genderArray objectAtIndex:row];
    return [self.genderArray objectAtIndex:row];
}
@end
