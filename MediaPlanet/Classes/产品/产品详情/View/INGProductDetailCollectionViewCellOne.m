//
//  INGProductDetailCollectionViewCellOne.m
//  MediaPlanet
//
//  Created by eric on 16/9/12.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGProductDetailCollectionViewCellOne.h"
#import <SDCycleScrollView.h>

@interface INGProductDetailCollectionViewCellOne()<SDCycleScrollViewDelegate>
@property (nonatomic, weak) SDCycleScrollView* cycleScrollView;
@end
@implementation INGProductDetailCollectionViewCellOne

NSString* const DetailCollectionViewId = @"DetailCollectionViewId";

+(INGProductDetailCollectionViewCellOne *)collectionView:(UICollectionView *)collectionView
                                            forIndexPath:(NSIndexPath *)indexPath
{
    INGProductDetailCollectionViewCellOne * cell = [collectionView dequeueReusableCellWithReuseIdentifier:DetailCollectionViewId forIndexPath:indexPath];
    return cell;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        SDCycleScrollView* cycleScrollView = [[SDCycleScrollView alloc]initWithFrame:self.bounds];
        cycleScrollView.currentPageDotColor = [UIColor whiteColor];
        cycleScrollView.delegate = self;
        cycleScrollView.pageDotColor = [UIColor grayColor];
        [self addSubview:cycleScrollView];
        self.cycleScrollView = cycleScrollView;
    }
    return self;
}

-(void)layoutWithObject:(id)object
{
//    if ([object isKindOfClass:[NSArray class]])
//    {
//        NSArray* adsModelArr = (NSArray*)object;
//        NSMutableArray* imageArr = [NSMutableArray array];
//        /**
//         *  轮播图最多6张
//         */
//        for (NSInteger i=0; i<MIN(6, adsModelArr.count); i++)
//        {
//            AdsCarouselModel* adsCarousel  = adsModelArr[i];
//            
//            NSString* completeUrl = adsCarousel.PicUrl;
//            [imageArr addObject:completeUrl];
//        }
//        
//        [self.cycleScrollView setImageURLStringsGroup:imageArr];
//        
//    }
    /**
     *  设置轮播占位图
     */

    [self.cycleScrollView setPlaceholderImage:ImageNamed(@"product_detail_img0")];
}
#pragma mark - 点击轮播图调用
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
//    if ([self.delegate respondsToSelector:@selector(didSelectedImageWithFirstCollectionViewCell:withItemAtIndex:)])
//    {
//        [self.delegate didSelectedImageWithFirstCollectionViewCell:self withItemAtIndex:index];
//    }
}
@end
