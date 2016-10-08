//
//  INGRegisterViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/6.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGRegisterViewController.h"
#import "INGLoginViewController.h"
#import "INGregisterNextViewController.h"
#import "INGProtocalInfoViewController.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>


@interface INGRegisterViewController ()<UITextFieldDelegate>

//是否选中按钮
@property (weak, nonatomic) IBOutlet UIButton *isRead;
//手机号码输入框
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextFied;
//协议按钮
@property (weak, nonatomic) IBOutlet UIButton *protocalButton;


//下一步按钮
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIButton *centerInfoButton;

@end
static NSInteger const kMaxLength = 11;

@implementation INGRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = JCColor(238, 238, 238);
    [self setup];
    
}

-(void)setup
{
    self.navigationItem.title = @"会员注册";
    //设置button的下划线
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc]initWithString:@"已阅读《媒体星球用户注册协议》"];
    NSRange titleRange= {3,[title length] - 3};
    NSRange titleRangeAll = {0,[title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    NSMutableDictionary *attribusDict = [NSMutableDictionary dictionary];
    
    attribusDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attribusDict[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [title addAttributes:attribusDict range:titleRangeAll];
    [self.centerInfoButton setAttributedTitle:title forState:UIControlStateNormal];
    
    // 创建一个富文本对象
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    // 设置富文本对象的颜色
    attributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    //设置占位文字和他的颜色
    self.phoneNumTextFied.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入手机号" attributes:attributes];
    self.phoneNumTextFied.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.phoneNumTextFied];

}

- (IBAction)nextButtonClick:(id)sender {
    
    if ([self isInputInfo]) {
        [SVProgressHUD showWithStatus:@"发送中"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"mophone"] = self.phoneNumTextFied.text;
        params[@"key"]= key;
        //时间戳
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        params[@"ts"] = timeSp;
        
        NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
        params[@"sign"] = sign;
        [params removeObjectForKey:@"key"];

        NSMutableString *postUrl = [NSMutableString string];
        [postUrl appendFormat:apiUrl];
        [postUrl appendFormat:@"account/sendmsg"];
        [[AFHTTPSessionManager manager]POST:postUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            BOOL IsSuccess = [responseObject[@"IsSuccess"]boolValue];
            if (IsSuccess) {
                
                [SVProgressHUD showSuccessWithStatus:@"验证码发送成功！"];
                
                [self timeCountDown];
                
                INGregisterNextViewController *nextVC = [[INGregisterNextViewController alloc]init];
                nextVC.phoneNum = self.phoneNumTextFied.text;
                
                [self.navigationController pushViewController:nextVC animated:YES];
                
            }else{
                if ([responseObject[@"ErrorMessage"] isEqualToString:@"无发送额度"]) {
                    [SVProgressHUD showInfoWithStatus:@"获取验证码失败，请稍后重试！"];
                }else{
                    
                    [SVProgressHUD showErrorWithStatus:responseObject[@"ErrorMessage"]];
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //        NSLog(@"%@;请求错误",error);
//            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试"];
        }];
    };
    

}
/** 下一步的倒计时 */
-(void)timeCountDown
{
    __block NSInteger timeout = 60;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        timeout --;
        if (timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
                self.nextButton.enabled = YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.nextButton setTitle:[NSString stringWithFormat:@"%ld秒",(long)timeout] forState:UIControlStateNormal];
                self.nextButton.enabled = NO;
            });
        }
    });
    dispatch_resume(_timer);
}
/** 判断是否输入11位手机号 */
-(BOOL)isInputInfo
{
    if (!self.phoneNumTextFied.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return NO;
    }else if (self.phoneNumTextFied.text.length != kMaxLength){
        [SVProgressHUD showErrorWithStatus:@"手机号码位数不对"];
        return NO;
    }else if (![self isMobile:self.phoneNumTextFied.text]){
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
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
     21         * 133,1349,153,180,189,181(增加)17(0-91)
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
//是都选中已阅读
- (IBAction)isReadButtonClick:(id)sender {
    self.isRead.selected = !self.isRead.isSelected;
    if (self.isRead.isSelected == NO) {
        self.nextButton.enabled = NO;
    }else{
        self.nextButton.enabled = YES;
    }

}

-(void)textFiledEditChanged:(NSNotification*)obj
{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    UITextInputMode *currentInputMode = self.phoneNumTextFied.textInputMode;
    NSString *lang = [currentInputMode primaryLanguage]; // 键盘输入模式
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            if(toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
                [SVProgressHUD showInfoWithStatus:@"最多11个字符，超出最大范围了"];
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
    
    if (self.phoneNumTextFied == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > kMaxLength) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:kMaxLength];
            
            [SVProgressHUD showInfoWithStatus:@"最多11个字符，超出最大范围了"];
            return NO;
        }
    }
    return YES;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
}

- (IBAction)protocalButtonClick:(id)sender {

    INGProtocalInfoViewController *infoVC = [[INGProtocalInfoViewController alloc]init];
    infoVC.title = @"用户注册协议";
    infoVC.isRegsiter = YES;
    [self.navigationController pushViewController:infoVC animated:YES];

    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
/** 设置控制器对应的状态栏是白色 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
