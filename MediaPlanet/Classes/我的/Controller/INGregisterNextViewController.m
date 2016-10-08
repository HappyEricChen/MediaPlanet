//
//  INGregisterNextViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/6.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGregisterNextViewController.h"
#import "INGHomeController.h"
#import "INGTabBarController.h"
#import "NSString+INGExtension.h"
#import "loginMedel.h"
#import "NSMutableDictionary+Extension.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>


@interface INGregisterNextViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *phoneLable;
//密码
@property (weak, nonatomic) IBOutlet UITextField *passWordTextFied;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *authCodeTextFied;
//密码确认
@property (weak, nonatomic) IBOutlet UITextField *aginPWDtextFied;
@property (weak, nonatomic) IBOutlet UIButton *getAuthButton;
/** 时钟 */
@property (nonatomic, strong) NSTimer *timer;

/** 倒计时数字 */
@property (nonatomic, assign) NSInteger timerCount;

@end

static NSInteger const kMaxLength = 20;

@implementation INGregisterNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"会员注册";
    
    [self.view setupGifBG];
    [self setup];
}
/** 初始化界面 */
-(void)setup
{
    // 创建一个富文本对象
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    // 设置富文本对象的颜色
    attributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    //设置占位文字和他的颜色
    self.authCodeTextFied.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入验证码" attributes:attributes];
    
    self.passWordTextFied.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入密码" attributes:attributes];
    self.aginPWDtextFied.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请再次输入密码" attributes:attributes];
    
    self.authCodeTextFied.delegate = self;
    self.passWordTextFied.delegate = self;
    self.aginPWDtextFied.delegate = self;
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
//                                                name:@"UITextFieldTextDidChangeNotification"
//                                              object:self.authCodeTextFied];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.passWordTextFied];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.aginPWDtextFied];
    
    self.getAuthButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.getAuthButton.layer.borderWidth = 1.0f;
    self.getAuthButton.layer.cornerRadius = 5.0f;
    [self.getAuthButton.layer setMasksToBounds:YES];
    NSString *tel = [self.phoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.phoneLable.text = [NSString stringWithFormat:@"手机号码:%@",tel ];
    
    [self timerTheard];
    
    
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
/** 判断是否输入密码和验证码 */
-(BOOL)isInputPSW
{
    if (self.authCodeTextFied.text.length != 6) {
        [SVProgressHUD showErrorWithStatus:@"请输入6位验证码"];
        return NO;
    }else if (self.passWordTextFied.text.length < 6){
        [SVProgressHUD showErrorWithStatus:@"请输入6-20位密码"];
        return NO;
    }else if (![self.passWordTextFied.text isEqualToString:self.aginPWDtextFied.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请确保两次输入的密码相同！"];
        return NO;
    }
    return YES;
}

//获取验证码
- (IBAction)getAnthCode:(id)sender {
    //http://112.64.131.222/
    //请求API的URL
    self.getAuthButton.enabled = NO;
    NSMutableString *sendUrl = [NSMutableString string];
    [sendUrl appendString:apiUrl];
    [sendUrl appendString:@"account/sendmsg"];
    [SVProgressHUD showWithStatus:@"f发送中"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mophone"] = self.phoneNum;
    params[@"key"]= key;
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    
    [[AFHTTPSessionManager manager]POST:sendUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            [self timerTheard];
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取失败，请稍后重试!"];
//            NSLog(@"发送失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"获取失败，请稍后重试!"];
//        NSLog(@"%@,请求数据失败",error);
    }];
}
- (IBAction)loginButtonClick:(id)sender {
    //判断输入是否合法
    if ([self isInputPSW]) {
        //请求API的URL
        [SVProgressHUD showWithStatus:@"登录中"];
        NSMutableString *postUrl = [NSMutableString string];
        [postUrl appendString:apiUrl];
        [postUrl appendString:@"account/reg"];
        
        NSString *passWordStr = [self.passWordTextFied.text stringByAppendingString:secretKey];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"msg"] = self.authCodeTextFied.text;
        params[@"mophone"] = self.phoneNum;
        params[@"pwd"] = [NSString sha1String:passWordStr];
        params[@"key"]= key;
        params[@"ptag"] = [JPUSHService registrationID];
        //时间戳
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        params[@"ts"] = timeSp;
        
        NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
        params[@"sign"] = sign;
        [params removeObjectForKey:@"key"];

        [[AFHTTPSessionManager manager]POST:postUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            [SVProgressHUD dismiss];
            loginMedel *model = [loginMedel mj_objectWithKeyValues:responseObject];
            if (model.IsSuccess) {
                //如果成功，把账号保存到沙盒中
                //把返回的UToken存入沙盒
                NSString *UToken = model.Results;
                [UToken settingStandard:strStander];
                
                //发出登录通知
                [[NSNotificationCenter defaultCenter]postNotificationName:INGUserLoginOrOutNotification object:nil];
                
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                [self settingStandard];
//                self.tabBarController.selectedIndex = 0;
//                [self.navigationController popToRootViewControllerAnimated:YES];
                [self dismissViewControllerAnimated:YES completion:^{
                    
                    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
                    if ([root isKindOfClass:[INGTabBarController class]]) {
                        INGTabBarController *keyVC = (INGTabBarController *)root;
                        if (keyVC.selectedIndex != 1) {
                            keyVC.selectedIndex = 0;
                        }
                    }
                    
                }];
                
            }else{
                [SVProgressHUD showErrorWithStatus:model.ErrorMessage];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"登录失败，请稍后重试!"];
        }];
    }
    
    
}
/** 存入沙盒 */
-(void)settingStandard
{
    //账号的key
    NSString *userKey = @"CFBundleUserNameString";
    //密码的key
//    NSString *pswKey = @"CFBundlePassWordString";

    [[NSUserDefaults standardUserDefaults]removeObjectForKey:userKey];
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:pswKey];

    //存入沙盒
    [[NSUserDefaults standardUserDefaults]setObject:self.phoneNum forKey:userKey];

    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


/** 设置控制器对应的状态栏是白色 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
    
    if (self.passWordTextFied == textField ||self.aginPWDtextFied == textField )  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > kMaxLength) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:kMaxLength];
            
            [SVProgressHUD showInfoWithStatus:@"最多20个字符，超出最大范围了"];
            return NO;
        }
    }else if (self.authCodeTextFied == textField){
        if ([toBeString length] > 6) { //如果输入框内容大于6则弹出警告
            textField.text = [toBeString substringToIndex:6];
            
            [SVProgressHUD showInfoWithStatus:@"最多6个字符，超出最大范围了"];
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
