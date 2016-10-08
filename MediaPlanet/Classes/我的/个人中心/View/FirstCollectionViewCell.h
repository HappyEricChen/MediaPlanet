//
//  FirstCollectionViewCell.h
//  MediaPlanet
//
//  Created by eric on 16/9/12.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@class FirstCollectionViewCell;

@protocol FirstCollectionViewCellDelegate <NSObject>

@optional

-(void)didClickIconImageButton:(FirstCollectionViewCell*)firstCollectionViewCell;
@end
@interface FirstCollectionViewCell : BaseCollectionViewCell

/**
 *  重用id
 */
extern NSString* const FirstCollectionViewCellId;

+(FirstCollectionViewCell*)collectionView:(UICollectionView*)collectionView
                                           forIndexPath:(NSIndexPath*)indexPath;

@property (nonatomic, weak) id<FirstCollectionViewCellDelegate> delegate;


@end
