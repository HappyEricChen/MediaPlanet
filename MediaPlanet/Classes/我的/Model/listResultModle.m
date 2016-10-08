//
//  listResultModle.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/24.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "listResultModle.h"

@implementation listResultModle
-(CGFloat)cellHeight
{
    if (!_cellHeight) {
        CGSize maxSize = CGSizeMake(screenW - 40, MAXFLOAT);
        CGFloat MessageTimeH = [[NSString stringWithFormat:@"时间：%@",self.MessageTime]boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        
         CGFloat MessageTxtH = [[NSString stringWithFormat:@"%@",self.MessageTxt]boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        self.topHeight = MessageTimeH + MessageTxtH + 20;
//        NSLog(@"topViewH = %f",self.topHeight);
        if ([self.ReplyStateChar isEqualToString:@"未回复"]) {
            _cellHeight = self.topHeight + 40;
        }else{
            CGFloat ReplyMessageH = [[NSString stringWithFormat:@"%@",self.ReplyMessage]boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
            _cellHeight = self.topHeight + ReplyMessageH + 10;
        }
//        NSLog(@"_cellHeight = %f",_cellHeight);
    }
    return _cellHeight;
}
@end
