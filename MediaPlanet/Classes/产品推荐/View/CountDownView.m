//
//  CountDownView.m
//  MediaPlanet
//
//  Created by eric on 16/9/19.
//  Copyright © 2016年 jamesczy. All rights reserved.
// 限时抢购

#import "CountDownView.h"
#import "FlashModel.h"
#import <UIImageView+WebCache.h>
#import "CircleView.h"
@interface CountDownView()

@property (nonatomic, weak) UIView* baseView;
/**
 *  时
 */
@property (nonatomic, weak) UILabel* hourLabel;
@property (nonatomic, weak) UIImageView* hourImageview;
/**
 *  分
 */
@property (nonatomic, weak) UILabel* minutesLabel;
/**
 *  秒
 */
@property (nonatomic, weak) UILabel* secondsLabel;
/**
 *  会员价
 */
@property (nonatomic, weak) UILabel* priceLabel;
/**
 *  官方刊例价
 */
@property (nonatomic, weak) UILabel* oldPriceLabel;
/**
 *  图片
 */
@property (nonatomic, weak) UIImageView* imageView;
/**
 *  图片底框
 */
@property (nonatomic, weak) UIImageView* baseImageView;
/**
 *  进度条
 */
@property (nonatomic, weak) UIView* progressView;
/**
 *  进度值
 */
@property (nonatomic, weak) UILabel* progressLabel;

@property (nonatomic, weak) CAShapeLayer* shapeLayer;
@end
@implementation CountDownView

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView* baseView = [[UIView alloc]init];
        [self addSubview:baseView];
        self.baseView = baseView;
        /**
         限时抢购
         */
        UIImageView* limitImageView = [[UIImageView alloc]initWithImage:ImageNamed(@"choice_bg2")];
        [baseView addSubview:limitImageView];
        
        /**
         距离结束时间
         */
        UILabel* label2 = [[UILabel alloc]init];
        label2.text = @"距离结束时间：";
        label2.textColor = UIColorFromRGB(0x315cab);
        label2.font = [UIFont systemFontOfSize:12];
        [baseView addSubview:label2];
        
        /**
         倒计时Label 10：22：25
         */
        //时
        UIImageView* hourImageview = [[UIImageView alloc]initWithImage:ImageNamed(@"choice_time")];
        [baseView addSubview:hourImageview];
        self.hourImageview = hourImageview;
        
        UILabel* hourLabel = [[UILabel alloc]init];
        hourLabel.textColor = [UIColor whiteColor];
        hourLabel.font = [UIFont systemFontOfSize:12];
        hourLabel.textAlignment = NSTextAlignmentCenter;
        [hourImageview addSubview:hourLabel];
        self.hourLabel = hourLabel;
        /**
         冒号:
         */
        UILabel* colonLabel1 = [[UILabel alloc]init];
        colonLabel1.text = @":";
        colonLabel1.textAlignment = NSTextAlignmentCenter;
        colonLabel1.font = [UIFont systemFontOfSize:12];
        [baseView addSubview:colonLabel1];
        //分
        UIImageView* minutesImageview = [[UIImageView alloc]initWithImage:ImageNamed(@"choice_time")];
        [baseView addSubview:minutesImageview];
        
        UILabel* minutesLabel = [[UILabel alloc]init];
        minutesLabel.textColor = [UIColor whiteColor];
        minutesLabel.textAlignment = NSTextAlignmentCenter;
        minutesLabel.font = [UIFont systemFontOfSize:12];
        [minutesImageview addSubview:minutesLabel];
        self.minutesLabel = minutesLabel;
        /**
         冒号:
         */
        UILabel* colonLabel2 = [[UILabel alloc]init];
        colonLabel2.text = @":";
        colonLabel2.textAlignment = NSTextAlignmentCenter;
        colonLabel2.font = [UIFont systemFontOfSize:12];
        [baseView addSubview:colonLabel2];
        //秒
        UIImageView* secondsImageview = [[UIImageView alloc]initWithImage:ImageNamed(@"choice_time")];
        [baseView addSubview:secondsImageview];
        
        UILabel* secondsLabel = [[UILabel alloc]init];
        secondsLabel.textColor = [UIColor whiteColor];
        secondsLabel.textAlignment = NSTextAlignmentCenter;
        secondsLabel.font = [UIFont systemFontOfSize:12];
        [secondsImageview addSubview:secondsLabel];
        self.secondsLabel = secondsLabel;
        
        /**
         会员价
         */
        UILabel* priceLabel = [[UILabel alloc]init];
        priceLabel.font = [UIFont systemFontOfSize:11];
        [baseView addSubview:priceLabel];
        self.priceLabel = priceLabel;
        
        /**
         官方刊例价
         */
        UILabel* oldPriceLabel = [[UILabel alloc]init];
        oldPriceLabel.font = [UIFont systemFontOfSize:10];
        oldPriceLabel.textColor = [UIColor grayColor];
        [baseView addSubview:oldPriceLabel];
        self.oldPriceLabel = oldPriceLabel;
        
        /**
         图片底框
         */
        UIImageView* baseImageView = [[UIImageView alloc]initWithImage:ImageNamed(@"choice_bg")];
        [self addSubview:baseImageView];
        self.baseImageView = baseImageView;
        /**
         图片
         */
        UIImageView* imageView = [[UIImageView alloc]initWithImage:ImageNamed(@"product_img")];
        [baseImageView addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFit;//图片留白
        self.imageView = imageView;
        /**
         *  “拼单”文字图片
         */
        UIImageView* spellImageView = [[UIImageView alloc]initWithImage:ImageNamed(@"choice_pin")];
        [baseImageView addSubview:spellImageView];
        
        /**
         *  圆形进度条
         */
        UIView* progressView = [[UIView alloc]init];
        [baseView addSubview:progressView];
        self.progressView = progressView;
        /**
         进度比例6/10
         */
        UILabel* progressLabel = [[UILabel alloc]init];
        progressLabel.font = [UIFont systemFontOfSize:12];
        progressLabel.textAlignment = NSTextAlignmentCenter;
        progressLabel.textColor = UIColorFromRGB(0xb5b5b5);
        self.progressLabel = progressLabel;
        [progressView addSubview:self.progressLabel];

        
        baseView.sd_layout.leftSpaceToView(self,10).topSpaceToView(self,20).bottomSpaceToView(self,0).widthIs(screenW*0.3);
        
        limitImageView.sd_layout.leftEqualToView(baseView).topSpaceToView(baseView,0).widthIs(screenW*0.275).heightIs(screenH*0.056);
        label2.sd_layout.leftEqualToView(baseView).topSpaceToView(limitImageView,10).rightSpaceToView(baseView,10).autoHeightRatio(0);
        hourImageview.sd_layout.leftEqualToView(baseView).topSpaceToView(label2,10).widthIs(25).heightIs(25);
        hourLabel.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        colonLabel1.sd_layout.leftSpaceToView(hourImageview,1).topEqualToView(hourImageview).widthIs(10).bottomEqualToView(hourImageview);
        minutesImageview.sd_layout.leftSpaceToView(colonLabel1,1).topEqualToView(hourImageview).widthIs(25).bottomEqualToView(hourImageview);
        minutesLabel.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        colonLabel2.sd_layout.leftSpaceToView(minutesImageview,1).topEqualToView(hourImageview).widthIs(10).bottomEqualToView(hourImageview);
        secondsImageview.sd_layout.leftSpaceToView(colonLabel2,1).topEqualToView(hourImageview).widthIs(25).bottomEqualToView(hourImageview);
        secondsLabel.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        
        baseImageView.sd_layout.leftSpaceToView(baseView,10).topEqualToView(baseView).widthIs(screenW*0.572).heightIs(screenH*0.327);
        imageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(12.5, 12.5, 12.5, 12.5));
        spellImageView.sd_layout.leftSpaceToView(baseImageView,10).topSpaceToView(baseImageView,10).widthIs(screenW*0.137).heightIs(screenH*0.056);
        
    }
    return self;
}

