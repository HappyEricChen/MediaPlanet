//
//  INGProductDetailCollectionViewCellOne.h
//  MediaPlanet
//
//  Created by eric on 16/9/12.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface INGProductDetailCollectionViewCellOne : BaseCollectionViewCell
/**
 *  重用id
 */
extern NSString* const DetailCollectionViewId;

+(INGProductDetailCollectionViewCellOne*)collectionView:(UICollectionView*)collectionView
                                           forIndexPath:(NSIndexPath*)indexPath;
@end
