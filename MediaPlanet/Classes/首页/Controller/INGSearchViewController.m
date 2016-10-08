//
//  INGSearchViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/12.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGSearchViewController.h"
#import "INGProductViewController.h"
#import "ProductListViewController.h"
#import "INGSearchField.h"
#import "searchRecord.h"
#import "RecordKey.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJExtension.h>
#import <CoreData/CoreData.h>

@interface INGSearchViewController ()<UITextFieldDelegate>
/** 搜索框 */
@property (nonatomic, strong) INGSearchField *searchField;
/** lable */
@property (nonatomic, strong) UILabel *nearLable;

/** 搜索记录按钮数组 */
@property (nonatomic, strong) NSMutableArray *buttonArray;
/** 搜索的历史记录数组 */
@property (nonatomic, strong) NSMutableArray *recordArray;

/** 当前搜索的关键字 */
@property (nonatomic, strong) NSString *searchKeyWord;

/** 查询数据的上下文 */
@property (nonatomic, strong) NSManagedObjectContext *context;
/** 数据模型 */
@property (nonatomic, strong) NSManagedObjectModel *coreModle;

@end

static NSInteger const searchMaxLenth = 50;

@implementation INGSearchViewController
-(NSMutableArray *)buttonArray
{
    if (_buttonArray == nil) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}
-(NSMutableArray *)recordArray
{
    if (_recordArray == nil) {
        _recordArray = [NSMutableArray array];
    }
    return _recordArray;
}

-(NSManagedObjectModel *)coreModle
{
    if (_coreModle == nil) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"recordWords" withExtension:@"momd"];
        // 从应用程序包中加载模型文件
        _coreModle = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
        
    }
    return _coreModle;
}

-(NSManagedObjectContext *)context
{
    if (_context == nil) {
        // 传入模型对象，初始化NSPersistentStoreCoordinator
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.coreModle];
        // 构建SQLite数据库文件的路径
        NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"RecordKey.data"]];
        // 添加持久化存储库，这里使用SQLite作为存储库
        NSError *error = nil;
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
        
        if (store == nil) { // 直接抛异常
            [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
        }
        // 初始化上下文，设置persistentStoreCoordinator属性
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        _context.persistentStoreCoordinator = psc;

    }
    return _context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self.view setupGifBG];
//    self.view.backgroundColor = JCColor(238, 238, 238);
    [self.searchField becomeFirstResponder];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
//    NSString *homeDirectory = NSHomeDirectory();
//    NSLog(@"homeDirectory path :%@", homeDirectory);
    
    if ([strStander getOutStandard]) {
        
        [self searchRecord];
    }else{

        [self selectRecord];

        [self showKeyWord];
    }
}
//初始化界面
-(void)setup
{
    //设置中间搜索框
    INGSearchField *searchField = [INGSearchField searchField];
    searchField.textColor = [UIColor whiteColor];
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.width = screenW - 100;
    searchField.height = 30;
    searchField.x = 45;
    searchField.y = 30;
    searchField.font = [UIFont systemFontOfSize:15];
    // 创建一个富文本对象
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    // 设置富文本对象的颜色
    attributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    //设置占位文字和他的颜色
    searchField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"媒体星球" attributes:attributes];
    searchField.delegate = self;
    [self.view addSubview:searchField];
    self.searchField = searchField;
    //添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:nil];
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:fontSize];
    [cancelButton setBackgroundColor:[UIColor clearColor]];
    cancelButton.x = CGRectGetMaxX(searchField.frame);
    cancelButton.y = 30;
    cancelButton.height = 30;
    cancelButton.width = screenW - cancelButton.x;
    
    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    //最近搜索
    UILabel *nearLabel = [[UILabel alloc]init];
    nearLabel.text = @"最近搜索";
    nearLabel.textAlignment = NSTextAlignmentLeft;
    nearLabel.textColor = [UIColor whiteColor];
    nearLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:fontSize];
    nearLabel.x = searchField.x;
    nearLabel.y = CGRectGetMaxY(searchField.frame) + 20;
    nearLabel.width = 200;
    nearLabel.height = 30;
    self.nearLable = nearLabel;
    [self.view addSubview:nearLabel];
    
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake((screenW - 100) * 0.5, CGRectGetMaxY(nearLabel.frame) + 150, 100, 30);
    [clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearButton setTitle:@"清除历史记录" forState:UIControlStateNormal];
    [clearButton setImage:[UIImage imageNamed:@"search_delete"] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];
    clearButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [self.view addSubview:clearButton];
}

