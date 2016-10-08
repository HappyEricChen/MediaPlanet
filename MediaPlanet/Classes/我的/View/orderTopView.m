//
//  orderTopView.m
//  MediaPlanet
//
//  Created by jamesczy on 16/8/1.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "orderTopView.h"
#import "oderInfomation.h"

@interface orderTopView()
@property (weak, nonatomic) IBOutlet UILabel *linkNameLable;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLable;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;

@end

@implementation orderTopView

+(instancetype)topInfo
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.width = screenW - 20;
    
}
-(void)setOderModle:(oderInfomation *)oderModle
{
    _oderModle = oderModle;
    
    self.linkNameLable.text = [NSString stringWithFormat:@"联系人：%@", oderModle.Contact];
    self.phoneNumLable.text = [NSString stringWithFormat:@"联系电话：%@",oderModle.ContactTel];
    self.addressLable.text = oderModle.ContactAddress;
}
@end
