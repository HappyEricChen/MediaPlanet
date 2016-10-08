//
//  INGCitiesCategoryHeaderView.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/7.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGCitiesCategoryHeaderView.h"

@interface INGCitiesCategoryHeaderView()

@property (nonatomic, weak) UILabel *titleLable;

@end

@implementation INGCitiesCategoryHeaderView

+(instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"header";
    INGCitiesCategoryHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[INGCitiesCategoryHeaderView alloc]initWithReuseIdentifier:ID];
//        header.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor lightGrayColor];
        //创建显示标题的lable
        UILabel *titleLable = [[UILabel alloc]init];
        titleLable.textColor = [UIColor clearColor];
        titleLable.width = 200;
        titleLable.x = 30;
        titleLable.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:titleLable];
        self.titleLable = titleLable;
    }
    return self;
}
-(void)setTitle:(NSString *)title
{
    _title = [title copy];
    self.titleLable.text = title;
}

@end
