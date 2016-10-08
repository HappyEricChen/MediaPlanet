//
//  INGProducutBottomView.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/16.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGProducutBottomView.h"
#import "productInfo.h"
#import <UIImageView+WebCache.h>

@interface INGProducutBottomView()

@property (weak, nonatomic) IBOutlet UILabel *productInfoLable;

@end

@implementation INGProducutBottomView

+(instancetype)ProductBottom
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.width = screenW;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 0.8f;
    [self.layer setMasksToBounds:YES];
}
-(void)setFrame:(CGRect)frame
{
    frame.origin.x = 10 ;
    if (frame.size.width == screenW) {
        
        frame.size.width -= 2 * 10  ;
//        frame.size.height -= 10;
//        frame.origin.y += 10;
    }
    
    
    [super setFrame:frame];
}
-(void)setInfoModle:(productInfo *)infoModle
{
    _infoModle = infoModle;
    
    // 创建一个富文本对象
    NSMutableDictionary *attrDic = [NSMutableDictionary dictionary];
    // 设置富文本对象的颜色
    
    attrDic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attrDic[NSBackgroundColorAttributeName] = [UIColor clearColor];
    attrDic[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    
    NSAttributedString *attrStr =[[NSAttributedString alloc]initWithData:[infoModle.FullDescription dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:&attrDic error:nil];
    NSString *infoStr = [attrStr string];
    NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc]initWithString:infoStr attributes:attrDic];
    self.productInfoLable.attributedText = mutableStr;
    

    
}
@end