-(void)layoutCountDown:(NSInteger)countDown
{
    self.hourLabel.text = [NSString stringWithFormat:@"%02ld",(long)countDown/3600];
    
    self.minutesLabel.text = [NSString stringWithFormat:@"%02ld",(long)countDown%3600/60];
    
    self.secondsLabel.text = [NSString stringWithFormat:@"%02ld",(long)countDown%60];
}

-(void)layoutWithObject:(id)object
{
    FlashModel* flashModel = (FlashModel*)object;
    
    /**
     *  价格处理，超过100元显示万元，小数点保留两位
     */
    NSString* tempStr = [self adjustPriceLabel:flashModel.ProductPrice0];//会员价
    NSString* temStr1 = [self adjustPriceLabel:flashModel.ProductPrice];//官方刊例价
    
    CGFloat priceWidth = [self calculateWidthWithLabelContent:tempStr WithFontName:nil WithFontSize:11 WithBold:NO];
    CGFloat priceWidth1 = [self calculateWidthWithLabelContent:temStr1 WithFontName:nil WithFontSize:10 WithBold:NO];
    
    self.priceLabel.sd_layout.leftEqualToView(self.baseView).topSpaceToView(self.hourImageview,10).widthIs(priceWidth).autoHeightRatio(0);
    self.oldPriceLabel.sd_layout.leftSpaceToView(self.priceLabel,5).centerYEqualToView(self.priceLabel).widthIs(priceWidth1).autoHeightRatio(0);
    
    self.priceLabel.text = tempStr;
    self.oldPriceLabel.attributedText = [self addDeletedLines:temStr1];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:flashModel.ProductPic] placeholderImage:ImageNamed(@"choice_pic")];
    
    self.progressView.sd_layout.centerXEqualToView(self.baseView).topSpaceToView(self.priceLabel,5).widthIs(screenW*0.24).heightEqualToWidth();
    
    self.progressLabel.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    /**
     *  添加进度条
     */
    CGFloat progressValue = (CGFloat)(flashModel.OrderUserCount)/flashModel.MaxUserCount;
    [self loadProgressViewWithProgressValue:progressValue];
    /**
     *  进度比值6/10
     */
    self.progressLabel.text = [NSString stringWithFormat:@"%d/%d",(flashModel.OrderUserCount),flashModel.MaxUserCount];
    
}

-(void)loadProgressViewWithProgressValue:(CGFloat)progressValue
{
    
    CircleView *view = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, screenW*0.24, screenW*0.24)];
    [self.progressView addSubview:view];
    view.center = self.progressView.center;
    [view setLineWidth:6.f];
    [view setLineColr:[UIColor blueColor]];
    view.startValue = 0;
    view.value = progressValue;
    
    view.inputColor0 = [UIColor redColor];
    view.inputColor1 = [UIColor greenColor];
    
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
        tempStr = [NSString stringWithFormat:@"￥%@万元",@(tempStr.floatValue)];
    }
    else
    {
        tempStr = [NSString stringWithFormat:@"￥%0.2f元",price];
    }
    return tempStr;
}
@end
