//
//  FirstCollectionViewCell.m
//  MediaPlanet
//
//  Created by eric on 16/9/12.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "FirstCollectionViewCell.h"
#import "pCenterInfoModle.h"
#import <UIButton+WebCache.h>

@interface FirstCollectionViewCell()
/**
 *  背景图
 */
@property (nonatomic, weak) UIImageView* backImageView;
/**
 *  标题
 */
@property (nonatomic, weak) UILabel* titleLabel;

/**
 *  vip会员
 */
@property (nonatomic, weak) UIImageView* vipImageView;
/**
 *  头像
 */
@property (nonatomic, weak) UIButton* iconImageButton;
@end
@implementation FirstCollectionViewCell

NSString* const FirstCollectionViewCellId = @"FirstCollectionViewCellId";

+(FirstCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                                            forIndexPath:(NSIndexPath *)indexPath
{
    FirstCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:FirstCollectionViewCellId forIndexPath:indexPath];
    return cell;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        UIImageView* backImageView = [[UIImageView alloc]initWithImage:ImageNamed(@"personal_img_1")];
        backImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:backImageView];
        self.backImageView = backImageView;
        
        
        UIButton* iconImageButton = [[UIButton alloc]init];
        iconImageButton.layer.masksToBounds = YES;
        iconImageButton.layer.cornerRadius = screenW*0.256*0.5;//画圆
        iconImageButton.layer.borderColor = UIColorFromRGBWithAlpha(0xffffff, 0.3).CGColor;
        [iconImageButton addTarget:self action:@selector(didClickIconButton) forControlEvents:UIControlEventTouchUpInside];
        [iconImageButton setImage:ImageNamed(@"personal_img") forState:UIControlStateNormal];
        [backImageView addSubview:iconImageButton];
        self.iconImageButton = iconImageButton;
        
        UILabel* titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = UIColorFromRGB(0xffffff);
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIImageView* vipImageView = [[UIImageView alloc]initWithImage:ImageNamed(@"personal_vip")];
        [self.contentView addSubview:vipImageView];
        self.vipImageView.hidden = YES;
        self.vipImageView = vipImageView;
        
        backImageView.sd_layout.centerXEqualToView(self).centerYEqualToView(self).widthIs(screenW*0.283).heightIs(screenW*0.283);
        iconImageButton.sd_layout.centerXEqualToView(backImageView).centerYEqualToView(backImageView).widthIs(screenW*0.256).heightIs(screenW*0.256);
        
 
    }
    return self;
}

-(void)layoutWithObject:(id)object
{
    if ([object isKindOfClass:[pCenterInfoModle class]])
    {
        pCenterInfoModle* tempModel = (pCenterInfoModle*)object;
        
        /**
         *  头像
         */
        [self.iconImageButton sd_setImageWithURL:[NSURL URLWithString:tempModel.Headimg] forState:UIControlStateNormal placeholderImage:ImageNamed(@"personal_img")];
        
        /**
         *  判断是手机号码，中间四位加*号
         */
        if ([self isMobile:tempModel.MemberName])
        {
            NSString* tempStr = [tempModel.MemberName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            self.titleLabel.text = tempStr;
        }
        else
        {
            self.titleLabel.text = tempModel.MemberName;
        }
        
        CGFloat titleWidth = [self calculateWidthWithLabelContent:self.titleLabel.text WithFontName:nil WithFontSize:13 WithBold:NO];
        self.titleLabel.sd_layout.centerXEqualToView(self).topSpaceToView(self.backImageView,10).widthIs(titleWidth).autoHeightRatio(0);
        self.vipImageView.sd_layout.leftSpaceToView(self.titleLabel,5).centerYEqualToView(self.titleLabel).widthIs(screenW*0.04).heightIs(screenH*0.021);
        
        /**
         *  判断是否vip会员
         */
        if (tempModel.IsSign)
        {
            self.vipImageView.hidden = NO;
        }
        else
        {
            self.vipImageView.hidden = YES;
        }
        
    }
    
}

-(void)didClickIconButton
{
    if ([self.delegate respondsToSelector:@selector(didClickIconImageButton:)])
    {
        [self.delegate didClickIconImageButton:self];
    }
}

/**
 *  手机号码验证
 *
 *  @param mobileNumbel 传入的手机号码
 *
 *  @return 格式正确返回true  错误 返回fals
 */
- (BOOL) isMobile:(NSString *)mobileNumbel{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019]|7[0-9])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }
    
    return NO;
}
@end
