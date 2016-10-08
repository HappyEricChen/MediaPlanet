//
//  INGMeTableViewController.m
//  媒体星球
//
//  Created by jamesczy on 16/5/31.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  我的页面（个人中心）

#import "INGMeTableViewController.h"
#import "INGMesCell.h"
#import "personalInfo.h"
#import "INGPersonaHeaderView.h"
#import "pCenterInfoModle.h"
#import "NSString+INGExtension.h"
#import "INGMyListTableViewController.h"
#import "INGCollectListViewController.h"
#import "INGCertificationViewController.h"
#import "INGContractViewController.h"
#import "INGMeIfoTableViewController.h"
#import "INGConnectUsTableViewController.h"
#import "INGSettingTableViewController.h"
#import "INGPushMessageRecordViewController.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import <Photos/Photos.h>
#import <MJExtension.h>
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import <SVProgressHUD.h>

@interface INGMeTableViewController ()<UITableViewDelegate,UITableViewDataSource,INGPersonaHeaderViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/** 标题数组 */
@property (nonatomic, strong) NSArray *titleArray;
/** icon数组 */
@property (nonatomic, strong) NSArray *imgArray;
/** 模型数组 */
@property (nonatomic, strong) NSMutableArray *infoArray;
/** 数组 */
@property (nonatomic, strong) NSArray *personaArray;

/** tableView */
@property (nonatomic, strong) UITableView *tableView;

/** 服务器返回的会员信息 */
@property (nonatomic, strong) pCenterInfoModle *pCenterModle;

/** tableView的HeaderView */
@property (nonatomic, strong) INGPersonaHeaderView *headerView;

/** 上传的参数 */
@property (nonatomic, strong) NSMutableDictionary *params;

/** 搜藏的总数 */
@property (nonatomic, assign) NSInteger total;

@end

static NSString * const cellID = @"cellID";

@implementation INGMeTableViewController
/** 懒加载 */
-(NSArray *)titleArray
{
    if (_titleArray == nil) {
        _titleArray = @[@"我的订单",@"我的收藏",@"申请认证",@"合同模板",@"个人信息",@"联系我们"];
    }
    return _titleArray;
}

-(NSArray *)imgArray
{
    if (_imgArray == nil) {
        _imgArray = @[@"personal_1",@"personal_2",@"personal_3",@"personal_4",@"personal_5",@"personal_6"];
    }
    return _imgArray;
}
-(NSMutableArray *)infoArray
{
    if (_infoArray == nil) {
        _infoArray = [NSMutableArray array];
        for (int i = 0; i < self.imgArray.count; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"headerIcon"] = self.imgArray[i];
            dic[@"titleText"] = self.titleArray[i];
            [_infoArray addObject:dic];
        }
    }
    return _infoArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setupGifBG];
    [self setupNav];
    [self setupTabView];
    
    [self refresh];
    
    self.personaArray = [personalInfo mj_objectArrayWithKeyValuesArray:self.infoArray];

}
//-(void)viewWillAppear:(BOOL)animated{
//    [self refresh];
//}
-(void)setupNav
{
    self.navigationItem.title = @"个人中心";
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsCompact];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
//    self.navigationController.navigationBar.clipsToBounds = YES;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"setting" highImage:@"setting" target:self action:@selector(setting)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"message" highImage:@"message" target:self action:@selector(messageRecord)];
//    self.navigationController.delegate = self;
    
}
-(void)setupTabView
{
    self.tableView = [[UITableView alloc]init];
    self.tableView.x = 0;
    self.tableView.y = 64;
    self.tableView.width = screenW;
    self.tableView.height = screenH - 64 - 44;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //设置headerView
    INGPersonaHeaderView *headerView = [[INGPersonaHeaderView alloc]init];
    headerView.modle = self.pCenterModle;
    headerView.delegate = self;
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([INGMesCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 50;
    [self.view addSubview:self.tableView];
}
/** 设置界面 */
-(void)setting
{
    [SVProgressHUD show];
//    NSLog(@"%s",__func__);
    INGSettingTableViewController *settingView = [[INGSettingTableViewController alloc]init];
    [self.navigationController pushViewController:settingView animated:YES];
}
/** 消息记录 */
-(void)messageRecord
{
    INGPushMessageRecordViewController *pushVC = [[INGPushMessageRecordViewController alloc]init];
    pushVC.title = @"消息中心";
    [self.navigationController pushViewController:pushVC animated:YES];
}
-(void)refresh
{
    [SVProgressHUD show];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadPcenterInfo)];
    [self.tableView.mj_header beginRefreshing];
//    [self loadCollectCount];
}
/** 加载搜藏的数量 */
-(void)loadCollectCount
{
    
    NSMutableString *listUrl = [NSMutableString string];
    [listUrl appendString:apiUrl];
    [listUrl appendString:@"pcenter/querycols"];
   
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageindex"] = @ (1);
    params[@"pagesize"] = @(1);
    params[@"key"] = key;
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    self.params = params;
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:listUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.tableView.mj_header endRefreshing];
//        NSLog(@"%@",responseObject);
        //如果请求返回的参数不等请求之前的参数，就不做处理
        if (self.params != params) return ;

        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            self.total = [responseObject[@"Results"][@"Total"] integerValue];
        }else{
            self.total = 0;
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [SVProgressHUD showErrorWithStatus:@"请求数据出错"];
        if (self.params != params) return ;
        
    }];
    //    self.tableView.mj_footer.hidden = NO;
    [self.tableView.mj_footer endRefreshing];
}

