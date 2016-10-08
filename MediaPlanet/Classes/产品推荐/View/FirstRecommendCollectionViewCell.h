//
//  FirstRecommendCollectionViewCell.h
//  MediaPlanet
//
//  Created by eric on 16/9/18.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@interface FirstRecommendCollectionViewCell : BaseCollectionViewCell

/**
 *  重用id
 */
extern NSString* const FirstRecommendCollectionViewCellId;
/**
 *  cell创建方法
 */
+(FirstRecommendCollectionViewCell*)collectionView:(UICollectionView*)collectionView
                                         forIndexPath:(NSIndexPath*)indexPath;


-(void)layoutWithObject:(id)object;

@end
