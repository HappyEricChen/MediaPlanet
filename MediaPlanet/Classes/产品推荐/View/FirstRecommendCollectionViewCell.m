//
//  FirstRecommendCollectionViewCell.m
//  MediaPlanet
//
//  Created by eric on 16/9/18.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "FirstRecommendCollectionViewCell.h"
#import "productList.h"
#import <UIImageView+WebCache.h>
#import "INGMapViewController.h"
#import "INGNavigationController.h"
#import "NSString+INGExtension.h"

@interface FirstRecommendCollectionViewCell()
//标题
@property (nonatomic, weak) UILabel* titleLabel;
//图片
@property (nonatomic, weak) UIImageView* photoImageView;
//广告商
@property (nonatomic, weak) UILabel* advertiserLabel;
//收藏按钮
@property (nonatomic, weak) UIButton* collectionButton;
//数据模型
@property (nonatomic, strong) productList* productModel;
//会员价
@property (nonatomic, weak) UILabel* priceLabel;
//文字"会员价"
@property (nonatomic, weak) UIImageView* priceImageView;
//官方刊例价
@property (nonatomic, weak) UILabel* oldPriceLabel;
//文字"官方刊例价"
@property (nonatomic, weak) UIImageView* priceView;
//”拼单产品“
@property (nonatomic, weak) UIImageView* spellImageView;
@end
@implementation FirstRecommendCollectionViewCell

NSString* const FirstRecommendCollectionViewCellId = @"FirstRecommendCollectionViewCellId";

+(FirstRecommendCollectionViewCell *)collectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
{
    FirstRecommendCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:FirstRecommendCollectionViewCellId forIndexPath:indexPath];
    return cell;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        /**
         图片
         */
        UIImageView* imageView = [[UIImageView alloc]init];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
        self.photoImageView = imageView;
        
        /**
         标题
         */
        UILabel* titleLabel = [[UILabel alloc]init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.numberOfLines = 1;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        /**
         收藏按钮
         */
        UIButton* collectionButton = [[UIButton alloc]init];
        [collectionButton setImage:ImageNamed(@"product_collection_none") forState:UIControlStateNormal];
        [collectionButton setImage:ImageNamed(@"product_collection") forState:UIControlStateSelected];
        [collectionButton addTarget:self action:@selector(clickSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:collectionButton];
        self.collectionButton = collectionButton;
        /**
         *  拼单产品
         */
        UIImageView* spellImageView = [[UIImageView alloc]initWithImage:ImageNamed(@"detail_pindan")];
        
        [titleLabel addSubview:spellImageView];
        self.spellImageView = spellImageView;
        /**
         *  广告商
         */
        UILabel* advertiserLabel = [[UILabel alloc]init];
        advertiserLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:advertiserLabel];
        advertiserLabel.numberOfLines = 1;
        self.advertiserLabel = advertiserLabel;
        
        /**
         会员价2.96万元
         */
        UILabel* priceLabel = [[UILabel alloc]init];
        priceLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:priceLabel];
        self.priceLabel = priceLabel;
        
        /**
         “会员价”
         */
        UIImageView* priceImageView = [[UIImageView alloc]initWithImage:ImageNamed(@"detail_vip")];
        [self.contentView addSubview:priceImageView];
        self.priceImageView = priceImageView;
        
        /**
         官方刊例价0.04万元
         */
        UILabel* oldPriceLabel = [[UILabel alloc]init];
        oldPriceLabel.font = [UIFont systemFontOfSize:12];
        [oldPriceLabel sizeToFit];
        [self.contentView addSubview:oldPriceLabel];
        self.oldPriceLabel = oldPriceLabel;
        
        /**
         “官方刊例价”文字
         */
        UIImageView* priceView = [[UIImageView alloc]initWithImage:ImageNamed(@"detail_guest")];
        [self.contentView addSubview:priceView];
        self.priceView = priceView;

        
        imageView.sd_layout.leftEqualToView(self.contentView).rightEqualToView(self.contentView).topSpaceToView(self.contentView,0).heightIs((screenW*0.9-10)*0.62);
        collectionButton.sd_layout.topEqualToView(imageView).rightSpaceToView(imageView,10).widthIs(29).heightIs(38);
        titleLabel.sd_layout.leftSpaceToView(self.contentView,10).topSpaceToView(imageView,5).rightSpaceToView(self.contentView,10).heightIs(screenH*0.03);
        spellImageView.sd_layout.leftEqualToView(titleLabel).topSpaceToView(titleLabel,0).widthIs(66).heightIs(16);
        advertiserLabel.sd_layout.leftSpaceToView(self.contentView,10).topSpaceToView(titleLabel,5).rightSpaceToView(self.contentView,10).heightIs(screenH*0.03);
        
    }
    return self;
}

