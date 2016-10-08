//
//  INGProductDetailInfoViewController.m
//  MediaPlanet
//
//  Created by eric on 16/9/12.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGProductDetailInfoViewController.h"
#import "INGProductDetailInfoDataViewController.h"
#import "INGProductDetailCollectionViewCellOne.h"

@interface INGProductDetailInfoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) INGProductDetailInfoDataViewController* iNGProductDetailInfoDataViewController;
@end

@implementation INGProductDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.iNGProductDetailInfoDataViewController = [[INGProductDetailInfoDataViewController alloc]init];
    [self configureCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCollectionView
{
    [self.view addSubview:self.iNGProductDetailInfoDataViewController.collectionView];
    
    self.iNGProductDetailInfoDataViewController.collectionView.delegate = self;
    self.iNGProductDetailInfoDataViewController.collectionView.dataSource = self;
    
    self.iNGProductDetailInfoDataViewController.collectionView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self,64).bottomEqualToView(self.view);
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCollectionViewCell * cell;
    id object = nil;
    if (indexPath.section == 0)
    {
        INGProductDetailCollectionViewCellOne * firstCell = [INGProductDetailCollectionViewCellOne collectionView:collectionView forIndexPath:indexPath];
        object = @"";
        cell = firstCell;
    }
//    else if (indexPath.section == 1)
//    {
////        MyCommentSecondCollectionViewCell * secondCell = [MyCommentSecondCollectionViewCell collectionView:collectionView dequeueReusableCellWithReuseIdentifier:MyCommentSecondCollectionViewCellId forIndexPath:indexPath];
////        cell =secondCell;
//    }
//    else if (indexPath.section == 2)
//    {
////        MyCommentThirdCollectionViewCell * thirdCell = [MyCommentThirdCollectionViewCell collectionView:collectionView dequeueReusableCellWithReuseIdentifier:MyCommentThirdCollectionViewCellId forIndexPath:indexPath];
////        thirdCell.delegate = self;
////        object = self.image;
////        cell = thirdCell;
//    }
//    else
//    {
////        MyCommentFourCollectionViewCell * fourCell = [MyCommentFourCollectionViewCell collectionView:collectionView dequeueReusableCellWithReuseIdentifier:MyCommentFourCollectionViewCellId forIndexPath:indexPath];
////        fourCell.delegate = self;
////        cell = fourCell;
//    }
    
    [cell layoutWithObject:object];
    return cell;
}

#pragma mark - UICollectionViewFlowLayoutDelegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return CGSizeMake(screenW, screenW);
    }
    return CGSizeZero;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
