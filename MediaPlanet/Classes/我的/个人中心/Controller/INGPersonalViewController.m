//
//  INGPersonalViewController.m
//  MediaPlanet
//
//  Created by eric on 16/9/12.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGPersonalViewController.h"
#import "INGPersonalDataViewController.h"
#import "FirstCollectionViewCell.h"
#import "SecondCollectionViewCell.h"
#import "ThirdCollectionViewCell.h"

#import "INGMyListTableViewController.h"
#import "INGCollectListViewController.h"
#import "INGCertificationViewController.h"
#import "INGContractViewController.h"
#import "INGMeIfoTableViewController.h"
#import "INGConnectUsTableViewController.h"
#import "INGSettingTableViewController.h"
#import "INGPushMessageRecordViewController.h"
#import "INGFeedbackViewController.h"

#import "INGLoginViewController.h"
#import "INGNavigationController.h"
#import "pCenterInfoModle.h"

#import <Photos/Photos.h>
#import <MJRefresh.h>
#import <MJExtension.h>


@interface INGPersonalViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SecondCollectionViewCellDelegate,ThirdCollectionViewCellDelegate,FirstCollectionViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) INGPersonalDataViewController* iNGPersonalDataViewController;

/** 服务器返回的会员信息 */
@property (nonatomic, strong) pCenterInfoModle *pCenterModle;

/** 请求参数 */
@property (nonatomic, strong) NSDictionary *params;
/** 选择的图片 */
@property (nonatomic, strong) UIImage *chooseImage;

@end

@implementation INGPersonalViewController

-(NSDictionary *)params
{
    if (_params == nil) {
        _params = [NSDictionary dictionary];
    }
    return _params;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.iNGPersonalDataViewController = [[INGPersonalDataViewController alloc]init];
   [self configureCollectionView];
    
    self.navigationItem.title = @"个人中心";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"personal_message" highImage:@"personal_message" target:self action:@selector(messageRecord)];
    [self setupRefresh];
}

- (void)configureCollectionView
{
    [self.view addSubview:self.iNGPersonalDataViewController.collectionView];
    
    self.iNGPersonalDataViewController.collectionView.delegate = self;
    self.iNGPersonalDataViewController.collectionView.dataSource = self;
    
    self.iNGPersonalDataViewController.collectionView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topEqualToView(self.view).bottomEqualToView(self.view);
}


/** 消息记录 */
-(void)messageRecord
{
    INGPushMessageRecordViewController *pushVC = [[INGPushMessageRecordViewController alloc]init];
    pushVC.title = @"消息中心";
    [self.navigationController pushViewController:pushVC animated:YES];
}



#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCollectionViewCell * cell;
    id object = nil;
    if (indexPath.section == 0)
    {
        FirstCollectionViewCell * firstCell = [FirstCollectionViewCell collectionView:collectionView forIndexPath:indexPath];
        object = self.pCenterModle;//传头像和标题
        firstCell.delegate = self;
        cell = firstCell;
    }
    else if (indexPath.section == 1)
    {
        SecondCollectionViewCell * secondCell = [SecondCollectionViewCell collectionView:collectionView forIndexPath:indexPath];
        secondCell.delegate = self;
        cell =secondCell;
    }
    else if (indexPath.section == 2)
    {
        ThirdCollectionViewCell * thirdCell = [ThirdCollectionViewCell collectionView:collectionView forIndexPath:indexPath];
        thirdCell.delegate = self;
        cell =thirdCell;
    }
    
    [cell layoutWithObject:object];
    return cell;
}

