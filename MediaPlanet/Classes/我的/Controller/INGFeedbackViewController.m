//
//  INGFeedbackViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/7/8.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  意见反馈

#import "INGFeedbackViewController.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>

@interface INGFeedbackViewController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
/** 意见反馈 */
@property (nonatomic, strong) UITextView *feedbackText;
/** 占位lable */
@property (nonatomic, strong) UILabel *placeholderLabel;
/** 计数lable */
@property (nonatomic, strong) UILabel *numLable;
/** 提交按钮 */
@property (nonatomic, strong) UIButton *commitBtn;
/** 功能选择 */
@property (nonatomic, strong) UIButton *functionBtn;
/** 意见类型数组 */
@property (nonatomic, strong) NSArray *titleArray;
/** tableview */
@property (nonatomic, strong) UITableView *tableView;
/** 意见类型 */
@property (nonatomic, assign) NSInteger intType;

@end

#define MAX_LIMIT_NUMS 100

@implementation INGFeedbackViewController

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.functionBtn.x, CGRectGetMaxY(self.functionBtn.frame), self.functionBtn.width, self.functionBtn.height * 6)];
        _tableView.layer.borderColor =[UIColor whiteColor].CGColor;
        _tableView.layer.borderWidth = 1.0f;
        [_tableView.layer setMasksToBounds:YES];
        _tableView.backgroundColor = [UIColor colorWithHue:99/255 saturation:99/255 brightness:99/255 alpha:0.5];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 25;
        _tableView.hidden = YES;
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}
/** 懒加载 */
-(NSArray *)titleArray
{
    if (_titleArray == nil) {
        _titleArray = @[@"功能建议",@"页面展示",@"商品反馈",@"售后服务",@"相关活动",@"其他"];
    }
    return _titleArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.intType = 0;
    [self.view setupGifBG];
    
    [self setupTextView];
}

-(void)setupTextView
{
    
    self.title = @"意见反馈";
    
    UILabel *showLable = [[UILabel alloc]init];
    showLable.frame = CGRectMake(20, 74, 70, 25);
    showLable.font = [UIFont systemFontOfSize:14];
    showLable.textColor = [UIColor whiteColor];
    showLable.text = @"反馈类型：";
    [self.view addSubview:showLable];
    
    UIButton *functionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    functionBtn.frame = CGRectMake(CGRectGetMaxX(showLable.frame) + 10, showLable.y, 100, 25);
    [functionBtn setTitle:@"功能选择" forState:UIControlStateNormal];
    functionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    functionBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    functionBtn.layer.borderWidth = 1.0;
    [functionBtn.layer setMasksToBounds:YES];
    functionBtn.layer.cornerRadius = 2.0;
    [functionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [functionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [functionBtn setImage:[UIImage imageNamed:@"nav_arrow_down"] forState:UIControlStateNormal];
    
    [ functionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [ functionBtn setImage:[UIImage imageNamed:@"nav_arrow_down"] forState:UIControlStateSelected];
     functionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [ functionBtn setImageEdgeInsets:UIEdgeInsetsMake(0, functionBtn.width -  functionBtn.imageView.width * 2 , 0, 0)];
    [ functionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - (( functionBtn.imageView.width) * 2), 0, 0)];
    
    
    [functionBtn addTarget:self action:@selector(chooseFunction) forControlEvents:UIControlEventTouchUpInside];
    self.functionBtn = functionBtn;
    [self.view addSubview:functionBtn];
    
    UITextView *feedbackText = [[UITextView alloc]init];
    feedbackText.frame = CGRectMake(10, CGRectGetMaxY(self.functionBtn.frame) + 10, screenW - 20, 150);
    feedbackText.backgroundColor = [UIColor clearColor];
    feedbackText.textColor = [UIColor whiteColor];
    feedbackText.tintColor = [UIColor whiteColor];
    self.feedbackText = feedbackText;
    self.feedbackText.delegate = self;
    self.feedbackText.layer.borderColor = [UIColor whiteColor].CGColor;
    self.feedbackText.layer.borderWidth = 1;
    self.feedbackText.tintColor = [UIColor whiteColor];
    [self.view addSubview:feedbackText];
    
    UILabel * placeholderLabel = [[UILabel alloc]init];
    placeholderLabel.backgroundColor = [UIColor clearColor];
    placeholderLabel.frame = CGRectMake(5, 0, 150, 30);
    placeholderLabel.textColor = [UIColor lightGrayColor];
    placeholderLabel.font = [UIFont systemFontOfSize:14];
    placeholderLabel.text = @"请留下您的意见和建议.";
    [self.feedbackText addSubview:placeholderLabel];
    self.placeholderLabel = placeholderLabel;
    
    
    UILabel *numLable = [[UILabel alloc]init];
    numLable.frame = CGRectMake(screenW - 90, CGRectGetMaxY(self.feedbackText.frame) + 5, 70, 30);
    numLable.textColor = [UIColor whiteColor];
    numLable.font = [UIFont systemFontOfSize:14];
    numLable.text = @"0/100";
    numLable.textAlignment = NSTextAlignmentRight;
    self.numLable = numLable;
    [self.view addSubview:numLable];
    
    UIButton *commitbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitbtn.frame = CGRectMake(screenW - 90, CGRectGetMaxY(self.numLable.frame)+ 10, 70, 25);
    [commitbtn setTitle:@"提交" forState:UIControlStateNormal];
    commitbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [commitbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitbtn addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
    commitbtn.layer.borderColor = [UIColor whiteColor].CGColor;
    commitbtn.layer.borderWidth = 1.0;
    [commitbtn.layer setMasksToBounds:YES];
    commitbtn.layer.cornerRadius = 5.0;
    self.commitBtn = commitbtn;
    [self.view addSubview:commitbtn];
}

-(void)chooseFunction
{
//    self.functionBtn.selected = !self.functionBtn.isSelected;
    self.tableView.hidden = !self.tableView.isHidden;
}

-(void)commitClick
{
    NSString *temp = [self.feedbackText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (temp.length == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"请说点什么吧!"];
        return;
    }
    
    NSMutableString *feedbackUrl = [NSMutableString string];
    [feedbackUrl appendString:apiUrl];
    [feedbackUrl appendString:@"pcenter/newfeedback"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    params[@"key"] = key;
    params[@"tq"] = @ (self.intType + 1);
    params[@"txt"] = self.feedbackText.text;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    
    params[@"sign"] = sign;
    
    [params removeObjectForKey:@"key"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求头
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:feedbackUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            self.feedbackText.text = @"";
//            self.numLable.text = @"0/100";
            [SVProgressHUD showSuccessWithStatus:@"提交完成"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
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
                                          NSInteger subLenth = substring.length;
                                          if (idx >= rg.length) {
                                              
                                              *stop = YES; //取出所需要就break，提高效率
                                              
                                              return ;
                                              
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx= idx + subLenth;
                                          
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
    self.tableView.hidden = YES;
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.feedbackText.text.length == 0) {
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
    self.tableView.hidden = YES;
}

#pragma mark - tableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.functionBtn setTitle:self.titleArray[indexPath.row] forState:UIControlStateNormal];
    self.intType = indexPath.row;
    self.tableView.hidden = YES;
}
@end
