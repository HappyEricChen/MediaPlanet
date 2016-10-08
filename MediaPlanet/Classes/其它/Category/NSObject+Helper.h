//
//  NSObject+Helper.h
//  automaintain
//
//  Created by eric on 16/6/27.
//  Copyright © 2016年 eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Helper)


/**
 *  根据文字的大小,数量计算宽度,返回size
 */
-(CGSize)calculateSizeWithLabelContent:(NSString*)labelContent WithFontName:(NSString*)fontName WithFontSize:(CGFloat)fontSize1;

/**
 *  根据文字的大小,数量计算宽度,返回width
 */
-(CGFloat)calculateWidthWithLabelContent:(NSString*)labelContent
                            WithFontName:(NSString*)fontName
                            WithFontSize:(CGFloat)fontSize1
                                WithBold:(BOOL)isBold;

/**
 *  根据label的内容和宽度,计算高度
 */
-(CGFloat)calculateHeighWithLabelContent:(NSString*)labelContent
                            WithFontName:(NSString*)fontName
                            WithFontSize:(CGFloat)fontSize1
                               WithWidth:(CGFloat)width
                                WithBold:(BOOL)isBold;

/**
 *   增加删除线
 */
-(NSMutableAttributedString*)addDeletedLines:(NSString*)tempStr;
/**
 *   增加下划线
 */
-(NSMutableAttributedString*)addUnderLines:(NSString*)tempStr;
@end
