//
//  NSObject+Helper.m
//  automaintain
//
//  Created by eric on 16/6/27.
//  Copyright © 2016年 eric. All rights reserved.
//  封装下划线，删除线，计算宽度，或者计算高度

#import "NSObject+Helper.h"

@implementation NSObject (Helper)

-(CGSize)calculateSizeWithLabelContent:(NSString *)labelContent
                          WithFontName:(NSString *)fontName
                          WithFontSize:(CGFloat)fontSize1
{
    UIFont* font = nil;
    if (fontName)
    {
        font = [UIFont fontWithName:fontName size:fontSize1];
    }
    else
    {
        font = [UIFont systemFontOfSize:fontSize1];
    }
    UILabel* label = [[UILabel alloc]init];
    label.text = labelContent;
    label.font = font;
    label.numberOfLines = 0;
    CGSize size = [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    return size;
}

-(CGFloat)calculateWidthWithLabelContent:(NSString *)labelContent
                           WithFontName:(NSString *)fontName
                           WithFontSize:(CGFloat)fontSize1
                                WithBold:(BOOL)isBold
{
    UIFont* font = nil;
    if (fontName)
    {
        font = [UIFont fontWithName:fontName size:fontSize1];
    }
    else
    {
        if (isBold)
        {
            font = [UIFont boldSystemFontOfSize:fontSize1];
        }
        else
        {
            font = [UIFont systemFontOfSize:fontSize1];
        }
        
    }
    UILabel* label = [[UILabel alloc]init];
    label.text = labelContent;
    label.font = font;
    CGSize size = [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    
    return size.width;
}
#pragma mark - 根据宽度计算高度
-(CGFloat)calculateHeighWithLabelContent:(NSString *)labelContent
                            WithFontName:(NSString *)fontName
                            WithFontSize:(CGFloat)fontSize1
                               WithWidth:(CGFloat)width
                                WithBold:(BOOL)isBold
{
    UIFont* font = nil;
    if (fontName)
    {
        font = [UIFont fontWithName:fontName size:fontSize1];
    }
    else
    {
        font = [UIFont systemFontOfSize:fontSize1];
    }
    UILabel* label = [[UILabel alloc]init];
    label.text = labelContent;
    label.font = font;
    label.numberOfLines = 0;
    
    CGRect tmpRect = [label.text boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    CGSize size = tmpRect.size;
    return size.height;
    
}

#pragma mark - 增加删除线
-(NSMutableAttributedString*)addDeletedLines:(NSString*)tempStr
{
    NSMutableAttributedString* attributeString = [[NSMutableAttributedString alloc]initWithString:tempStr];
    [attributeString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, tempStr.length)];
    
    return attributeString;
}
#pragma mark - 增加下划线
-(NSMutableAttributedString*)addUnderLines:(NSString*)tempStr
{
    if (tempStr == nil) {
        return nil;
    }
    NSMutableAttributedString* attributeString = [[NSMutableAttributedString alloc]initWithString:tempStr];
    [attributeString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, tempStr.length)];
    
    return attributeString;
}
@end
