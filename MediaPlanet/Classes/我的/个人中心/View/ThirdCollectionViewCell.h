//
//  ThirdCollectionViewCell.h
//  MediaPlanet
//
//  Created by eric on 16/9/22.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@class ThirdCollectionViewCell;
@protocol ThirdCollectionViewCellDelegate <NSObject>

@optional
/**
 *  点击联系我们
 */
-(void)didClickThirdContactUsButton:(ThirdCollectionViewCell*)thirdCollectionViewCell;
/**
 *  点击退出登录
 */
-(void)didClickThirdLogoutButton:(ThirdCollectionViewCell*)thirdCollectionViewCell;
@end
@interface ThirdCollectionViewCell : BaseCollectionViewCell


/**
 *  重用id
 */
extern NSString* const ThirdCollectionViewCellId;

+(ThirdCollectionViewCell*)collectionView:(UICollectionView*)collectionView
                              forIndexPath:(NSIndexPath*)indexPath;

@property (nonatomic, weak) id <ThirdCollectionViewCellDelegate> delegate;
@end
