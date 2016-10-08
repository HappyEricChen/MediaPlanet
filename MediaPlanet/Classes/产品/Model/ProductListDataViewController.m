//
//  ProductListDataViewController.m
//  MediaPlanet
//
//  Created by eric on 16/9/13.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "ProductListDataViewController.h"
#import "TypeSelectedView.h"
#import "ProductListTableViewCell.h"

@implementation ProductListDataViewController

-(TypeSelectedView *)typeSelectedView
{
    if (!_typeSelectedView)
    {
        _typeSelectedView = [[TypeSelectedView alloc]init];
    }
    return _typeSelectedView;
}

-(UITableView *)customTableView
{
    if (!_customTableView)
    {
        _customTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _customTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _customTableView.showsVerticalScrollIndicator = NO;
        _customTableView.backgroundColor = UIColorFromRGB(0xeeeeee);
        [_customTableView registerClass:[ProductListTableViewCell class] forCellReuseIdentifier:ProductListTableViewCellId];
    }
    return _customTableView;
}

@end
