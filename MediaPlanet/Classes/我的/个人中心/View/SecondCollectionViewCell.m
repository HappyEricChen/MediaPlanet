//
//  SecondCollectionViewCell.m
//  MediaPlanet
//
//  Created by eric on 16/9/13.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "SecondCollectionViewCell.h"

@implementation SecondCollectionViewCell

NSString* const SecondCollectionViewCellId = @"SecondCollectionViewCellId";

+(SecondCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                              forIndexPath:(NSIndexPath *)indexPath
{
    SecondCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SecondCollectionViewCellId forIndexPath:indexPath];
    return cell;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIView* baseView = [[UIView alloc]init];
        baseView.backgroundColor = [UIColor whiteColor];
        baseView.layer.cornerRadius = 5.0f;
        baseView.clipsToBounds = YES;
        [self.contentView addSubview:baseView];
        
        /**
         * 申请认证
         */
        UIButton* applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [applyButton setImage:ImageNamed(@"personal_1") forState:UIControlStateNormal];
        [applyButton setTitle:@"申请认证" forState:UIControlStateNormal];
        [applyButton setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        applyButton.titleLabel.font = [UIFont systemFontOfSize:13];
        applyButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [applyButton addTarget:self action:@selector(checkApplyButton) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:applyButton];
        
        /**
         *  分割虚线
         */
        UIImageView* dottedLine = [[UIImageView alloc]initWithImage:ImageNamed(@"personal_dotted")];
        [baseView addSubview:dottedLine];
        
        
        /**
         *  合同模板
         */
        UIButton* contractButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [contractButton setImage:ImageNamed(@"personal_2") forState:UIControlStateNormal];
        [contractButton setTitle:@"合同模板" forState:UIControlStateNormal];
        [contractButton setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        contractButton.titleLabel.font = [UIFont systemFontOfSize:13];
        contractButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [contractButton addTarget:self action:@selector(checkContractButton) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:contractButton];
        
        /**
         *  横线
         */
        UIImageView* lineView = [[UIImageView alloc]initWithImage:ImageNamed(@"personal_line")];
        [baseView addSubview:lineView];
        
        /**
         *  我的订单
         */
        UIButton* myOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [myOrderButton setImage:ImageNamed(@"personal_3") forState:UIControlStateNormal];
        [myOrderButton setTitle:@"我的订单" forState:UIControlStateNormal];
        [myOrderButton setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        myOrderButton.titleLabel.font = [UIFont systemFontOfSize:13];
        myOrderButton.titleEdgeInsets = UIEdgeInsetsMake(45, 0, 0, 40);
        myOrderButton.imageEdgeInsets = UIEdgeInsetsMake(-20, 50, 0, 0);
        [myOrderButton addTarget:self action:@selector(checkMyOrderButton) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:myOrderButton];
        
        /**
         *  我的收藏
         */
        UIButton* myCollectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [myCollectionButton setImage:ImageNamed(@"personal_4") forState:UIControlStateNormal];
        [myCollectionButton setTitle:@"我的收藏" forState:UIControlStateNormal];
        [myCollectionButton setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        myCollectionButton.titleLabel.font = [UIFont systemFontOfSize:13];
        myCollectionButton.titleEdgeInsets = UIEdgeInsetsMake(45, 0, 0, 40);
        myCollectionButton.imageEdgeInsets = UIEdgeInsetsMake(-20, 50, 0, 0);
        [myCollectionButton addTarget:self action:@selector(checkMyCollectionButton) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:myCollectionButton];
        
        /**
         *  横线
         */
        UIImageView* lineView1 = [[UIImageView alloc]initWithImage:ImageNamed(@"personal_line")];
        [baseView addSubview:lineView1];
        
        /**
         *  个人信息
         */
        UIButton* personalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [personalButton setImage:ImageNamed(@"personal_5") forState:UIControlStateNormal];
        [personalButton setTitle:@"个人信息" forState:UIControlStateNormal];
        [personalButton setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        personalButton.titleLabel.font = [UIFont systemFontOfSize:13];
        personalButton.titleEdgeInsets = UIEdgeInsetsMake(45, 0, 0, 40);
        personalButton.imageEdgeInsets = UIEdgeInsetsMake(-20, 50, 0, 0);
        [personalButton addTarget:self action:@selector(checkPersonalButton) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:personalButton];
        
        /**
         *  信息反馈
         */
        UIButton* messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [messageButton setImage:ImageNamed(@"personal_6") forState:UIControlStateNormal];
        [messageButton setTitle:@"信息反馈" forState:UIControlStateNormal];
        [messageButton setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        messageButton.titleLabel.font = [UIFont systemFontOfSize:13];
        messageButton.titleEdgeInsets = UIEdgeInsetsMake(45, 0, 0, 40);
        messageButton.imageEdgeInsets = UIEdgeInsetsMake(-20, 50, 0, 0);
        [messageButton addTarget:self action:@selector(checkMessageButton) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:messageButton];
        
        /**
         *  横线
         */
        UIImageView* lineView2 = [[UIImageView alloc]initWithImage:ImageNamed(@"personal_line")];
        [baseView addSubview:lineView2];
        
        /**
         *  竖线
         */
        UIImageView* lineView3 = [[UIImageView alloc]initWithImage:ImageNamed(@"personal_line")];
        [baseView addSubview:lineView3];
        
        
        
        baseView.sd_layout.leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).topEqualToView(self.contentView).bottomEqualToView(self.contentView);
        
        applyButton.sd_layout.leftEqualToView(baseView).topEqualToView(baseView).widthIs((screenW-20)*0.5-1.25).heightIs(screenH*0.085);
        
        dottedLine.sd_layout.leftSpaceToView(applyButton,0).heightIs(23).widthIs(2.5).centerYEqualToView(applyButton);
        
        contractButton.sd_layout.leftSpaceToView(dottedLine,0).topEqualToView(baseView).rightEqualToView(baseView).widthRatioToView(applyButton,1).heightRatioToView(applyButton,1);
        
        lineView.sd_layout.topSpaceToView(applyButton,0).centerXEqualToView(baseView).heightIs(0.5).widthIs(screenW*0.828);
        
        myOrderButton.sd_layout.leftEqualToView(baseView).topSpaceToView(lineView,0).widthIs((screenW-20)*0.5-1.25).heightIs(screenH*0.155);
         myCollectionButton.sd_layout.rightEqualToView(baseView).topSpaceToView(lineView,0).widthIs((screenW-20)*0.5-1.25).heightIs(screenH*0.155);
        
        lineView1.sd_layout.topSpaceToView(myOrderButton,0).centerXEqualToView(baseView).heightIs(0.5).widthIs(screenW*0.828);
        personalButton.sd_layout.leftEqualToView(baseView).topSpaceToView(lineView1,0).widthIs((screenW-20)*0.5-1.25).heightIs(screenH*0.155);
        messageButton.sd_layout.rightEqualToView(baseView).topSpaceToView(lineView1,0).widthIs((screenW-20)*0.5-1.25).heightIs(screenH*0.155);
        lineView2.sd_layout.topSpaceToView(personalButton,0).centerXEqualToView(baseView).heightIs(0.5).widthIs(screenW*0.828);
        //竖线
        lineView3.sd_layout.topSpaceToView(lineView,0).centerXEqualToView(baseView).bottomEqualToView(lineView2).widthIs(0.5);
    }
    return self;
}
/**
 *  我的订单
 */
-(void)checkMyOrderButton
{
    if ([self.delegate respondsToSelector:@selector(didClickMyOrderButton:)])
    {
        [self.delegate didClickMyOrderButton:self];
    }
}
/**
 *  我的收藏
 */
-(void)checkMyCollectionButton
{
    if ([self.delegate respondsToSelector:@selector(didClickMyCollectionButton:)])
    {
        [self.delegate didClickMyCollectionButton:self];
    }
}
/**
 *  申请认证
 */
-(void)checkApplyButton
{
    if ([self.delegate respondsToSelector:@selector(didClickCertificationButton:)])
    {
        [self.delegate didClickCertificationButton:self];
    }
}
/**
 *   点击合同模板
 */
-(void)checkContractButton
{
    if ([self.delegate respondsToSelector:@selector(didClickContractButton:)])
    {
        [self.delegate didClickContractButton:self];
    }
}
/**
 *  点击个人信息
 */
-(void)checkPersonalButton
{
    if ([self.delegate respondsToSelector:@selector(didClickPersonalInformationButton:)])
    {
        [self.delegate didClickPersonalInformationButton:self];
    }
}
/**
 *  点击信息反馈
 */
-(void)checkMessageButton
{
    if ([self.delegate respondsToSelector:@selector(didClickFeedbackButton:)])
    {
        [self.delegate didClickFeedbackButton:self];
    }
}
@end
