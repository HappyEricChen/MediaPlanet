//
//  INGSearchLineView.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/14.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGSearchLineView.h"

@implementation INGSearchLineView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.layer.borderColor = [UIColor whiteColor].CGColor;
//        self.layer.borderWidth = 1.0f;
//        self.layer.cornerRadius = 3.0;
        
        UITextField *textField = [[UITextField alloc]init];
        textField.x = 20;
        textField.y = 0;
        textField.width = screenW - 2 * 20;
        textField.height = 30;
        textField.font = [UIFont systemFontOfSize:16];
        
        [self addSubview:textField];
        
        UIImageView *comLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
        comLine.frame = CGRectMake(20, CGRectGetMaxY(textField.frame), screenW - 20, 1);
        [self addSubview:comLine];
        
        // 创建一个富文本对象
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        // 设置富文本对象的颜色
        attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
        //设置占位文字和他的颜色
        textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.Placeholder attributes:attributes];
        self.textField = textField;
        self.tintColor = [UIColor whiteColor];
        
    }
    return self;
}

+(instancetype)searchLine
{
    return [[self alloc]init];
}

@end
