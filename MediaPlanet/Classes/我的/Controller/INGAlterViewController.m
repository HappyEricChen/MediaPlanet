//
//  INGAlterViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/14.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  修改密码

#import "INGAlterViewController.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>

@interface INGAlterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPassWord;
@property (weak, nonatomic) IBOutlet UITextField *PassWord;
@property (weak, nonatomic) IBOutlet UITextField *aginNewPassWord;

@end

static NSInteger const kMaxLength = 20;

@implementation INGAlterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改登录密码";
    [self setup];
}
-(void)setup
{
    self.view.frame = [UIScreen mainScreen].bounds;
    [self.view setupGifBG];
    // 创建一个富文本对象
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    // 设置富文本对象的颜色
    attributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    
    //设置占位文字和他的颜色
    self.oldPassWord.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入原密码" attributes:attributes];
    
    self.PassWord.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入新密码" attributes:attributes];
    self.aginNewPassWord.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请再次输入新密码" attributes:attributes];
    
    self.oldPassWord.delegate = self;
    self.PassWord.delegate = self;
    self.aginNewPassWord.delegate = self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.PassWord];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.oldPassWord];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.aginNewPassWord];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)commitClick:(id)sender {
    
    if (![self isInputPSW])  return;
    [SVProgressHUD showWithStatus:@"修改中"];
    NSMutableString *alterUrl = [NSMutableString string];
    [alterUrl appendString:apiUrl];
    [alterUrl appendString:@"account/transpwd"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = key;
    //账号的key
    NSString *userKey = @"CFBundleUserNameString";
    NSString *mophone = [userKey getOutStandard];
    params[@"mophone"] = mophone;
    NSString *oldPassWordStr = [self.oldPassWord.text stringByAppendingString:secretKey];
    NSString *passWordStr = [self.PassWord.text stringByAppendingString:secretKey];
    params[@"pwd"] = [NSString sha1String:oldPassWordStr];
    params[@"npwd"] = [NSString sha1String:passWordStr];
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:alterUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            
//            NSString *GUID = responseObject[@"Results"];
//            [GUID settingStandard:strStander];
            [SVProgressHUD showSuccessWithStatus:@"修改密码成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showInfoWithStatus:@"原密码错误"];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"连接失败,稍后重试"];
    }];
    
}

/** 判断是否输入密码和验证码 */
-(BOOL)isInputPSW
{
    if (!self.oldPassWord.text.length ||  ![self.oldPassWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        [SVProgressHUD showInfoWithStatus:@"请输入原密码"];
        return NO;
    }else if (!self.PassWord.text.length ||  ![self.PassWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length){
        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
        return NO;
    }else if (!self.aginNewPassWord.text.length||  ![self.aginNewPassWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length){
        [SVProgressHUD showInfoWithStatus:@"请输入确认密码"];
        return NO;
    }else if (self.PassWord.text.length < 6){
        [SVProgressHUD showInfoWithStatus:@"请输入6-20位密码"];
        return NO;
    }else if (![self.PassWord.text isEqualToString:self.aginNewPassWord.text])
    {
        [SVProgressHUD showInfoWithStatus:@"两次密码不一样！"];
        return NO;
    }else if (self.PassWord.text == self.oldPassWord.text)
    {
        [SVProgressHUD showInfoWithStatus:@"原密码和新密码不能一样"];
        return NO;
    }
    return YES;
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
            if(toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
                [SVProgressHUD showInfoWithStatus:@"最多20个字符，超出最大范围了"];
            }
        }
        //有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if(toBeString.length > kMaxLength) {
            textField.text= [toBeString substringToIndex:kMaxLength];
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
    
    if (self.oldPassWord == textField ||self.PassWord == textField || self.aginNewPassWord == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > kMaxLength) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:kMaxLength];
            
            [SVProgressHUD showInfoWithStatus:@"最多20个字符，超出最大范围了"];
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
