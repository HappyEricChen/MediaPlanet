//
//  TypeSelectedView.m
//  MediaPlanet
//
//  Created by eric on 16/9/13.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "TypeSelectedView.h"

@interface TypeSelectedView()

@property (nonatomic, weak) UIButton* leftButton;

@property (nonatomic, weak) UIButton* rightButton;
@end
@implementation TypeSelectedView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView* baseView = [[UIView alloc]init];
        [self addSubview:baseView];
        
        UIView* bottomView = [[UIView alloc]init];
        bottomView.frame = CGRectMake(screenW*0.0937, 0, screenW*0.8125, screenH*0.042);
        [baseView addSubview:bottomView];
        bottomView.layer.cornerRadius = bottomView.frame.size.height*0.5;
        bottomView.layer.borderWidth = 1.0;
        bottomView.clipsToBounds = YES;
        bottomView.layer.borderColor = UIColorFromRGB(0x70b0ff).CGColor;
        
        
        
        UIButton* leftButton = [[UIButton alloc]init];
        [bottomView addSubview:leftButton];
        leftButton.frame = CGRectMake(0, 0, screenW*0.8125*0.5+10, screenH*0.042);
        leftButton.layer.cornerRadius = leftButton.frame.size.height*0.5;
        [leftButton setTitle:@"普通产品" forState:UIControlStateNormal];
        [leftButton setBackgroundImage:ImageNamed(@"product_pic1") forState:UIControlStateSelected];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [leftButton setTitleColor:UIColorFromRGB(0x70b0ff) forState:UIControlStateNormal];
        [leftButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
        leftButton.selected = YES;
        [leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setAdjustsImageWhenHighlighted:NO];
        self.leftButton = leftButton;
        
        
        UIButton* rightButton = [[UIButton alloc]init];
        [bottomView addSubview:rightButton];
        rightButton.frame = CGRectMake(screenW*0.8125*0.5, 0, screenW*0.8125*0.5+10 , screenH*0.042);
        rightButton.layer.cornerRadius = rightButton.frame.size.height*0.5;
        [rightButton setTitle:@"拼单产品" forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [rightButton setBackgroundImage:ImageNamed(@"product_pic1") forState:UIControlStateSelected];
        [rightButton setTitleColor:UIColorFromRGB(0x70b0ff) forState:UIControlStateNormal];
        [rightButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
        rightButton.selected = NO;
        [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
        self.rightButton = rightButton;
        
//        UISegmentedControl* segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"普通产品",@"拼单产品"]];
////        [segmentedControl setTintColor:UIColorFromRGB(0x70b0ff)];
//        segmentedControl.selectedSegmentIndex = 0;//初始指定第0个
////        segmentedControl.layer.cornerRadius = segmentedControl.bounds.size.height*0.4;
////        segmentedControl.clipsToBounds = YES;
////        segmentedControl.layer.borderWidth = 1;
////        segmentedControl.layer.borderColor = UIColorFromRGB(0x70b0ff).CGColor;
//        segmentedControl.tintColor = [UIColor clearColor];
//        [segmentedControl addTarget:self action:@selector(controlPressed:)
//                   forControlEvents:UIControlEventValueChanged];
//        NSDictionary* attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10],NSFontAttributeName, nil];
//        [segmentedControl setTitleTextAttributes:attributeDic forState:UIControlStateNormal];
//        
//        UIImage *segmentSelected = [ImageNamed(@"segmentedControl_er")
//                                    resizableImageWithCapInsets:UIEdgeInsetsMake(0, -30, 0, 15)];
//        UIImage *segmentUnSelected = [ImageNamed(@"segmented_er1")
//                                      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
//        
//        [segmentedControl setBackgroundImage:segmentUnSelected forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [segmentedControl setBackgroundImage:segmentSelected forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
//        
//        
//        [baseView addSubview:segmentedControl];
        
        baseView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(6, 0, 6, 0));
//        segmentedControl.sd_layout.leftSpaceToView(baseView,screenW*0.1).widthIs(screenW*0.8125).topSpaceToView(baseView,0).heightIs(screenH*0.042);
        
//        leftButton.sd_layout.leftEqualToView(bottomView).topEqualToView(bottomView).widthIs(bottomView.width*0.5).bottomEqualToView(bottomView);
        
    }
    return self;
}

-(void)clickLeftButton
{
    if (self.leftButton.isSelected && !self.rightButton.isSelected)
    {
        return;
    }
    else
    {
        self.leftButton.selected = YES;
        self.rightButton.selected = NO;
        if ([self.delegate respondsToSelector:@selector(didClickWashCarButtonWithTypeSelectedView:)])
        {
            [self.delegate didClickWashCarButtonWithTypeSelectedView:self];
        }
    }
}

-(void)clickRightButton
{
    if (self.rightButton.isSelected && !self.leftButton.isSelected)
    {
        return;
    }
    else
    {
        self.rightButton.selected = YES;
        self.leftButton.selected = NO;
        if ([self.delegate respondsToSelector:@selector(didClickMaintenanceButtonWithTypeSelectedView:)])
        {
            [self.delegate didClickMaintenanceButtonWithTypeSelectedView:self];
        }
        
    }
}

//-(void)controlPressed:(id)sender
//{
//    UISegmentedControl* control = (UISegmentedControl*)sender;
//    
//    NSInteger index = control.selectedSegmentIndex;
//    switch (index)
//    {
//        case 0:
//            
//            if ([self.delegate respondsToSelector:@selector(didClickWashCarButtonWithTypeSelectedView:)])
//            {
//                [self.delegate didClickWashCarButtonWithTypeSelectedView:self];
//            }
//            
//            break;
//        case 1:
//            
//            if ([self.delegate respondsToSelector:@selector(didClickMaintenanceButtonWithTypeSelectedView:)])
//            {
//                [self.delegate didClickMaintenanceButtonWithTypeSelectedView:self];
//            }
//            
//            break;
//            
//        default:
//            break;
//    }
//}

@end
