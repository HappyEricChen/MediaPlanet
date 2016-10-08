//
//  INGPersonalDataViewController.m
//  MediaPlanet
//
//  Created by eric on 16/9/12.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGPersonalDataViewController.h"
#import "FirstCollectionViewCell.h"
#import "SecondCollectionViewCell.h"
#import "ThirdCollectionViewCell.h"


@implementation INGPersonalDataViewController

-(UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundView = [[UIImageView alloc]initWithImage:ImageNamed(@"personal_bg")];
        
        [_collectionView registerClass:[FirstCollectionViewCell class] forCellWithReuseIdentifier:FirstCollectionViewCellId];
        [_collectionView registerClass:[SecondCollectionViewCell class] forCellWithReuseIdentifier:SecondCollectionViewCellId];
        [_collectionView registerClass:[ThirdCollectionViewCell class] forCellWithReuseIdentifier:ThirdCollectionViewCellId];
    }
    return _collectionView;
}

@end
