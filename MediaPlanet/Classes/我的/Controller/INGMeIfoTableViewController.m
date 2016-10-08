//
//  INGMeIfoTableViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/3.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  个人信息界面

#import "INGMeIfoTableViewController.h"
#import "INGMeInfoCell.h"
#import "INGAlterNickViewController.h"
#import "INGAlterViewController.h"
#import "INGAlterSexViewController.h"
#import "INGDatePickerView.h"
#import "INGGenderPicker.h"
#import "INGNavigationController.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import "information.h"
#import <Photos/Photos.h>
#import <MJExtension.h>
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import <SVProgressHUD.h>

@interface INGMeIfoTableViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,INGDatePickerViewDelegate,INGGenderPickerDelegate>
//,UIPickerViewDataSource,UIPickerViewDelegate
/** infoTileArray */
@property (nonatomic, strong) NSArray *infoArray;

/** tableView */
@property (nonatomic, strong) UITableView *tableView;

/** 日期选择界面 */
@property (nonatomic, strong) INGDatePickerView *pickerView;
/** 性别选择界面 */
@property (nonatomic, strong) INGGenderPicker *genderPicker;

/** 头像图片 */
@property (nonatomic, strong) UIImage *headerImage;
/** 生日 */
@property (nonatomic, strong) NSString *birthDay;
/** 昵称 */
@property (nonatomic, strong) NSString *nick;
/** 性别 */
@property (nonatomic, strong) NSString *gender;

/** 个人信息 */
@property (nonatomic, strong) information *infoModle;
/** 上传的参数 */
@property (nonatomic, strong) NSMutableDictionary *params;
/** 上传图片返回的参数 */
@property (nonatomic, strong) NSString *picStr;

/** 性别数组 */
//@property (nonatomic, strong) NSArray *genderArray;

/** 编辑按钮 */
@property (nonatomic, strong) UIButton *editButton;


@end

static NSString *const MeinfoCell = @"MeinfoCell";

@implementation INGMeIfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.birthDay = @"2001-01-01";
//    [self setup];
    [self.view setupGifBG];
    [self setupTableview];

//    self.genderArray = @[@"男",@"女"];
    self.infoArray = @[@"头像",@"昵称",@"性别",@"生日",@"修改密码",@"手机号码"];
    [self setupNav];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setupRefresh];
}
-(void)setupNav
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.size = CGSizeMake(50, 30);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [rightButton setTitle:@"完成" forState:UIControlStateSelected];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton addTarget:self action:@selector(updateNikeName) forControlEvents:UIControlEventTouchUpInside];
    self.editButton = rightButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];

}

-(void)setupTableview
{
    self.tableView = [[UITableView alloc]init];
    self.tableView.x = 0;
    self.tableView.y = 64;
    self.tableView.width = screenW;
    self.tableView.height = screenH - 64;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView setBackgroundColor:JCColor(238, 238, 238)];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([INGMeInfoCell class]) bundle:nil] forCellReuseIdentifier:MeinfoCell];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    [self setupRefresh];
}
-(void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadInfo)];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 6;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    INGMeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:MeinfoCell];
    cell.info = self.infoModle;
    cell.infoTitleLable.text = self.infoArray[indexPath.row];

    
    cell.infoHeaderView.hidden = YES;
    cell.infoLable.hidden = NO;
    cell.rightView.hidden = NO;
    cell.phoneNumLable.hidden = YES;
    if (indexPath.row == 0) {
        cell.infoLable.hidden = YES;
        cell.infoHeaderView.hidden = NO;
        cell.rightView.hidden = YES;

    }else if (indexPath.row == 1){
        cell.infoLable.text = self.infoModle.MemberName;
    }else if (indexPath.row == 2){
        cell.infoLable.text = self.infoModle.Gender == YES ? @"女" : @"男";
    }else if (indexPath.row == 3){
        cell.infoLable.text = self.infoModle.Birth;
    }else if (indexPath.row == 4){
        cell.infoLable.hidden = YES;
    }else if (indexPath.row == 5){
//        cell.infoLable.text = @"13800001234";
        cell.infoLable.hidden = YES;
        cell.phoneNumLable.hidden = NO;
        cell.phoneNumLable.text = [self.infoModle.Phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
//        cell.infoLable.x = CGRectGetMaxX(cell.rightView.frame) - cell.rightView.width;
        cell.rightView.hidden = YES;
    }
    return cell;
}

