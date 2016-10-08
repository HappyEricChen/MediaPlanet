//
//  INGOderInfoView.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/15.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGOderInfoView.h"
#import "productInfo.h"
#import "checkOrder.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>

@interface INGOderInfoView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *isGroupShowBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *orderCountView;

@end

static NSInteger const nameMaxLength = 15;
static NSInteger const phoneMaxLength = 11;
static NSInteger const addressMaxLength = 150;

@implementation INGOderInfoView

+(instancetype)oderInfo
{
    return [[NSBundle mainBundle]loadNibNamed:@"INGOderInfoView" owner:nil options:nil].lastObject;
    
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.frame = [UIScreen mainScreen].bounds;
    
    [self.productIcon.layer setCornerRadius:self.productIcon.width * 0.5];
    [self.productIcon.layer setMasksToBounds:YES];
    
    
    //设置button的下划线
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc]initWithString:@"下单须知"];
    NSRange titleRange= {0,[title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    NSMutableDictionary *attribusDict = [NSMutableDictionary dictionary];
    attribusDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attribusDict[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    [title addAttributes:attribusDict range:titleRange];
    [self.oderInfo setAttributedTitle:title forState:UIControlStateNormal];
    
    self.commitButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.commitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.commitButton.layer.borderWidth = 1.0f;
    [self.commitButton.layer setCornerRadius:9.0f];
    [self.commitButton.layer setMasksToBounds:YES];
    self.commitButton.enabled = NO;
    
    self.linkManTextField.delegate = self;
    self.phoneLable.delegate = self;
    self.addTextField.delegate = self;
    
    self.putAwayTimeLbale.textColor = JCColor(112,176, 255);
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)name:@"UITextFieldTextDidChangeNotification"object:self.linkManTextField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.phoneLable];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.addTextField];
}

- (IBAction)checkClick:(id)sender {
    self.checkButton.selected = !self.checkButton.isSelected;
    if (self.checkButton.isSelected == YES) {
        self.commitButton.enabled = YES;
        self.commitButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        self.commitButton.enabled = NO;
        self.commitButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.commitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

- (IBAction)oderInfoClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(INGOderInfoViewProtocol:)]) {
        [self.delegate INGOderInfoViewProtocol:self];
    }
}
/** 下单数量的递减 */
- (IBAction)subtractionFuncation:(id)sender {
    if ([self.numOfOrderText.text integerValue] > 1) {
        NSInteger num = [self.numOfOrderText.text integerValue];
        self.numOfOrderText.text = [NSString stringWithFormat:@"%ld",--num];
        CGFloat orderPrice = self.orderModle.MemberPrice / ((self.orderModle.MaxQuantity - self.orderModle.SQuantity) + num);
        self.orderPriceLable.text = [NSString stringWithFormat:@"订单价：%0.2f元",orderPrice * num];
        self.orderModle.Price = ceil(orderPrice * num * 100) / 100;
    }
}
/** 下单数量的递增 */
- (IBAction)addFuncation:(id)sender {
    
    if ([self.numOfOrderText.text integerValue] < self.orderModle.SQuantity) {
        NSInteger num = [self.numOfOrderText.text integerValue];
        self.numOfOrderText.text = [NSString stringWithFormat:@"%ld",++num];
        CGFloat orderPrice = self.orderModle.MemberPrice / ((self.orderModle.MaxQuantity - self.orderModle.SQuantity) + num);
        self.orderPriceLable.text = [NSString stringWithFormat:@"订单价：%0.2f元",orderPrice * num];
        self.orderModle.Price = ceil(orderPrice * num * 100) / 100;
    }
}

- (IBAction)commitClick:(id)sender {
    if ([self isEmpty:self.linkManTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入联系人"];
        return;
    }else if ([self isEmpty:self.phoneLable.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return;
        
    }else if (![self isMobile:self.phoneLable.text]) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }else if ([self isEmpty:self.addTextField.text]){
        [SVProgressHUD showInfoWithStatus:@"请输入联系地址"];
        return;
    }else{
        
        if ([self.delegate respondsToSelector:@selector(INGOderInfoViewCommit:)]) {
            [self.delegate INGOderInfoViewCommit:self];
        }
    }
    
    

}

-(void)setProductModle:(productInfo *)productModle
{
    _productModle = productModle;
    [self.productIcon sd_setImageWithURL:[NSURL URLWithString:productModle.ProductPic] placeholderImage:[UIImage imageNamed:@"order_img0"]];
    self.productName.text = [NSString stringWithFormat:@"产品名称：%@",productModle.ProductName];
    if (![productModle.AdvertiserName isEqualToString:@""]) {
        
        self.admentName.text = [NSString stringWithFormat:@"广告商：%@",productModle.AdvertiserName];
    }
    self.visitorPriceLable.text = [NSString stringWithFormat:@"官方刊例价：%.2f元",productModle.ProductPrice];
    self.putAwayTimeLbale.text = [NSString stringWithFormat:@"上架日期：%@",productModle.PublishTime];
    self.isGroupShowBtn.hidden = !productModle.IsGroup;
    
    if (productModle.IsGroup) {
        self.infoViewTopConstraint.constant = self.orderCountView.height;
        self.orderCountView.hidden = NO;
    }else{
        self.infoViewTopConstraint.constant = 0;
        self.orderCountView.hidden = YES;
    }
}
-(void)setOrderModle:(checkOrder *)orderModle
{
    _orderModle = orderModle;
    self.orderPriceLable.text = [NSString stringWithFormat:@"订单价：%.2f元",orderModle.Price];
    self.priceLable.text = [NSString stringWithFormat:@"会员价：%0.2f元",orderModle.MemberPrice];
    
}
/**
 *  手机号码验证
 *
 *  @param mobileNumbel 传入的手机号码
 *
 *  @return 格式正确返回true  错误 返回fals
 */
- (BOOL) isMobile:(NSString *)mobileNumbel{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019]|7[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }
    
    return NO;
}
/**
 *  判断内容是否全部为空格 ? yes 全部为空格  no 不是
 */
- (BOOL) isEmpty:(NSString *) str {
    
    if (!str) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

-(void)textFiledEditChanged:(NSNotification*)obj
{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    UITextInputMode *currentInputMode = textField.textInputMode;
    NSString *lang = [currentInputMode primaryLanguage]; // 键盘输入模式
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            if(toBeString.length > addressMaxLength) {
                textField.text = [toBeString substringToIndex:addressMaxLength];
                [SVProgressHUD showInfoWithStatus:@"最多150个字符，超出最大范围了"];
            }
        }
        //有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if(toBeString.length > addressMaxLength) {
            textField.text= [toBeString substringToIndex:addressMaxLength];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.linkManTextField == textField  )  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > nameMaxLength) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:nameMaxLength];
            
            [SVProgressHUD showInfoWithStatus:@"最多15个字符，超出最大范围了"];
            return NO;
        }
    }else if (self.phoneLable == textField){
        if ([toBeString length] > phoneMaxLength) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:phoneMaxLength];
            
            [SVProgressHUD showInfoWithStatus:@"最多11个字符，超出最大范围了"];
            return NO;
        }
    }else if ( self.addTextField == textField){
        if ([toBeString length] > addressMaxLength) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:addressMaxLength];
            
            [SVProgressHUD showInfoWithStatus:@"最多150个字符，超出最大范围了"];
            return NO;
        }
    }
    return YES;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
}
@end
