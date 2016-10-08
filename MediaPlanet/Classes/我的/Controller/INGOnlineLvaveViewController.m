//
//  INGOnlineLvaveViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/9.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  在线留言

#import "INGOnlineLvaveViewController.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import <MJExtension.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>

#define MAX_LIMIT_NUMS 100

@interface INGOnlineLvaveViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *lvaveTextView;
@property (weak, nonatomic) IBOutlet UILabel *numLable;

/** placeholderLabel */
@property (nonatomic, strong) UILabel *placeholderLabel;


@end

@implementation INGOnlineLvaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"在线留言";
    [self.view setupGifBG];
    [self setupTextView];
}
-(void)setupTextView
{
    self.lvaveTextView.delegate = self;
    self.lvaveTextView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.lvaveTextView.layer.borderWidth = 1;
    self.lvaveTextView.tintColor = [UIColor whiteColor];
    
    UILabel * placeholderLabel = [[UILabel alloc]init];
    placeholderLabel.frame = CGRectMake(5, 0, 150, 30);
    placeholderLabel.textColor = [UIColor lightGrayColor];
    placeholderLabel.font = [UIFont systemFontOfSize:14];
    placeholderLabel.text = @"请留下您的意见和建议.";
    [self.lvaveTextView addSubview:placeholderLabel];
    self.placeholderLabel = placeholderLabel;
    
}

/** 提交按钮 */
- (IBAction)commitButtonClick:(id)sender
{
    NSString *temp = [self.lvaveTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (temp.length == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"请说点什么吧!"];
        return;

    }else{
        NSMutableString *leaveUrl = [NSMutableString string];
        [leaveUrl appendString:apiUrl];
        [leaveUrl appendString:@"pcenter/submitmsg"];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"msg"] = self.lvaveTextView.text;
        
        //时间戳
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        params[@"key"]=  key;//@"4DB03900-7322-4C9C-A5D5-94AD7E8A5703";
        params[@"ts"] = timeSp;
        
        NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
        params[@"sign"] = sign;
        [params removeObjectForKey:@"key"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
        [manager POST:leaveUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            BOOL isSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (isSuccess){
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"ErrorMessage"]];
            
        };
            
//            NSLog(@"%@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }

}

#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];

    //获取高亮部分

    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];

    //获取高亮部分内容

    //NSString * selectedtext = [textView textInRange:selectedRange];

    //如果有高亮且当前字数开始位置小于最大限制时允许输入

    if (selectedRange && pos) {

        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];

        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];

        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);

        if (offsetRange.location < MAX_LIMIT_NUMS) {

            return YES;

        }else{

            return NO;

        }

    }

    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];

    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;

    if (caninputlen >= 0)

    {

        return YES;

    }else{

        NSInteger len = text.length + caninputlen;

        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错

        NSRange rg = {0,MAX(len,0)};

        if (rg.length > 0){

            NSString *s = @"";

            //判断是否只普通的字符或asc码(对于中文和表情返回NO)

            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];

            if (asc) {
 
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错

            }else{

                __block NSInteger idx = 0;

                __block NSString  *trimString = @"";//截取出的字串

                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个

                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])

                                         options:NSStringEnumerationByComposedCharacterSequences
 
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
//                                          NSInteger subLenth = substring.length;
                                          
                                          ++idx;
                                          if (idx >= rg.length) {
       
                                              *stop = YES; //取出所需要就break，提高效率

                                              return ;

                                          }

                                          trimString = [trimString stringByAppendingString:substring];
    

                                      }];

                s = trimString;

            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];

            //既然是超出部分截取了，哪一定是最大限制了。

            self.numLable.text = [NSString stringWithFormat:@"%ld/%ld",(long)MAX_LIMIT_NUMS,(long)MAX_LIMIT_NUMS];

        }

        return NO;
    }
}

-(void)textViewDidChange:(UITextView *)textView
{

    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了

    if (selectedRange && pos) {
        return;
    }
    NSString  *nsTextContent = textView.text;

    NSInteger existTextNum = nsTextContent.length;

    if (existTextNum > MAX_LIMIT_NUMS){
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)

        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        [textView setText:s];
        existTextNum = MAX_LIMIT_NUMS;
    }
    //不让显示负数 口口日
    self.numLable.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,existTextNum),MAX_LIMIT_NUMS];

}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.placeholderLabel.hidden = YES;
    
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.lvaveTextView.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    }
}
/** 设置控制器对应的状态栏是白色 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
