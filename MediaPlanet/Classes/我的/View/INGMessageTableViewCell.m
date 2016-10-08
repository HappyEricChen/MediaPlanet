//
//  INGMessageTableViewCell.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/13.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGMessageTableViewCell.h"
#import "listResultModle.h"

@interface INGMessageTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *messageLable;
@property (weak, nonatomic) IBOutlet UILabel *replyLable;
@end


@implementation INGMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.contentView.layer.borderWidth = 1.0f;
    [self.contentView.layer setMasksToBounds:YES];
    
    [self.replyButton setTitleColor:JCColor(88, 179, 227) forState:UIControlStateNormal];
    self.replyButton.layer.borderColor = JCColor(88, 179, 227).CGColor;
    self.replyButton.layer.borderWidth = 1.0f;
    [self.replyButton.layer setCornerRadius:5.0f];
    [self.replyButton.layer setMasksToBounds:YES];
    self.replyLable.textColor = JCColor(88, 179, 227);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setFrame:(CGRect)frame
{
    
    frame.origin.x = 10 ;
    frame.size.width -= 2 * 10  ;
    frame.size.height = self.height - 5;
    frame.origin.y += 5;
    
    [super setFrame:frame];
}

-(void)setResultModle:(listResultModle *)resultModle
{
    _resultModle = resultModle;
    self.timeLable.text = [NSString stringWithFormat:@"时间：%@",[resultModle.MessageTime substringToIndex:10]];
    self.messageLable.text = resultModle.MessageTxt;

    if ([resultModle.ReplyStateChar isEqualToString:@"未回复"])
    {
        self.replyLable.hidden = YES;
        self.replyButton.hidden = NO;
    }else{
        self.replyButton.hidden = YES;
        self.replyLable.hidden = NO;
        self.replyLable.text = resultModle.ReplyMessage;
        
    }
    
}
@end
