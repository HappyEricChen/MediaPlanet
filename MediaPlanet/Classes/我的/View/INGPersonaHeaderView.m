//
//  INGPersonaHeaderView.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/2.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  persona页面的headerview

#import "INGPersonaHeaderView.h"
#import "pCenterInfoModle.h"
#import <UIImageView+WebCache.h>

@interface INGPersonaHeaderView ()


@property (weak, nonatomic) IBOutlet UIImageView *authView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
- (IBAction)headerButton:(id)sender;

@end
@implementation INGPersonaHeaderView

-(void)awakeFromNib
{
    [super awakeFromNib];
//    self.headerView.layer.cornerRadius = self.headerView.width * 0.5;
    [self.headerView.layer setMasksToBounds:YES];
    self.headerView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headerView.layer.borderWidth = 0;
    self.headerView.clipsToBounds = YES;
    self.nameLable.text = @"James";
    self.nameLable.textColor = [UIColor whiteColor];
    
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    INGPersonaHeaderView *viewHeader = [[[NSBundle mainBundle]loadNibNamed:@"INGPersonaHeaderView" owner:self options:nil]lastObject];
    
        if (frame.size.width != 0) {
        viewHeader.frame = frame;
        
    }
    return viewHeader;
}
-(void)setModle:(pCenterInfoModle *)modle
{
    _modle = modle;
    self.nameLable.text = modle.MemberName;
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:modle.Headimg] placeholderImage:[UIImage imageNamed:@"pic_img"]];
    if (![modle.Headimg isEqualToString:@""]) {
        
        [self.headerView.layer setMasksToBounds:YES];
//        self.headerView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.headerView.layer.borderWidth = 2;
        self.headerView.clipsToBounds = YES;
    }else{
        [self.headerView.layer setMasksToBounds:YES];
        self.headerView.layer.borderWidth = 0;
        self.headerView.clipsToBounds = YES;
    }
    self.authView.hidden = !modle.IsSign;
}

- (IBAction)headerButton:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(loadPersonHeaderView: )]) {
        [self.delegate loadPersonHeaderView:self];
    }
    
}
                                   

@end