/** 显示搜索记录 */
-(void)showKeyWord
{
    if ([NSString isMemberLogin]) {
        
        for (searchRecord *modle in self.recordArray) {
            [self addSearchTagTitle:modle.Keyword];
        }
        [self updateButtonFrame];
    }else{
        for (NSString *str in self.recordArray) {
            [self addSearchTagTitle:str];
        }
        [self updateButtonFrame];
    }

}
/** 清除历史记录 */
-(void)clearClick
{
    [SVProgressHUD showWithStatus:@"清除中"];
    if ([strStander getOutStandard]) {
        
        NSMutableString *searchUrl =[NSMutableString string];
        [searchUrl appendString:apiUrl];
        [searchUrl appendString:@"products/clearwords"];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"key"]=  key;//@"4DB03900-7322-4C9C-A5D5-94AD7E8A5703";
        //时间戳
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        params[@"ts"] = timeSp;
        
        NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
        params[@"sign"] = sign;
        [params removeObjectForKey:@"key"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
        
        [manager POST:searchUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            for (UIButton *button in self.buttonArray) {
                [button removeFromSuperview];
            }
            [self.buttonArray removeAllObjects];
            [self.recordArray removeAllObjects];
            
            [UIView animateWithDuration:0.25 animations:^{
                [self updateButtonFrame];
            }];
            [SVProgressHUD showSuccessWithStatus:@"清除完成"];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }];
    
    }else{

        [self deleteRecord];
        for (UIButton *button in self.buttonArray) {
            [button removeFromSuperview];
        }
        [self.buttonArray removeAllObjects];
        [self.recordArray removeAllObjects];
        [UIView animateWithDuration:0.25 animations:^{
            [self updateButtonFrame];
        }];
        [SVProgressHUD showSuccessWithStatus:@"清除完成"];
    }
    
   
}
//添加搜索记录
-(void)addSearchTagTitle:(NSString*)string
{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.backgroundColor = [UIColor clearColor];
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 1.0f;
    [button.layer setCornerRadius:5.0];
    [button.layer setMasksToBounds:YES];
    [button setTitle:string forState:UIControlStateNormal];
    [button sizeToFit];
    button.width += 10;
    if (button.width > screenW - self.nearLable.x * 2) {
        button.width = screenW - self.nearLable.x * 2;
    }
    button.height = 25;
    [button addTarget:self action:@selector(searchRecordClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.buttonArray addObject:button];
    [self updateButtonFrame];
}
/** 点击记录按钮，直接开始搜索 */
-(void)searchRecordClick:(UIButton *)button
{
    self.searchField.text = button.currentTitle;
    [self textFieldShouldReturn:self.searchField];
    
}
//跟新按钮的frame
-(void)updateButtonFrame
{
    for (int i = 0 ; i < self.buttonArray.count; i++) {
        UIButton *button = self.buttonArray[i];
        
        if (i == 0) {
            button.x = self.nearLable.x;
            button.y = CGRectGetMaxY(self.nearLable.frame);
            
        }else{
            UIButton *lastButton = self.buttonArray[i - 1];
            if (self.view.width - CGRectGetMaxX(lastButton.frame)- self.nearLable.x > button.width + 10) {
                button.x = CGRectGetMaxX(lastButton.frame) + 5;
                button.y = lastButton.y;
                
            }else{
                button.x = self.nearLable.x;
                button.y = CGRectGetMaxY(lastButton.frame) + 5;
                
            }
        }
    }

}
/** 查询搜索记录 */
-(void)searchRecord
{
    [SVProgressHUD showWithStatus:@"加载中"];
    if ([strStander getOutStandard]) {
        NSMutableString *searchUrl =[NSMutableString string];
        [searchUrl appendString:apiUrl];
        [searchUrl appendString:@"products/keywords"];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"cnt"] = @ 5;
        params[@"key"]=  key;//@"4DB03900-7322-4C9C-A5D5-94AD7E8A5703";
        //时间戳
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        params[@"ts"] = timeSp;
        
        NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
        params[@"sign"] = sign;
        [params removeObjectForKey:@"key"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
        
        [manager POST:searchUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            [SVProgressHUD dismiss];
            //        BOOL IsSuccess = responseObject[@"IsSuccess"];
            //        if (IsSuccess) {
            [self.recordArray removeAllObjects];
            NSArray *array = [searchRecord mj_objectArrayWithKeyValuesArray:responseObject[@"Results"]];
            [self.recordArray addObjectsFromArray:array];
            [self showKeyWord];
            //        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
        }];

    }else{
        [SVProgressHUD dismiss];
//        NSLog(@"%s",__func__);
    }
    
}
/** 搜索详情 */
-(void)searchInfo
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSMutableString *searchInfoUrl =[NSMutableString string];
    [searchInfoUrl appendString:apiUrl];
    [searchInfoUrl appendString:@"products/searchwords"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"txt"] = self.searchField.text;
    NSString *cityName = [CityNameKey getOutStandard];
    params[@"city"] = cityName;
    params[@"pageindex"] = @ 1;
    params[@"pagesize"] = @ 10;
    params[@"key"]=  key;//@"4DB03900-7322-4C9C-A5D5-94AD7E8A5703";
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    
    [manager POST:searchInfoUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [SVProgressHUD dismiss];
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {

        }else{
            self.searchField.text = @"";
            [SVProgressHUD showInfoWithStatus:responseObject[@"ErrorMessage"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.searchField.text = @"";
        [SVProgressHUD dismiss];
//        NSLog(@"%@",error);
    }];
    
}
#pragma mark - core data
/** 添加数据 */
-(void)addData
{
    // 传入上下文，创建一个Person实体对象
     RecordKey *recordKey = [NSEntityDescription insertNewObjectForEntityForName:@"RecordKey" inManagedObjectContext:self.context];
    // 设置Person的简单属性
    [recordKey setValue:self.searchKeyWord forKey:@"keyWord"];
    [recordKey setValue:[NSDate date] forKey:@"addDate"];
//    recordKey.keyWord = self.searchKeyWord;
    // 利用上下文对象，将数据同步到持久化存储库
    NSError *error = nil;
    BOOL success = [self.context save:&error];
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
    }

    // 如果是想做更新操作：只要在更改了实体对象的属性后调用[context save:&error]，就能将更改的数据同步到数据库
}
/** 查询数据库中是否有相同的数据，如果有就删掉之前的，把现在搜索的添加到数据库中 */
-(void)selectOneRecord
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RecordKey"];
    // 设置要查询的实体
    request.entity = [NSEntityDescription entityForName:@"RecordKey" inManagedObjectContext:self.context];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"keyWord=%@", self.searchKeyWord]];
    // 执行请求
    NSError *error = nil;
    NSArray *objs = [self.context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        return;
    }
    if (objs.count>0) {
        // 遍历数据
        for (NSManagedObject *obj in objs) {
//            NSLog(@"keyWord=%@,adddate = %@", [obj valueForKey:@"keyWord"],[obj valueForKey:@"addDate"]);
//            NSString *str = [NSString stringWithFormat:@"%@",[obj valueForKey:@"keyWord"]];
            [self.context deleteObject:obj];
        }
        [self.context save:&error];
    }
    
}
/** 查询所有的数据 */
-(NSArray *)selectRecord
{
    // 初始化一个查询请求
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RecordKey"];
    // 设置要查询的实体
    request.entity = [NSEntityDescription entityForName:@"RecordKey" inManagedObjectContext:self.context];
    // 设置排序（按照keyWord降序）//addDate
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"addDate" ascending:NO];

    request.sortDescriptors = [NSArray arrayWithObject:sort];
    
