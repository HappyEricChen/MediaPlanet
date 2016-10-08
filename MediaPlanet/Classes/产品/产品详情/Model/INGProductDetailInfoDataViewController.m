//
//  INGProductDetailInfoDataViewController.m
//  MediaPlanet
//
//  Created by eric on 16/9/12.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGProductDetailInfoDataViewController.h"
#import "INGProductDetailCollectionViewCellOne.h"

@implementation INGProductDetailInfoDataViewController

-(UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[INGProductDetailCollectionViewCellOne class] forCellWithReuseIdentifier:DetailCollectionViewId];
    }
    return _collectionView;
}
@end
