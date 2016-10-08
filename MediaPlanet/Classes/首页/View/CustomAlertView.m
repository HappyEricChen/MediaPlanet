//
//  CustomAlertView.m
//  CustomAlertView
//
//  Created by lanshang on 16/6/6.
//  Copyright © 2016年 luckyLin. All rights reserved.
//

#import "CustomAlertView.h"
#define ALERTVIEWWIDTH   260
@implementation CustomAlertView

-(instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title andDetail:(NSString *)detail andBody:(NSString *)body andCancelTitle:(NSString *)cancelTitel andOtherTitle:(NSString *)otherTitle
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithRed:25/255.0 green:32/255.0 blue:35/255.0 alpha:0.5];
        [self createUIWithTitle:title andDetail:detail andBody:body andCancelTitle:cancelTitel andOtherTitle:otherTitle];
    }
    return self;
}

-(void)createUIWithTitle:(NSString *)title andDetail:(NSString *)detail andBody:(NSString *)body andCancelTitle:(NSString *)cancelTitel andOtherTitle:(NSString *)otherTitle
{
    self.backGroundView = [[UIView alloc]init];
    self.backGroundView.center = self.center;
    self.backGroundView.backgroundColor = [UIColor colorWithRed:25/255.0 green:32/255.0 blue:35/255.0 alpha:1];
    self.backGroundView.layer.masksToBounds = YES;
    self.backGroundView.layer.cornerRadius = 5;
    self.backGroundView.layer.borderColor = [UIColor colorWithRed:16/255.0 green:106/255.0 blue:180/255.0 alpha:1].CGColor;;
    self.backGroundView.layer.borderWidth = 1;
    
    [self addSubview:self.backGroundView];
    

    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = title;
    CGFloat titleHeight = [self getHeightWithTitle:title andFont:14];
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.titleLabel.frame = CGRectMake(20, 20, ALERTVIEWWIDTH-20*2, titleHeight);
    self.titleLabel.numberOfLines = 0;
    [self.backGroundView addSubview:self.titleLabel];
    
    self.horImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tooltip_line"]];
    self.horImage.frame = CGRectMake(20,self.titleLabel.frame.origin.y + titleHeight + 5 , ALERTVIEWWIDTH-20*2, 1);
    [self.backGroundView addSubview:self.horImage];
    
    self.detailLabel = [[UILabel alloc]init];
    self.detailLabel.textColor = [UIColor blackColor];
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.text = detail;
    CGFloat detailHeight = [self getHeightWithTitle:detail andFont:13];
    self.detailLabel.font = [UIFont systemFontOfSize:13];
    self.detailLabel.frame = CGRectMake(20,20+self.titleLabel.frame.origin.y + titleHeight, ALERTVIEWWIDTH-20*2, detailHeight);
    self.detailLabel.tag = 306;
    self.detailLabel.userInteractionEnabled = YES;
    [self.backGroundView addSubview:self.detailLabel];
    
    
    self.bodyLabel = [[UILabel alloc]init];
    self.bodyLabel.textColor = [UIColor blackColor];
    self.bodyLabel.textAlignment = NSTextAlignmentCenter;
    self.bodyLabel.text = body;
    CGFloat bodyHeight = [self getHeightWithTitle:detail andFont:13];
    self.bodyLabel.font = [UIFont systemFontOfSize:13];
    self.bodyLabel.frame = CGRectMake(20, 10+self.detailLabel.frame.origin.y + detailHeight, ALERTVIEWWIDTH-20*2, bodyHeight);
    self.bodyLabel.numberOfLines = 0;
    self.bodyLabel.tag = 307;
    self.bodyLabel.userInteractionEnabled = YES;
    [self.backGroundView addSubview:self.bodyLabel];
    
    
    if (cancelTitel != nil) {
        
        self.verImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tooltip_line_h"]];
        self.verImage.frame = CGRectMake(ALERTVIEWWIDTH/2, self.bodyLabel.frame.origin.y + bodyHeight + 13, 1, 30);
        [self.backGroundView addSubview:self.verImage];
        
        self.canleButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        self.canleButton.frame = CGRectMake(0, self.verImage.frame.origin.y, ALERTVIEWWIDTH/2, 30);
        [self.canleButton setTitle:cancelTitel forState:UIControlStateNormal];
        //    self.canleButton.backgroundColor = [UIColor colorWithRed:25/255.0 green:106/255.0 blue:180/255.0 alpha:1];
        [self.canleButton.layer setMasksToBounds: YES];
        //    self.canleButton.layer.cornerRadius = 5;
        
        self.canleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.canleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.canleButton.tag = 308;
        [self.canleButton addTarget:self action:@selector(clickToUseDelegate:) forControlEvents:UIControlEventTouchUpInside];
        [self.backGroundView addSubview: self.canleButton];
        
        self.otherButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        self.otherButton.frame = CGRectMake(ALERTVIEWWIDTH/2, self.verImage.frame.origin.y, ALERTVIEWWIDTH/2, 30);
        [self.otherButton setTitle:otherTitle forState:UIControlStateNormal];
        self.otherButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //    self.otherButton.backgroundColor = [UIColor colorWithRed:25/255.0 green:106/255.0 blue:180/255.0 alpha:1];
        [self.otherButton.layer setMasksToBounds: YES];
        //    self.otherButton.layer.cornerRadius = 5;
        self.otherButton.tag = 309;
        [self.otherButton addTarget:self action:@selector(clickToUseDelegate:) forControlEvents:UIControlEventTouchUpInside];
        [self.backGroundView addSubview:self.otherButton];
    }else{
        self.otherButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        self.otherButton.frame = CGRectMake(20, CGRectGetMaxY(self.bodyLabel.frame) + 35, ALERTVIEWWIDTH - 40, 30);
        [self.otherButton setTitle:otherTitle forState:UIControlStateNormal];
        self.otherButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.otherButton.backgroundColor = [UIColor colorWithRed:25/255.0 green:106/255.0 blue:180/255.0 alpha:1];
        [self.otherButton.layer setMasksToBounds: YES];
        self.otherButton.layer.cornerRadius = 5;
        self.otherButton.tag = 309;
        [self.otherButton addTarget:self action:@selector(clickToUseDelegate:) forControlEvents:UIControlEventTouchUpInside];
        [self.backGroundView addSubview:self.otherButton];
    }

    
    self.backGroundView.bounds = CGRectMake(0, 0, ALERTVIEWWIDTH,120+ titleHeight + detailHeight + bodyHeight);
    UITapGestureRecognizer *tapDetailLab = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toDoSomething:)];
    [self.detailLabel addGestureRecognizer:tapDetailLab];
    UITapGestureRecognizer *tapBodyLab = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toDoSomething:)];
    [self.bodyLabel addGestureRecognizer:tapBodyLab];
    
    [self shakeToShow:self.backGroundView];
    
   }

//动态计算高度
-(CGFloat)getHeightWithTitle:(NSString *)title andFont:(NSInteger)fontsize
{
    CGFloat height = [title boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]} context:nil].size.height;
    return height;
}

//显示提示框的动画
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

//点击(取消,确定)按钮调用方法
-(void)clickToUseDelegate:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(clickButtonWithTag:)])
    {
        [self.delegate clickButtonWithTag:button];
    }
    
     [self removeFromSuperview];
}

-(void)toDoSomething:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(clickLabelWithTag:)])
    {
        [self.delegate clickLabelWithTag:tap.self.view];
    }

    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