-(void)commitInfo
{
    
//    [self updataHeaderIcon];
    
}
-(void)updateNikeName
{
    NSLog(@"%s",__func__);
    self.editButton.selected = !self.editButton.isSelected;
}

/** 查询会员资料 */
-(void)loadInfo
{
    
    NSMutableString *infoUrl = [NSMutableString string];
    [infoUrl appendString:apiUrl];
    [infoUrl appendString:@"pcenter/qmember"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    params[@"key"] = key;
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    
    params[@"sign"] = sign;
    
    [params removeObjectForKey:@"key"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求头
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:infoUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            self.infoModle = [information mj_objectWithKeyValues:responseObject[@"Results"]];
            self.birthDay = self.infoModle.Birth;
//            [SVProgressHUD showSuccessWithStatus:@""];
        }else{
            [SVProgressHUD showInfoWithStatus:@"您还不是会员，请先注册登录。"];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
    
}
/** 修改会员资料 */
-(void)updataInfo
{
    NSMutableString *infoUrl = [NSMutableString string];
    [infoUrl appendString:apiUrl];
    [infoUrl appendString:@"pcenter/editmember"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"nick"] = nil;
    params[@"gender"] = nil;
    params[@"birth"] = self.birthDay;
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    
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
            [self setupRefresh];
            [SVProgressHUD showSuccessWithStatus:@"修改完成"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
}
/** 上传头像 */
-(void)updataHeaderIcon
{
    /**
     上传类型
     E0721087-D232-47C6-9875-33C44EAD165D	认证申请
     35184E61-2895-402E-A166-D4E63ABBA6BA	会员头像
     */

    [SVProgressHUD showWithStatus:@"上传中"];
//    NSString *uploadURL = @"http://112.64.131.222/mediaservice/upload.ashx";
    
    NSMutableString *uploadURL = [NSMutableString string];
    NSString *uploadStr = [apiUrl substringToIndex:[apiUrl length] - 4];
    [uploadURL appendString:uploadStr];
    [uploadURL appendString:@"upload.ashx"];
    
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager setSecurityPolicy:securityPolicy];
    
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"image/jpeg",@"text/json",@"application/json",@"text/javascript",@"text/html",@"text/plain", nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"category"] = @"35184E61-2895-402E-A166-D4E63ABBA6BA";
    
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    params[@"key"] = key;
    params[@"utk"] = [strStander getOutStandard];
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    //删除不需要上传的参数
    [params removeObjectForKey:@"key"];
    [params removeObjectForKey:@"utk"];
    self.params = params;
    [manager POST:uploadURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData1 = UIImageJPEGRepresentation(self.headerImage, 0.1);
        if (imageData1 != nil) {
            
            [formData appendPartWithFileData:imageData1 name:@"filedata" fileName:@"test.jpg"mimeType:@"image/jpeg"]; //multipart/form-data
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if (self.params != params) return ;
//        NSLog(@"%@",responseObject);
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            self.picStr = responseObject[@"Results"];
            [SVProgressHUD showSuccessWithStatus:@"上传完成"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (self.params != params) return ;
        NSLog(@"error = %@",[error description]);
    }];

}


#pragma mark - Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 64.0f;
    }else{
        return 48.0f;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        
        UIAlertController *alertVC = [[UIAlertController alloc]init];
        
        UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"本地相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self openAlbum];
        }];
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self openCamera];

        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:photoAction];
        [alertVC addAction:cameraAction];
        [alertVC addAction:cancleAction];
        
        [self presentViewController:alertVC animated:YES completion:nil];

    }else if (indexPath.row == 1 ) {
        INGAlterNickViewController *nickVc = [[INGAlterNickViewController alloc]init];
        [self.navigationController pushViewController:nickVc animated:YES];

    }else if (indexPath.row == 1){
        if (self.editButton.isSelected == YES) {
            
        }
    }else if (indexPath.row == 2){

        [self setUpGenderPicker];
    }else if (indexPath.row == 3){
        [self setupDateView:DateTypeOfStart];
    }
    else if (indexPath.row == 4){
        INGAlterViewController *vc = [[INGAlterViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
#pragma mark - 日期控件
- (void)setupDateView:(DateType)type {
    self.pickerView = [INGDatePickerView instanceDatePickerView];
    self.pickerView.frame = [UIScreen mainScreen].bounds;
    if (self.infoModle.Birth != nil) {
        if (![self.infoModle.Birth isEqualToString:@""]) {
            NSDateFormatter *df = [[NSDateFormatter alloc]init];//格式化
            [df setDateFormat:@"yyyy-MM-dd"];
            self.pickerView.datePickerView.date = [df dateFromString:self.infoModle.Birth];
        }
        
    }
    self.pickerView.delegate = self;
    self.pickerView.Datetype = type;
    [self.view addSubview:_pickerView];
}

- (void)getSelectDate:(NSString *)date type:(DateType)type {
    
    switch (type) {
        case DateTypeOfStart:
            // TODO 日期确定选择
            
            self.birthDay = [NSString stringWithFormat:@"%@",date];
            self.infoModle.Birth = self.birthDay;
            
            [self updataInfo];
            
            break;
            
        case DateTypeOfEnd:
            // TODO 日期取消选择
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}
#pragma mark - 性别选择器
-(void)setUpGenderPicker
{
    self.genderPicker = [INGGenderPicker instanceGenderPickerView];
    self.genderPicker.frame = [UIScreen mainScreen].bounds;
    self.genderPicker.delegate = self;
    
    if (self.gender != nil) {
        
    }
    [self.view addSubview:_genderPicker];
}
-(void)getSelectGender:(NSString *)gender
{
    self.gender = gender;
//    NSLog(@"我的选择：%@",self.gender);
    self.infoModle.Gender = [gender isEqualToString:@"女"] ? YES :  NO;
    [self.tableView reloadData];
}
#pragma mark - 相册
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 70, 30);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    viewController.navigationItem.rightBarButtonItem = rightItem;
}
-(void)cancelClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//打开相册
-(void)openAlbum
{
    if ([self isHaveAlbumAuthority]) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) return;
        UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
        
        ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        ipc.delegate = self;
        ipc.allowsEditing = YES;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:ipc animated:YES completion:nil];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请在iPhone的\"设置-隐私-相册\"中允许访问相册"];
    }

    
}
//打开相机
-(void)openCamera
{
    if ([self isHaveCameraAuthority]) {
        
        UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
            ipc.sourceType = sourcheType;
            ipc.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            ipc.delegate = self;
            ipc.allowsEditing = YES;
            self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:ipc animated:YES completion:nil];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请在iPhone的\"设置-隐私-相机\"中允许访问相机"];
    }
   
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.headerImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self updataHeaderIcon];

    [self setupRefresh];
}

