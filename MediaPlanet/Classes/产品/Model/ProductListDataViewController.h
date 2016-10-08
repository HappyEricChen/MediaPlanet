//
//  ProductListDataViewController.h
//  MediaPlanet
//
//  Created by eric on 16/9/13.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TypeSelectedView;

@interface ProductListDataViewController : NSObject

@property (nonatomic, strong) TypeSelectedView* typeSelectedView;

@property (nonatomic, strong) UITableView* customTableView;


@end
