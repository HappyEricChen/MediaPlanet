//
//  INGRetrievePWDNextViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/9.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  找回密码下一步

#import "INGRetrievePWDNextViewController.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJExtension.h>

@interface INGRetrievePWDNextViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passWordOnce;

@property (weak, nonatomic) IBOutlet UITextField *passWordAgain;

@end

static NSInteger const kMaxLength = 20;

@implementation INGRetrievePWDNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = JCColor(238, 238, 238);
    
    self.navigationItem.title = @"找回密码";
    // 创建一个富文本对象
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    // 设置富文本对象的颜色
    attributes[NSForegroundColorAttributeName] = [UIColor blackColor];
    //设置占位文字和他的颜色
    self.passWordOnce.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入密码" attributes:attributes];
    self.passWordAgain.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请再次输入密码" attributes:attributes];
    
    self.passWordOnce.delegate = self;
    self.passWordAgain.delegate = self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.passWordOnce];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.passWordAgain];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (IBAction)commitButtonClick:(id)sender {
    BOOL isInput = [self isInputInfo];
    if (!isInput) return;
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NSMutableString *retrieveUrl = [NSMutableString string];
    [retrieveUrl appendString:apiUrl];
    [retrieveUrl appendString:@"account/chgpwd"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mophone"] = self.phoneNum;
    NSString *passWordStr = [self.passWordOnce.text stringByAppendingString:secretKey];
    params[@"pwd"] = [NSString sha1String:passWordStr];
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"key"]=  key;//@"4DB03900-7322-4C9C-A5D5-94AD7E8A5703";
    params[@"ts"] = timeSp;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    
    [manager POST:retrieveUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        [SVProgressHUD dismiss];
        if (IsSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
            [self settingStandard];
            NSString *UToken = responseObject[@"Results"];
            [UToken settingStandard:strStander];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"请求错误"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试"];
    }];
    
}
/** 账号存入沙盒 */
-(void)settingStandard
{
    //账号的key
    NSString *userKey = @"CFBundleUserNameString";
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:userKey];
    
    //存入沙盒
    [[NSUserDefaults standardUserDefaults]setObject:self.phoneNum forKey:userKey];
    
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

/** 判断输入的合法性 */
-(BOOL)isInputInfo
{
    if (!self.passWordOnce.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return NO;
    }else if (self.passWordOnce.text.length < 6){
        [SVProgressHUD showErrorWithStatus:@"请输入6-20位密码"];
        return NO;
    }else if (![self.passWordOnce.text isEqualToString:self.passWordAgain.text]){
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一样"];
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
#pragma mark - textFied的代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.passWordOnce == textField ||self.passWordAgain == textField )  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > kMaxLength) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:kMaxLength];
            
            [SVProgressHUD showInfoWithStatus:@"最多20个字符，超出最大范围了"];
            return NO;
        }
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
