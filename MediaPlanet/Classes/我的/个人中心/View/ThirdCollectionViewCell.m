//
//  ThirdCollectionViewCell.m
//  MediaPlanet
//
//  Created by eric on 16/9/22.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "ThirdCollectionViewCell.h"

@implementation ThirdCollectionViewCell

NSString* const ThirdCollectionViewCellId = @"ThirdCollectionViewCellId";

+(ThirdCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                               forIndexPath:(NSIndexPath *)indexPath
{
    ThirdCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ThirdCollectionViewCellId forIndexPath:indexPath];
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
         *  联系我们
         */
        UIButton* contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
        contactButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [contactButton setImage:ImageNamed(@"personal_7") forState:UIControlStateNormal];
        [contactButton setTitle:@"联系我们" forState:UIControlStateNormal];
        [contactButton setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        contactButton.titleLabel.font = [UIFont systemFontOfSize:13];
        contactButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        contactButton.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [contactButton addTarget:self action:@selector(checkContactButton) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:contactButton];
        
        /**
         *  横线
         */
        UIImageView* lineView = [[UIImageView alloc]initWithImage:ImageNamed(@"personal_line")];
        [baseView addSubview:lineView];
        
        /**
         *  退出登录
         */
        UIButton* logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        logoutButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [logoutButton setImage:ImageNamed(@"personal_8") forState:UIControlStateNormal];
        [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [logoutButton setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        logoutButton.titleLabel.font = [UIFont systemFontOfSize:13];
        logoutButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        logoutButton.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [logoutButton addTarget:self action:@selector(checkLogoutButtonButton) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:logoutButton];
        
//        /**
//         *  横线
//         */
//        UIImageView* lineView1 = [[UIImageView alloc]initWithImage:ImageNamed(@"personal_line")];
//        [baseView addSubview:lineView];
        
        
        baseView.sd_layout.leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).topEqualToView(self.contentView).bottomEqualToView(self.contentView);
        
        contactButton.sd_layout.leftEqualToView(baseView).topEqualToView(baseView).rightEqualToView(baseView).heightIs(screenH*0.085-0.5);
        
        lineView.sd_layout.topSpaceToView(contactButton,0).centerXEqualToView(baseView).heightIs(0.5).widthIs(screenW*0.828);
        logoutButton.sd_layout.leftEqualToView(baseView).topEqualToView(lineView).rightEqualToView(baseView).heightIs(screenH*0.085);
//        lineView1.sd_layout.topSpaceToView(contactButton,0).centerXEqualToView(baseView).heightIs(0.5).widthIs(screenW*0.828);
        
    }
    return self;
}

/**
 *  点击联系我们
 */
-(void)checkContactButton
{
    if ([self.delegate respondsToSelector:@selector(didClickThirdContactUsButton:)])
    {
        [self.delegate didClickThirdContactUsButton:self];
    }
}
/**
 *  点击退出登录
 */
-(void)checkLogoutButtonButton
{
    if ([self.delegate respondsToSelector:@selector(didClickThirdLogoutButton:)])
    {
        [self.delegate didClickThirdLogoutButton:self];
    }
}
@end