/** 加载个人中心的数据 */
-(void)loadPcenterInfo
{
    [self.tableView.mj_header endRefreshing];
    NSMutableString *loadUrl = [NSMutableString string];
    [loadUrl appendString:apiUrl];
    [loadUrl appendString:@"pcenter/pdata"];
    
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
    
    [manager POST:loadUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        [SVProgressHUD showSuccessWithStatus:@"加载完成"];
         self.pCenterModle = [pCenterInfoModle mj_objectWithKeyValues:responseObject[@"Results"]];
        self.headerView.modle = self.pCenterModle;
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络异常，请稍后重试"];
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
        
        NSData *imageData1 = UIImageJPEGRepresentation(self.headerView.headerView.image, 0.1);

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
            [SVProgressHUD showInfoWithStatus:@"上传成功"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (self.params != params) return ;
//        NSLog(@"error = %@",[error description]);
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    INGMesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.info = self.personaArray[indexPath.row];
//    if (indexPath.row == 1) {
//        cell.info.titleText = [NSString stringWithFormat:@"%@(%ld)",self.titleArray[indexPath.row],(long)self.total];
//    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        INGMyListTableViewController *vc = [[INGMyListTableViewController alloc]init];

        vc.title = self.titleArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        INGCollectListViewController *vc = [[INGCollectListViewController alloc]init];
        
        vc.title = self.titleArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 2){
        INGCertificationViewController *vc = [[INGCertificationViewController alloc]init];
        vc.title = self.titleArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 3){
        INGContractViewController *vc = [[INGContractViewController alloc]init];
        vc.title = self.titleArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];

    }else if (indexPath.row == 4){
        INGMeIfoTableViewController *vc = [[INGMeIfoTableViewController alloc]init];
        vc.title = self.titleArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    
    }else if (indexPath.row == 5){
        INGConnectUsTableViewController *vc = [[INGConnectUsTableViewController alloc]init];
        vc.title = self.titleArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        UIViewController *vc = [[UIViewController alloc]init];
        [vc.view setupGifBG];
        vc.title = self.titleArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
}
#pragma mark - 头部代理

-(void)loadPersonHeaderView:(INGPersonaHeaderView *)INGPersonaHeaderView
{
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
            ipc.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil];
            
            self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:ipc animated:YES completion:nil];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请在iPhone的\"设置-隐私-相机\"中允许访问相机"];
    }
    
}
                                   
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.headerView.headerView.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self updataHeaderIcon];
    
    [self refresh];
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
@end
