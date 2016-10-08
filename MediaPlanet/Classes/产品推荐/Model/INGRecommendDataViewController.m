//
//  INGRecommendDataViewController.m
//  MediaPlanet
//
//  Created by eric on 16/9/14.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGRecommendDataViewController.h"
#import "FirstRecommendCollectionViewCell.h"
#import "CountDownView.h"

@implementation INGRecommendDataViewController

-(UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(-64+10, 10, 0, 0);
        flowLayout.minimumLineSpacing = 10;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = NO;//禁止上下滑动
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[FirstRecommendCollectionViewCell class] forCellWithReuseIdentifier:FirstRecommendCollectionViewCellId];
        
    }
    return _collectionView;
}

-(CountDownView *)countDownView
{
    if (!_countDownView)
    {
        _countDownView = [[CountDownView alloc]init];
        
    }
    return _countDownView;
}

@end
