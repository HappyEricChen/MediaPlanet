//
//  INGSearchField.m
//  媒体星球
//
//  Created by jamesczy on 16/5/31.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGSearchField.h"
#import <QuartzCore/QuartzCore.h>

@implementation INGSearchField

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 3.0;
        self.font = [UIFont systemFontOfSize:16];

        // 创建一个富文本对象
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        // 设置富文本对象的颜色
        attributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
        //设置占位文字和他的颜色
        self.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Search" attributes:attributes];
        
        self.tintColor = [UIColor whiteColor];
        UIImageView *searchIcon = [[UIImageView alloc]init];
        searchIcon.image = [UIImage imageNamed:@"Search"];
        searchIcon.width = 30;
        searchIcon.height = 30;
        searchIcon.contentMode = UIViewContentModeCenter;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView = searchIcon;
    }
    return self;
}

+(instancetype)searchField
{
    return [[self alloc]init];
}

@end