//    request.fetchLimit = 5;
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"keyWord like %@", @"*"]];//@"keyWord like %@", @"*A*"
//    // 设置条件过滤(搜索name中包含字符串"Itcast-1"的记录，注意：设置条件过滤时，数据库SQL语句中的%要用*来代替，所以%Itcast-1%应该写成*Itcast-1*)
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"*Itcast-1*"];
//    request.predicate = predicate;
    // 执行请求
    NSError *error = nil;
    NSArray *objs = [self.context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    [self.recordArray removeAllObjects];
    // 遍历数据
    NSInteger i = 0;
    for (NSManagedObject *obj in objs) {
//        NSLog(@"keyWord=%@,adddate = %@", [obj valueForKey:@"keyWord"],[obj valueForKey:@"addDate"]);
        i++;
        if (i <= 5) {
            
            NSString *str = [NSString stringWithFormat:@"%@",[obj valueForKey:@"keyWord"]];
            [self.recordArray addObject:str];
        }else{
            [self.context deleteObject:obj];
        }
        
    }

    return objs;
}
/** 删除所有记录 */
-(void)deleteRecord
{
    
    // 传入需要删除的实体对象
    NSArray *array = [self selectRecord];
    for (NSManagedObject *obj in array) {
        
        [self.context deleteObject:obj];
    }
    // 将结果同步到数据库
    NSError *error = nil;
    [self.context save:&error];
    if (error) {
        [NSException raise:@"删除错误" format:@"%@", [error localizedDescription]];
    }
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
            if(toBeString.length > searchMaxLenth) {
                textField.text = [toBeString substringToIndex:searchMaxLenth];
                [SVProgressHUD showInfoWithStatus:@"最多50个字符，超出最大范围了"];
            }
        }
        //有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if(toBeString.length > searchMaxLenth) {
            textField.text= [toBeString substringToIndex:searchMaxLenth];
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
    
    if (self.searchField == textField )  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > searchMaxLenth) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:searchMaxLenth];
            
            [SVProgressHUD showInfoWithStatus:@"最多50个字符，超出最大范围了"];
            return NO;
        }
    }
    return YES;
}


/** 点击键盘的搜索 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.searchKeyWord = [self.searchField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([self.searchField hasText] && self.searchKeyWord.length) {
        if (![strStander getOutStandard]){
            [self selectOneRecord];
            [self addData];
        }
        self.searchField.text = @"";
        
        [self dismissViewControllerAnimated:NO completion:nil];
        ProductListViewController *productVC = [[ProductListViewController alloc]init];
//        INGProductViewController *productVC = [[INGProductViewController alloc]init];
        productVC.loadType = SearchProductType;
        productVC.searchText = self.searchKeyWord;
        UITabBarController *root = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *nav = (UINavigationController *)root.selectedViewController;
        [nav pushViewController:productVC animated:NO];
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"请输入搜索内容"];
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)cancelClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
