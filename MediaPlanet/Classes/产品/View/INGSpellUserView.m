//
//  INGSpellUserView.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/15.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGSpellUserView.h"
#import "menberHeaderView.h"
#import "menberList.h"
#import "productInfo.h"
#import <MJExtension.h>

@interface INGSpellUserView()
/** 拼单用户数组 */
@property (nonatomic, strong) NSMutableArray *menberListArray;


@end

@implementation INGSpellUserView

-(NSMutableArray *)menberListArray
{
    if (_menberListArray == nil) {
        _menberListArray = [NSMutableArray array];
    }
    return _menberListArray;
}

+(instancetype)spellUserShow
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}



-(void)setInfoModle:(productInfo *)infoModle
{
    _infoModle = infoModle;
    [self.menberListArray removeAllObjects];
    NSArray *array = [menberList mj_objectArrayWithKeyValuesArray:infoModle.MemberList];
    [self.menberListArray addObjectsFromArray:array];
    [self setSubView];
}

-(void)setSubView
{
    CGFloat btnW = 60;
    CGFloat btnH = 90;
    CGFloat btnMagin = (screenW - 4 * btnW) / 5;
    CGFloat btnY = 28;
//    CGFloat btnStartX = 20;
    NSInteger count = self.menberListArray.count;
//    self.height = btnY + (btnH + 5) * (count % 4 + 1);
    for (int i = 0; i < count; i++) {
        int rows = i / 4;
        int cols = i % 4;
        
        menberHeaderView *menberView = [menberHeaderView menberHeaderView];
        menberList *menberModle = self.menberListArray[i];
        menberView.tag = i;
        menberView.frame = CGRectMake(btnMagin + (btnW + btnMagin) * cols, btnY+(btnH + 5) * rows, btnW, btnH);
        menberView.modle = menberModle;
        [self addSubview:menberView];
    }
    
//    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    moreButton.frame = CGRectMake(screenW - btnW - btnMagin, btnY + (btnH + 5) * (count % 4), btnW, btnW);
//    [moreButton setBackgroundColor:[UIColor whiteColor]];
//    [moreButton setTitle:@"更多" forState:UIControlStateNormal];
//    [moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [moreButton.layer setCornerRadius:btnW * 0.5 ];
//    [moreButton.layer setMasksToBounds:YES];
//    [self addSubview:moreButton];
}
@end
