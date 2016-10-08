//
//  ProductListTableViewCell.m
//  MediaPlanet
//
//  Created by eric on 16/9/13.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "ProductListTableViewCell.h"
#import "productList.h"
#import <UIImageView+WebCache.h>

@interface ProductListTableViewCell()
//标题
@property (nonatomic, weak) UILabel* titleLabel;
//图片
@property (nonatomic, weak) UIImageView* photoImageView;
//广告商
@property (nonatomic, weak) UILabel* advertiserLabel;
//地址按钮
@property (nonatomic, weak) UIButton* addressButton;
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
/**
 *  垫底的View
 */
@property (nonatomic, weak) UIView* baseView;
@end
@implementation ProductListTableViewCell

NSString* const ProductListTableViewCellId = @"ProductListTableViewCellId";

+(ProductListTableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithReuseIdentifier:(NSString *)reuseIdentifier forIndexPath:(NSIndexPath *)indexPath
{
    ProductListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
    {
        cell = [[ProductListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消cell选中效果
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = UIColorFromRGB(0xeeeeee);
        
        UIView* baseView = [[UIView alloc]init];
        [self.contentView addSubview:baseView];
        baseView.backgroundColor = [UIColor whiteColor];
        self.baseView = baseView;
        /**
         图片
         */
        UIImageView* imageView = [[UIImageView alloc]init];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [baseView addSubview:imageView];
        self.photoImageView = imageView;

        /**
         标题
         */
        UILabel* titleLabel = [[UILabel alloc]init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.numberOfLines = 2;
        [baseView addSubview:titleLabel];
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
        advertiserLabel.font = [UIFont systemFontOfSize:13];
        [baseView addSubview:advertiserLabel];
        self.advertiserLabel = advertiserLabel;
        
        /**
         会员价2.96万元
         */
        UILabel* priceLabel = [[UILabel alloc]init];
         priceLabel.text = @"200.00万元";
        priceLabel.font = [UIFont systemFontOfSize:13];
        [priceLabel sizeToFit];
        [baseView addSubview:priceLabel];
        self.priceLabel = priceLabel;
        
        /**
         “会员价”
         */
        UIImageView* priceImageView = [[UIImageView alloc]initWithImage:ImageNamed(@"detail_vip")];
        [baseView addSubview:priceImageView];
        self.priceImageView = priceImageView;
        
        /**
         “原价”
         */
        UILabel* oldPriceLabel = [[UILabel alloc]init];
        oldPriceLabel.font = [UIFont systemFontOfSize:13];
        [oldPriceLabel sizeToFit];
        [baseView addSubview:oldPriceLabel];
        self.oldPriceLabel = oldPriceLabel;
        
        /**
         “官方刊例价”
         */
        UIImageView* priceView = [[UIImageView alloc]initWithImage:ImageNamed(@"detail_guest")];
        [baseView addSubview:priceView];
        self.priceView = priceView;
        
        /**
         *  地址
         */
        UIButton*  addressButton = [[UIButton alloc]init];
        
        /**
         地址加下划线
         */
        [addressButton setImage:ImageNamed(@"product_address") forState:UIControlStateNormal];
        [addressButton setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        addressButton.titleLabel.font = FONT_HannotateSC(13);
        addressButton.clipsToBounds = YES;
        addressButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        addressButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [baseView addSubview:addressButton];
        self.addressButton = addressButton;
        [addressButton addTarget:self action:@selector(mapButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        baseView.sd_layout.leftSpaceToView(self.contentView,10).topEqualToView(self.contentView).rightSpaceToView(self.contentView,10).bottomEqualToView(self.contentView);
        
        imageView.sd_layout.leftEqualToView(baseView).rightEqualToView(baseView).topSpaceToView(baseView,0).heightIs((screenW-20)*0.62);
        collectionButton.sd_layout.topEqualToView(imageView).rightSpaceToView(imageView,10).widthIs(29).heightIs(38);
        titleLabel.sd_layout.leftSpaceToView(baseView,10).topSpaceToView(imageView,10).rightSpaceToView(baseView,10).autoHeightRatio(0);
        spellImageView.sd_layout.leftEqualToView(titleLabel).topSpaceToView(titleLabel,0).widthIs(66).heightIs(16);
        advertiserLabel.sd_layout.leftSpaceToView(baseView,10).topSpaceToView(titleLabel,10).rightSpaceToView(baseView,10).autoHeightRatio(0);
        
    }
    return self;
}

-(void)layoutWithObject:(id)object
{
    
    if ([object isKindOfClass:[productList class]])
    {
        
        productList* productObject = (productList*)object;
        self.productModel = productObject;
        
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:productObject.ProductPic] placeholderImage:ImageNamed(@"product_img")];
        
        self.advertiserLabel.text = [NSString stringWithFormat:@"广告商：%@",productObject.AdvertiserName];
        [self.addressButton setAttributedTitle:[self addUnderLines:productObject.ProductLoc] forState:UIControlStateNormal];
        
        //是否隐藏地址栏
        if ([productObject.ProductLoc isEqualToString:@""] || !productObject.ProductLoc)
        {
            self.addressButton.hidden = YES;
        }
        else
        {
            self.addressButton.hidden = NO;
        }
        
        
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
            
            self.priceLabel.sd_layout.leftSpaceToView(self.baseView,10).topSpaceToView(self.advertiserLabel,10).widthIs(memberPriceWidth).autoHeightRatio(0);
            self.priceImageView.sd_layout.leftSpaceToView(self.priceLabel,10).centerYEqualToView(self.priceLabel).widthIs(priceImageWidth).heightIs(screenH*0.024);
            self.oldPriceLabel.sd_layout.leftSpaceToView(self.priceImageView,10).centerYEqualToView(self.priceImageView).widthIs(priceWidth1).autoHeightRatio(0);
            self.priceView.sd_layout.leftSpaceToView(self.oldPriceLabel,10).centerYEqualToView(self.priceImageView).widthIs(screenW*0.184).heightIs(screenH*0.023);
            
        }
        else
        {
            priceImageWidth = 0;
            memberPriceWidth = 0;
            self.priceImageView.hidden = YES;
            self.priceLabel.hidden = YES;
            self.oldPriceLabel.text = temStr1;
            
            self.oldPriceLabel.sd_layout.leftSpaceToView(self.baseView,10).topSpaceToView(self.advertiserLabel,10).widthIs(priceWidth1).autoHeightRatio(0);
            self.priceView.sd_layout.leftSpaceToView(self.oldPriceLabel,10).centerYEqualToView(self.oldPriceLabel).widthIs(screenW*0.184).heightIs(screenH*0.023);
            
        }
        
        self.addressButton.sd_layout.leftSpaceToView(self.baseView,10).rightSpaceToView(self.baseView,10).topSpaceToView(self.oldPriceLabel,10).heightIs(30);
        
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
    if ([self.delegate respondsToSelector:@selector(didclickMapButton:)])
    {
        [self.delegate didclickMapButton:self];
    }
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