#pragma mark - UICollectionViewFlowLayoutDelegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return CGSizeMake(screenW, screenW*0.5);
    }
    else if (indexPath.section == 1)
    {
        return CGSizeMake(screenW, screenH*0.442);
    }
    else if (indexPath.section == 2)
    {
        return CGSizeMake(screenW, screenH*0.17);
    }
    return CGSizeZero;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 2)
    {
        return UIEdgeInsetsMake(10, 0, 0, 0);
    }
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark -SecondCollectionViewCellDelegate 代理方法
-(void)didClickMyOrderButton:(SecondCollectionViewCell *)secondCollectionViewCell
{
    //我的订单
    INGMyListTableViewController *vc = [[INGMyListTableViewController alloc]init];
    vc.title = @"我的订单";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)didClickMyCollectionButton:(SecondCollectionViewCell *)secondCollectionViewCell
{
    //我的收藏
    INGCollectListViewController *vc = [[INGCollectListViewController alloc]init];
    vc.title = @"我的收藏";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)didClickCertificationButton:(SecondCollectionViewCell *)secondCollectionViewCell
{
    //申请认证
    INGCertificationViewController *vc = [[INGCertificationViewController alloc]init];
    vc.title = @"我的收藏";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)didClickContractButton:(SecondCollectionViewCell *)secondCollectionViewCell
{
    //合同模板
    INGContractViewController *vc = [[INGContractViewController alloc]init];
    vc.title = @"合同模板";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)didClickPersonalInformationButton:(SecondCollectionViewCell *)secondCollectionViewCell
{
    //个人信息
    INGMeIfoTableViewController *vc = [[INGMeIfoTableViewController alloc]init];
    vc.title = @"个人信息";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)didClickFeedbackButton:(SecondCollectionViewCell *)secondCollectionViewCell
{
    //意见反馈
    INGFeedbackViewController *vc = [[INGFeedbackViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -ThirdCollectionViewCellDelegate 代理方法
-(void)didClickThirdContactUsButton:(ThirdCollectionViewCell *)thirdCollectionViewCell
{
    //联系我们
    NSString *phoneStr = @"13681704531";//
    NSMutableString *phone = [[NSMutableString alloc]initWithFormat:@"telprompt://%@",phoneStr];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
}
-(void)didClickThirdLogoutButton:(ThirdCollectionViewCell *)thirdCollectionViewCell
{
    //退出登录
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出" message:@"你确定退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"你点击了确定");
        [self outLoginShow];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/** 初始化刷新控件 */

-(void)setupRefresh
{
    [SVProgressHUD show];
    self.iNGPersonalDataViewController.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadPcenterInfo)];
    [self.iNGPersonalDataViewController.collectionView.mj_header beginRefreshing];
    
}

#pragma mark - 加载个人中心数据
/** 加载个人中心的数据 */
-(void)loadPcenterInfo
{
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
    
    [manager POST:loadUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        //        NSLog(@"%@",responseObject);
        [self.iNGPersonalDataViewController.collectionView.mj_header endRefreshing];
        [SVProgressHUD showSuccessWithStatus:@"加载完成"];
        self.pCenterModle = [pCenterInfoModle mj_objectWithKeyValues:responseObject[@"Results"]];
        
        [self.iNGPersonalDataViewController.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络异常，请稍后重试"];
        [self.iNGPersonalDataViewController.collectionView.mj_header endRefreshing];
    }];
}
//退出登录
-(void)outLoginShow
{
    //删除已存在的账号信息
    
    //账号的key
    NSString *userKey = @"CFBundleUserNameString";
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:userKey];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:strStander];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //发出退出通知
    [[NSNotificationCenter defaultCenter]postNotificationName:INGUserLoginOrOutNotification object:nil];
    
    [SVProgressHUD showInfoWithStatus:@"您已退出登录"];
    //跳转到登录界面
    
    INGLoginViewController *loginViewController = [[INGLoginViewController alloc]init];
    //    loginViewController.navigationItem.hidesBackButton = YES;
    //    [self.navigationController pushViewController:loginViewController animated:YES];
    INGNavigationController *nav = [[INGNavigationController alloc]initWithRootViewController:loginViewController];
    
    [self presentViewController:nav animated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
    
}

#pragma mark - 点击更换头像
-(void)didClickIconImageButton:(FirstCollectionViewCell *)firstCollectionViewCell
{
    //头像选择上传
    [self loadPersonHeaderView];
}

-(void)loadPersonHeaderView
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
    self.chooseImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self updataHeaderIcon];

    [self setupRefresh];
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
        
        NSData *imageData1 = UIImageJPEGRepresentation(self.chooseImage, 0.1);
        
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
