//
//  INGLoginViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/6.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGLoginViewController.h"
#import "INGHomeController.h"
#import "INGRegisterViewController.h"
#import "INGNavigationController.h"
#import "INGRetrievePWDViewController.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import "INGTabBarController.h"
#import "loginMedel.h"
#import "CustomAlertView.h"
#import "INGProductInfoViewController.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJExtension.h>

@interface INGLoginViewController ()  <UITextFieldDelegate>//<CustomAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextFied;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextFied;
@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *regiterButton;

/** 登录返回的数据 */
@property (nonatomic, strong) NSMutableArray *loginModel;

/** 当前选中的索引 */
@property (nonatomic, assign) NSInteger lastSelectedIndex;


@end

static NSInteger const phoneMaxLength = 11;
static NSInteger const psdMaxLength = 20;

@implementation INGLoginViewController

-(NSMutableArray *)loginModel
{
    if (_loginModel == nil) {
        _loginModel = [NSMutableArray array];
    }
    return _loginModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsCompact];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    self.navigationController.navigationBar.clipsToBounds = YES;
    
    [self setupBGImageView];
//    [self.view setupGifBG];
//    self.headerIcon.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.headerIcon.layer.borderWidth = 2.0f;
    [self.headerIcon.layer setMasksToBounds:YES];
    [SVProgressHUD dismiss];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelClick)];
    self.loginButton.backgroundColor = JCColor(51, 94, 169);
    self.loginButton.height = 30;
    self.loginButton.layer.cornerRadius = self.loginButton.height * 0.5;
    
    [self.loginButton.layer setMasksToBounds:YES];
    
    self.regiterButton.backgroundColor = [UIColor colorWithRed:(238 /255.0) green:(238 /255.0) blue:(238 /255.0) alpha:0.5];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // 创建一个富文本对象
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    // 设置富文本对象的颜色
    attributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    //设置占位文字和他的颜色
    self.phoneTextFied.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入手机号" attributes:attributes];
    self.passWordTextFied.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入登录密码" attributes:attributes];
    
    self.phoneTextFied.delegate = self;
    self.passWordTextFied.delegate = self;
    
    //添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.phoneTextFied];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.passWordTextFied];
}

-(void)setupBGImageView
{
    CGRect frame = CGRectMake(0, 0, screenW, screenH);
    
    NSData *gif = nil;
    
    gif = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loginBGView" ofType:@"png"]];
    
    UIImage *image = [UIImage imageWithData:gif];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    imageView.frame = frame;
    
    [self.view insertSubview:imageView atIndex:0];

}
-(void)cancelClick
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        if ([root isKindOfClass:[INGTabBarController class]]) {
            INGTabBarController *keyVC = (INGTabBarController *)root;
            if (keyVC.selectedIndex != 1) {
                keyVC.selectedIndex = 0;
            }
        }
        
    }];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (IBAction)foergetPassWord:(id)sender {

    INGRetrievePWDViewController *vc = [[INGRetrievePWDViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}
/** 登录按钮的点击 */
- (IBAction)loginButtonClick:(id)sender {
    
//    [NSString sha1String:@"123456"];
    [self.view endEditing:YES];
    
    if ([self isInputInfo]) {
        
        [SVProgressHUD showWithStatus:@"登录中"];
        
        NSMutableString *loginUrl = [NSMutableString string];
        
        [loginUrl appendString:apiUrl];
        [loginUrl appendString:@"account/login"];
        
        NSString *passWordStr = [self.passWordTextFied.text stringByAppendingString:secretKey];
        //[@"123450" stringByAppendingString:secretKey];
        //;
        
        //判断账号密码信息是否正确
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"mophone"] = self.phoneTextFied.text;
        params[@"pwd"] = [NSString sha1String:passWordStr];
        params[@"key"]= key;
        params[@"ptag"] = [JPUSHService registrationID];
        //时间戳
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        params[@"ts"] = timeSp;
        
        NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
        params[@"sign"] = sign;
        [params removeObjectForKey:@"key"];
        
//        NSLog(@"sha1:%@",[NSString sha1String:passWordStr]);
        [[AFHTTPSessionManager manager]POST:loginUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            loginMedel *model = [loginMedel mj_objectWithKeyValues:responseObject];

            //取出沙盒的数据
//            NSLog(@"%@",[strStander getOutStandard]);
            
            if (model.IsSuccess) {
                [SVProgressHUD dismiss];
                //把返回的UToken存入沙盒
                NSString *UToken = model.Results;
                [UToken settingStandard:strStander];
                
                [self settingStandard];
                
                //发出登录通知
                [[NSNotificationCenter defaultCenter]postNotificationName:INGUserLoginOrOutNotification object:nil];
                
                [self dismissViewControllerAnimated:YES completion:nil];
//                [self.navigationController popToRootViewControllerAnimated:YES];
//                [self cancelClick];
            }else{
//                NSLog(@"loginButtonClick登录失败");
                [SVProgressHUD showErrorWithStatus:@"账号或密码错误"];

            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            [SVProgressHUD showInfoWithStatus:@"网络错误，请稍后重试"];
        }];
    }
}



- (IBAction)phoneRegiste:(id)sender {
    INGRegisterViewController *registerVc = [[INGRegisterViewController alloc]init];
    
    [self.navigationController pushViewController:registerVc animated:YES];
    
    
}
/** 账号存入沙盒 */
-(void)settingStandard
{
    //账号的key
    NSString *userKey = @"CFBundleUserNameString";

    [[NSUserDefaults standardUserDefaults]removeObjectForKey:userKey];

    //存入沙盒
    [[NSUserDefaults standardUserDefaults]setObject:self.phoneTextFied.text forKey:userKey];

    
    [[NSUserDefaults standardUserDefaults]synchronize];

}

/** 判断输入的合法性 */
-(BOOL)isInputInfo
{
    if (!self.phoneTextFied.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return NO;
    }else if (self.phoneTextFied.text.length != 11){
        [SVProgressHUD showErrorWithStatus:@"手机号码位数不对"];
        return NO;
    }else if (![self isMobile:self.phoneTextFied.text]){
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return NO;
    }else if (!self.passWordTextFied.text.length)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return NO;
    }
    return YES;
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
    NSString * CT = @"^1((33|53|8[019]|7[0-9])[0-9]|349)\\d{7}$";
    
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
            if(toBeString.length > psdMaxLength) {
                textField.text = [toBeString substringToIndex:psdMaxLength];
                [SVProgressHUD showInfoWithStatus:@"最多20个字符，超出最大范围了"];
            }
        }
        //有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if(toBeString.length > psdMaxLength) {
            textField.text= [toBeString substringToIndex:psdMaxLength];
        }
    }
}
#pragma mark - textfied的代理

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.passWordTextFied == textField )  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > psdMaxLength) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:psdMaxLength];
            
            [SVProgressHUD showInfoWithStatus:@"最多20个字符，超出最大范围了"];
            return NO;
        }
    }else if (self.phoneTextFied == textField){
        if ([toBeString length] > phoneMaxLength) { //如果输入框内容大于6则弹出警告
            textField.text = [toBeString substringToIndex:phoneMaxLength];
            
            [SVProgressHUD showInfoWithStatus:@"最多11个字符，超出最大范围了"];
            return NO;
        }
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self loginButtonClick:nil];
    return YES;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
}
/** 设置控制器对应的状态栏是白色 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
