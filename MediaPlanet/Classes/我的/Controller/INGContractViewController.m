//
//  INGContractViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/3.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  合同模板

#import "INGContractViewController.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import <MJExtension.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>

@interface INGContractViewController ()
/** 输入框 */
@property (nonatomic, strong) UITextField *textField;
/** 提交按钮 */
@property (nonatomic, strong) UIButton *subButton;
/** 白色的View */
@property (nonatomic, strong) UIView *infoView;

@end

@implementation INGContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.view setupGifBG];
    
    [self setupTextView];
    
    [self setupLine];
    [self setupSubButton];
    
    [self setupInfoLable];
    
}
-(void)setupTextView
{
    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, screenW, 120)];
    infoView.backgroundColor = [UIColor whiteColor];
    self.infoView = infoView;
    [self.view addSubview: infoView];
    self.view.backgroundColor = JCColor(238, 238, 238);
    
    UITextField *textField = [[UITextField alloc]init];
    textField.frame = CGRectMake(35, 10, screenW - 2 * 30 - 50, 30);
    textField.centerY = self.infoView.height * 0.35;
    //左边图片
    UIImageView *emailView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"email"]];
    emailView.width = 30;
    emailView.height = 30;
    emailView.contentMode = UIViewContentModeCenter;
    textField.leftView = emailView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.font = [UIFont systemFontOfSize:15];
    //占位文字
    NSMutableDictionary *attribusDict = [NSMutableDictionary dictionary];
    attribusDict[NSForegroundColorAttributeName] = JCColor(96, 96, 96);
    textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入邮箱" attributes:attribusDict];
    textField.tintColor = [UIColor blackColor];
    textField.textColor = [UIColor blackColor];
    [infoView addSubview:textField];
    self.textField = textField;
}
-(void)setupLine
{
    UILabel *lineView = [[UILabel alloc]init];
    lineView.backgroundColor = JCColor(238, 238, 238);
    
    
    lineView.frame = CGRectMake(self.textField.x, self.infoView.height * 0.5, screenW - 2 * self.textField.x, 1);
    
    [self.infoView addSubview:lineView];
}
-(void)setupSubButton
{
    UIButton *subButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [subButton addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
    //    [subButton setBackgroundImage:[UIImage imageNamed:@"email_button"] forState:UIControlStateNormal];
    [subButton setTitle:@"提交" forState:UIControlStateNormal];
    subButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [subButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [subButton setTitleColor:JCColor(96, 96, 96) forState:UIControlStateHighlighted];
    
    //    subButton.x = CGRectGetMaxX(self.textField.frame)+10;
    //    subButton.y= self.textField.y + 3;
    //    subButton.width = 37;
    //    subButton.height = 22;
    subButton.width = 100;
    subButton.height = 30;
    subButton.centerX = screenW * 0.5;
    subButton.centerY = self.infoView.height * 0.75;
    subButton.layer.borderColor = [UIColor blackColor].CGColor;
    subButton.layer.borderWidth = 1.0f;
    [subButton.layer setMasksToBounds:YES];
    self.subButton = subButton;
    [self.infoView addSubview:subButton];
    
}

-(void)setupInfoLable
{
    UILabel *infoLable = [[UILabel alloc]init];
    infoLable.font = [UIFont systemFontOfSize:14];
    infoLable.textColor = [UIColor redColor];
    infoLable.numberOfLines = 0;
//    infoLable.backgroundColor = [UIColor yellowColor];
    infoLable.textAlignment = NSTextAlignmentLeft;
    infoLable.x = 35;
    infoLable.y = CGRectGetMaxY(self.infoView.frame) + 20;
    infoLable.width = screenW - 65;
    infoLable.height = 45;
    infoLable.text = @"请留下您的邮箱地址，我们会尽快将合同模板发送到您的邮箱。";
    [self.view addSubview:infoLable];
}


-(void)commitClick
{
    if ([self.textField.text isEqualToString:@""]) {
//        NSLog(@"请输入邮箱");
        [SVProgressHUD showInfoWithStatus:@"请输入邮箱"];
        return;
    }else if  ([self validateEmail:self.textField.text]) {
        NSMutableString *contractUrl = [NSMutableString string];
        [contractUrl appendString:apiUrl];
        [contractUrl appendString:@"pcenter/commitemail"];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"email"] = self.textField.text;
        
        params[@"key"]= key;
        //时间戳
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        params[@"ts"] = timeSp;
        
        NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
        params[@"sign"] = sign;
        [params removeObjectForKey:@"key"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //设置请求头
        [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
        
        [manager POST:contractUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
            if (IsSuccess) {
//                NSLog(@"发送成功");
                [SVProgressHUD showSuccessWithStatus:@"发送成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
//                NSLog(@"发送失败");
                [SVProgressHUD showErrorWithStatus:@"发送失败"];
            }
            //            NSLog(@"%@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    } else {
//        NSLog(@"请输入正确的邮箱");
        [SVProgressHUD showErrorWithStatus:@"请输入正确的邮箱"];
    }
    
}

//邮箱正则表达式
- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
