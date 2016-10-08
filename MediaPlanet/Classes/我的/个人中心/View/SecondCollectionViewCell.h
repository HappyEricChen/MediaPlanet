//
//  SecondCollectionViewCell.h
//  MediaPlanet
//
//  Created by eric on 16/9/13.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@class SecondCollectionViewCell;
@protocol SecondCollectionViewCellDelegate <NSObject>

@optional
/**
 *  点击我的订单
 */
-(void)didClickMyOrderButton:(SecondCollectionViewCell*)secondCollectionViewCell;
/**
 *  点击我的收藏
 */
-(void)didClickMyCollectionButton:(SecondCollectionViewCell*)secondCollectionViewCell;

/**
 *  点击申请认证
 */
-(void)didClickCertificationButton:(SecondCollectionViewCell*)secondCollectionViewCell;
/**
 *  点击合同模板
 */
-(void)didClickContractButton:(SecondCollectionViewCell*)secondCollectionViewCell;
/**
 *  点击个人信息
 */
-(void)didClickPersonalInformationButton:(SecondCollectionViewCell*)secondCollectionViewCell;
/**
 *  点击信息反馈
 */
-(void)didClickFeedbackButton:(SecondCollectionViewCell*)secondCollectionViewCell;
@end

@interface SecondCollectionViewCell : BaseCollectionViewCell

/**
 *  重用id
 */
extern NSString* const SecondCollectionViewCellId;

+(SecondCollectionViewCell*)collectionView:(UICollectionView*)collectionView
                             forIndexPath:(NSIndexPath*)indexPath;

@property (nonatomic, weak) id <SecondCollectionViewCellDelegate> delegate;
@end