-(void)layoutWithObject:(id)object
{
    
    if ([object isKindOfClass:[productList class]])
    {
        
        productList* productObject = (productList*)object;
        self.productModel = productObject;
        
        /**
         *  是否隐藏拼单产品
         */
        if (productObject.IsGroup == 1)
        {
            self.spellImageView.hidden = NO;
            /**
             *  加点空格，留个位置给“拼单产品”
             */
            NSString* spaceStr = @"                   ";
            self.titleLabel.text = [spaceStr stringByAppendingString:productObject.ProductName];
        }
        else
        {
            self.spellImageView.hidden = YES;
            
            self.titleLabel.text = productObject.ProductName;
        }
        
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:productObject.ProductPic] placeholderImage:ImageNamed(@"choice_pic1")];
        
        self.advertiserLabel.text = [NSString stringWithFormat:@"广告商：%@",productObject.AdvertiserName];
        
        /**
         *  价格处理，超过100元显示万元，小数点保留两位
         */
        NSString* tempStr = [self adjustPriceLabel:productObject.ProductPrice0];//会员价
        NSString* temStr1 = [self adjustPriceLabel:productObject.ProductPrice];//官方刊例价
        /**
         *  判断是否登录，登录才显示会员价
         */
        CGFloat priceImageWidth = 0;
        CGFloat memberPriceWidth = 0;
        
        CGFloat priceWidth1 = [self calculateWidthWithLabelContent:temStr1 WithFontName:nil WithFontSize:13 WithBold:NO];
        
        if ([NSString isMemberLogin])
        {
            priceImageWidth = screenW*0.122;
            memberPriceWidth = [self calculateWidthWithLabelContent:tempStr WithFontName:nil WithFontSize:13 WithBold:NO];
            self.priceImageView.hidden = NO;
            self.priceLabel.hidden = NO;
            self.oldPriceLabel.attributedText = [self addDeletedLines:temStr1];
            
            self.priceLabel.sd_layout.leftSpaceToView(self.contentView,10).topSpaceToView(self.advertiserLabel,5).widthIs(memberPriceWidth).autoHeightRatio(0);
            self.priceImageView.sd_layout.leftSpaceToView(self.priceLabel,5).centerYEqualToView(self.priceLabel).widthIs(priceImageWidth).heightIs(screenH*0.024);
            self.oldPriceLabel.sd_layout.leftSpaceToView(self.priceImageView,10).centerYEqualToView(self.priceImageView).widthIs(priceWidth1).autoHeightRatio(0);
            self.priceView.sd_layout.leftSpaceToView(self.oldPriceLabel,5).centerYEqualToView(self.priceImageView).widthIs(screenW*0.184).heightIs(screenH*0.023);
            
            
        }
        else
        {
            priceImageWidth = 0;
            memberPriceWidth = 0;
            self.priceImageView.hidden = YES;
            self.priceLabel.hidden = YES;
            self.oldPriceLabel.text = temStr1;
            
            self.oldPriceLabel.sd_layout.leftSpaceToView(self.contentView,10).topSpaceToView(self.advertiserLabel,5).widthIs(priceWidth1).autoHeightRatio(0);
            self.priceView.sd_layout.leftSpaceToView(self.oldPriceLabel,5).centerYEqualToView(self.oldPriceLabel).widthIs(screenW*0.184).heightIs(screenH*0.023);
            
        }
        
        self.priceLabel.text = tempStr;
        if (productObject.IsCol)
        {
            self.collectionButton.selected = YES;
        }
        else
        {
            self.collectionButton.selected = NO;
        }
        
    }
}

/**
 *  价格处理，超过100元显示万元，小数点保留两位
 */
- (NSString*)adjustPriceLabel:(CGFloat)price
{
    
    NSString* tempStr;
    if (price>100)
    {
        tempStr = [NSString stringWithFormat:@"%0.2f",price*0.0001];
        /**
         *  当小数点后面是00时，去掉小数点后面的数字
         */
        tempStr = [NSString stringWithFormat:@"%@万元",@(tempStr.floatValue)];
    }
    else
    {
        tempStr = [NSString stringWithFormat:@"%0.2f元",price];
    }
    return tempStr;
}


/** 点击跳转地图定位 */

- (void)mapButtonClick:(id)sender
{
    //    NSLog(@"%s",__func__);
    INGMapViewController *mapVC = [[INGMapViewController alloc]init];
    //    mapVC.infoModle = self.productModel;
    INGNavigationController *nav = [[INGNavigationController alloc]initWithRootViewController:mapVC];
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [root presentViewController:nav animated:YES completion:nil];;
}

/**
 *  点击收藏按钮
 */
-(void)clickSelectedButton:(UIButton*)sender
{
    if (![NSString isMemberLogin]) {
        [SVProgressHUD showInfoWithStatus:@"您还未登录，请先登录!"];
        return;
    }
    self.collectionButton.selected = !self.collectionButton.isSelected;
    NSMutableString *collUr = [NSMutableString string];
    [collUr appendString:apiUrl];
    [collUr appendString:@"products/collections"];
    [SVProgressHUD showWithStatus:@"请求中"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"product"] = _productModel.ProductNo;
    params[@"isdel"] = self.collectionButton.isSelected == NO ? @"true":@"false";
    params[@"key"] = key;
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    
    [params removeObjectForKey:@"key"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:collUr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            if (self.productModel.IsCol) {
                [SVProgressHUD showSuccessWithStatus:@"取消成功"];
            }else{
                
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            }
            self.productModel.IsCol = !self.productModel.IsCol;
        }else{
            [SVProgressHUD showErrorWithStatus:@"收藏失败"];
            self.collectionButton.selected = !self.collectionButton.isSelected;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"请求失败,请稍后重试!"];
        self.collectionButton.selected = !self.collectionButton.isSelected;
        
    }];
    
}

@end
