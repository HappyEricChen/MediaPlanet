//
//  INGAlterNickViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/9.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  修改昵称

#import "INGAlterNickViewController.h"
#import "NSMutableDictionary+Extension.h"
#import "NSString+INGExtension.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>

@interface INGAlterNickViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nickTextFied;

@end

static NSInteger const kMaxLength = 15;

@implementation INGAlterNickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改昵称";
    self.nickTextFied.delegate = self;
    [self.view setupGifBG];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                               name:@"UITextFieldTextDidChangeNotification"
                                             object:self.nickTextFied];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self.nickTextFied becomeFirstResponder];
}

-(void)textFiledEditChanged:(NSNotification*)obj
{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    UITextInputMode *currentInputMode = self.nickTextFied.textInputMode;
    NSString *lang = [currentInputMode primaryLanguage]; // 键盘输入模式
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            if(toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
                [SVProgressHUD showInfoWithStatus:@"最多15个字符，超出最大范围了"];
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

- (IBAction)commitButtonClick:(id)sender {
    if ([self.nickTextFied.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入昵称"];
    }else{
        NSString *temp = [self.nickTextFied.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (temp.length != 0) {
            
            [self updataInfo];
        }else{
            [SVProgressHUD showErrorWithStatus:@"昵称不允许为空"];
        }
        
    }
}

#pragma mark - textfield代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self commitButtonClick:nil];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.nickTextFied == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > kMaxLength) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:kMaxLength];
            
            [SVProgressHUD showInfoWithStatus:@"最多15个字符，超出最大范围了"];
            return NO;
        }
    }
    return YES;
}

/** 修改会员资料 */
-(void)updataInfo
{
    NSMutableString *infoUrl = [NSMutableString string];
    [infoUrl appendString:apiUrl];
    [infoUrl appendString:@"pcenter/editmember"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"nick"] = self.nickTextFied.text;
//    NSString *gender = ([self.gender isEqualToString: @"男"] ? @"false" : @"true");
    params[@"gender"] = nil;
    params[@"birth"] = nil;
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    //    params[@"pic"] = self.picStr;
    
    params[@"key"] = key;
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    
    [params removeObjectForKey:@"key"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求头
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:infoUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
}

/** 设置控制器对应的状态栏是白色 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
}
@end