#pragma mark --  判断对相册和相机的使用权限
/**
 *  相册的使用权限
 *
 *  @return 是否
 */
-(BOOL)isHaveAlbumAuthority{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
    
}
/**
 *  相机的使用权限
 *
 *  @return 是否
 */
-(BOOL)isHaveCameraAuthority{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}
/*
#pragma mark - 性别选择器

-(void)setUpGenderPicker
{
    UIPickerView *genderPicker = [[UIPickerView alloc]init];
    genderPicker.frame = CGRectMake(0, screenH - 100, screenW, 100);
    genderPicker.delegate = self;
    genderPicker.dataSource = self;
    genderPicker.showsSelectionIndicator = YES;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"确定" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(done:)];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, self.view.frame.size.height-
                                     genderPicker.frame.size.height-30, screenW, 30)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    NSArray *toolbarItems = [NSArray arrayWithObjects: 
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    [self.view addSubview:genderPicker];
    [self.view addSubview:toolBar];
}
-(void)done:(UIBarButtonItem *)button
{
    
}
#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return [self.genderArray count];
}
#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    self.gender = self.genderArray[row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    return [self.genderArray objectAtIndex:row];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont systemFontOfSize:16];
    titleLable.text = self.genderArray[row];
    return titleLable;
}
 */
@end
