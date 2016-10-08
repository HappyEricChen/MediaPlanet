//
//  INGRetrievePWDViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/8.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  找回密码

#import "INGRetrievePWDViewController.h"
#import "INGRetrievePWDNextViewController.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJExtension.h>

@interface INGRetrievePWDViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextFied;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTextFied;


@property (weak, nonatomic) IBOutlet UIButton *getAuthButton;
/** 手机号码 */
@property (nonatomic, strong) NSString *phoneNum;
/** 倒计时 */
@property (nonatomic, assign) NSInteger timerCount;
/** 计时器 */
@property (nonatomic, strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

static NSInteger const kMaxLength = 11;

@implementation INGRetrievePWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = JCColor(238, 238, 238);
    
    self.getAuthButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.getAuthButton.layer.borderWidth = 1.0f;
    self.getAuthButton.backgroundColor = JCColor(238, 238, 238);//JCColor(51, 94, 169);
    [self.getAuthButton.layer setCornerRadius:5.0];
    [self.getAuthButton.layer setMasksToBounds:YES];
    
    self.nextButton.backgroundColor = JCColor(51, 94, 169);
    self.nextButton.height = 44;
    [self.nextButton.layer setCornerRadius:self.nextButton.height * 0.5];
    [self.nextButton.layer setMasksToBounds:YES];
    
    self.navigationItem.title = @"找回密码";
    // 创建一个富文本对象
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    // 设置富文本对象的颜色
    attributes[NSForegroundColorAttributeName] = [UIColor blackColor];
    //设置占位文字和他的颜色
    self.phoneNumTextFied.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入手机号" attributes:attributes];
    self.authCodeTextFied.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入验证码" attributes:attributes];
    self.phoneNumTextFied.delegate = self;
    self.authCodeTextFied.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.authCodeTextFied];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.phoneNumTextFied];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)nextButtonClick:(id)sender {
    
    BOOL isInput = [self isInputAuto];
    if (!isInput)  return;
    NSMutableString *retrieveUrl = [NSMutableString string];
    [retrieveUrl appendString:apiUrl];
    [retrieveUrl appendString:@"account/chkmsg"];//account/chkmsg
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mophone"] = self.phoneNumTextFied.text;
    params[@"msg"] = self.authCodeTextFied.text;
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"key"]=  key;//@"4DB03900-7322-4C9C-A5D5-94AD7E8A5703";
    params[@"ts"] = timeSp;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    
    [manager POST:retrieveUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            
            INGRetrievePWDNextViewController *vc = [[INGRetrievePWDNextViewController alloc]init];
            vc.phoneNum = self.phoneNum;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [SVProgressHUD showInfoWithStatus:@"验证码错误"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}
- (IBAction)getAutoClick:(id)sender {
    
    BOOL isInput = [self isInputPhone];
    if (!isInput)  return;
    [SVProgressHUD showWithStatus:@"发送中……"];
    NSMutableString *retrieveUrl = [NSMutableString string];
    [retrieveUrl appendString:apiUrl];
    [retrieveUrl appendString:@"account/pwdmsg"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mophone"] = self.phoneNumTextFied.text;
//    params[@"msg"] = self.authCodeTextFied.text;
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"key"]=  key;//@"4DB03900-7322-4C9C-A5D5-94AD7E8A5703";
    params[@"ts"] = timeSp;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    
    [manager POST:retrieveUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"验证码发送成功！"];
            self.phoneNum = self.phoneNumTextFied.text;
            [self timerTheard];
        }else{
            if ([responseObject[@"ErrorMessage"] isEqualToString:@"无发送额度"]) {
                [SVProgressHUD showInfoWithStatus:@"获取失败，请稍后重试!"];
            }else{
                
                [SVProgressHUD showInfoWithStatus:@"填写的手机号未注册!"];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"获取失败，请稍后再试!"];
    }];
    
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
    
    if (self.phoneNumTextFied == textField )  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > kMaxLength) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:kMaxLength];
            
            [SVProgressHUD showInfoWithStatus:@"最多11个字符，超出最大范围了"];
            return NO;
        }
    }else if (self.authCodeTextFied == textField){
        if ([toBeString length] > 6) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:6];
            
            [SVProgressHUD showInfoWithStatus:@"最多6个字符，超出最大范围了"];
            return NO;
        }
    }
    return YES;
}


-(void)timerTheard
{
    self.timerCount = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setButtonTitle) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
-(void)setButtonTitle
{
    self.timerCount --;
    self.getAuthButton.enabled = NO;
    [self.getAuthButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.getAuthButton setTitle:[NSString stringWithFormat:@"%02ld秒后重发",(long)self.timerCount] forState:UIControlStateNormal];
    
    if (self.timerCount <= 0) {
        [self.getAuthButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.getAuthButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.getAuthButton.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
        [self.getAuthButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

/** 判断输入的合法性 */
-(BOOL)isInputPhone
{
    if (!self.phoneNumTextFied.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return NO;
    }else if (self.phoneNumTextFied.text.length != 11){
        [SVProgressHUD showErrorWithStatus:@"手机号码位数不对"];
        return NO;
    }
    return YES;
}
/** 判断输入的合法性 */
-(BOOL)isInputAuto
{
    if (!self.authCodeTextFied.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return NO;
    }else if (self.authCodeTextFied.text.length != 6){
        [SVProgressHUD showErrorWithStatus:@"请输入正确的6位验证码"];
        return NO;
    }
    return YES;
}

/** 设置控制器对应的状态栏是白色 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
}
@end
