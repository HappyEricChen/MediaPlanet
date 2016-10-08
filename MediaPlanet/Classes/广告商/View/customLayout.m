//
//  customLayout.m
//  collectioncell
//
//  Created by jamesczy on 16/7/30.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  colletionView的自定义布局

#import "customLayout.h"

static CGFloat edgeMargin = 1;   // 边界的间距
static CGFloat padding = 1;      // 内部每个cell的间距
static NSInteger column = 4;      // 每页有多少列
static NSInteger row = 2;         // 每页有多少行

@interface customLayout()
/** 布局 */
@property (nonatomic, strong) NSMutableArray *layoutArray;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 总的item */
@property (nonatomic, assign) NSInteger totalCount;

@end

@implementation customLayout

-(NSMutableArray *)layoutArray
{
    if (_layoutArray == nil) {
        _layoutArray = [NSMutableArray array];
    }
    return _layoutArray;
}
-(NSInteger)totalCount
{
    return [self.collectionView numberOfItemsInSection:0];
}

-(NSInteger)page
{
    NSInteger numOfPage = column * row;
    _page = self.totalCount % numOfPage == 0 ? self.totalCount / numOfPage : self.totalCount / numOfPage + 1;
    return _page;
}
-(void)prepareLayout
{
    [super prepareLayout];
    [self.layoutArray removeAllObjects];
    NSIndexPath *indexPath;
    for (int index = 0; index < self.totalCount; index++) {
        indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.layoutArray addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

-(CGSize)collectionViewContentSize
{
    
    return CGSizeMake(screenW * self.page, 200);
//    return CGSizeMake(200, self.page * screenW);
}
/** 计算每一个item的位置 */
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSInteger numOfPage = column * row;
    NSInteger pageIndex = indexPath.row / numOfPage;
    // 当前cell 在当前页的哪一列，用来计算位置
    NSInteger columnInPage = indexPath.row % numOfPage % column;
    // 当前cell 在当前页的哪一行，用来计算位置
    NSInteger rowInPage = indexPath.row % numOfPage / column;
    
    CGFloat itemW = (screenW - edgeMargin * 2 - padding * (column - 1)) / column;
    CGFloat itemH = itemW + 20;


    CGFloat itemX = screenW * pageIndex + edgeMargin + columnInPage * (padding + itemW);
    CGFloat itemY = edgeMargin + (itemH + padding) * rowInPage;


    att.frame = CGRectMake(itemX, itemY, itemW, itemH);
    
    return att;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{

    return self.layoutArray;
}
@end
