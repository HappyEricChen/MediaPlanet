//
//  ProductListTableViewCell.h
//  MediaPlanet
//
//  Created by eric on 16/9/13.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductListTableViewCell;
@protocol ProductListTableViewCellDelegate <NSObject>

@optional
//点击地图定位跳转
-(void)didclickMapButton:(ProductListTableViewCell*)productListTableViewCell;
@end

@interface ProductListTableViewCell : UITableViewCell

/**
 *  重用id
 */
extern NSString* const ProductListTableViewCellId;
/**
 *  cell创建方法
 */
+(ProductListTableViewCell*)tableView:(UITableView*)tableView dequeueReusableCellWithReuseIdentifier:(NSString*)reuseIdentifier forIndexPath:(NSIndexPath*)indexPath;


-(void)layoutWithObject:(id)object;

@property (nonatomic, weak) id<ProductListTableViewCellDelegate> delegate;
@end
