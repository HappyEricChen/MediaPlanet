//
//  INGCertificationViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/3.
//  Copyright © 2016年 jamesczy. All rights reserved.
//  申请认证界面

#import "INGCertificationViewController.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import "certificationInfo.h"
#import <MJExtension.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <Photos/Photos.h>
#import <UIImageView+WebCache.h>
#import <TZImagePickerController.h>

#define margin 20
#define fontSize 14

@interface INGCertificationViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate,UITextFieldDelegate,TZImagePickerControllerDelegate>
@property (weak, nonatomic)  UIScrollView *scrollView;
@property (weak, nonatomic)  UITextField *comNameText;
@property (weak, nonatomic)  UITextField *addressText;
@property (weak, nonatomic)  UITextField *contactName;

@property (weak, nonatomic)  UITextField *phoneNumText;
@property (weak, nonatomic)  UITextField *telephoneText;

/** 上传图片的提示框 */
@property (nonatomic, weak) UITextField *tipText;

@property (weak, nonatomic)  UIImageView *licenseView;
@property (weak, nonatomic)  UIImageView *callCardView;

@property (weak, nonatomic) UILabel *capionLable;

/** 当前点击的imageView */
@property (nonatomic, weak) UIImageView *currentImageView;
/** 当前参数 */
@property (nonatomic, strong) NSDictionary *params;
/** 上传图片返回的数组 */
@property (nonatomic, strong) NSMutableArray *resultArray;
///** 给返回的数组添加逗号后的字符串 */
//@property (nonatomic, strong) NSMutableString *paramsPic;

///** 请选择图片LABLE */
//@property (nonatomic, strong) UILabel *chooseLable;

/** 添加图片的按钮 */
@property (nonatomic, strong) UIButton *addPhotosBtn;
/** 选择的图片View数组 */
@property (nonatomic, strong) NSMutableArray *photosViewArray;
/** 图片数组 */
@property (nonatomic, strong) NSMutableArray *imageArray;
/** 每个图片自带的删除按钮 */
@property (nonatomic, strong) NSMutableArray *deleteBtnArray;

/** 申请认证模型 */
@property (nonatomic, strong) certificationInfo *certificationModle;

@end

static NSInteger const companyMaxLenth = 50;
static NSInteger const addressMaxLenth = 50;
static NSInteger const linkmanMaxLenth = 15;
static NSInteger const phoneMaxLenth = 11;
static NSInteger const telMaxLenth = 20;
/** 允许上传的图片最大值 */
static NSInteger const MaxNumber = 10;

@implementation INGCertificationViewController
-(NSMutableArray *)photosViewArray
{
    if (_photosViewArray == nil) {
        _photosViewArray = [NSMutableArray array];
    }
    return _photosViewArray;
}

-(NSMutableArray *)imageArray
{
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

-(NSMutableArray *)deleteBtnArray
{
    if (_deleteBtnArray == nil) {
        _deleteBtnArray = [NSMutableArray array];
    }
    return _deleteBtnArray;
}

-(NSMutableArray*)resultArray
{
    if (_resultArray == nil) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self setupNav];
    [self selecteAuditState];
    self.currentImageView.image = nil;
}
/** 初始化 */
-(void)setup
{
    [self.view setupGifBG];
//    self.view.frame = [UIScreen mainScreen].bounds;
     UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.delegate = self;
    scrollView.width = screenW;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.bounces = YES;
    scrollView.frame = CGRectMake(0, 64, screenW, screenH - 64);
    scrollView.contentSize = CGSizeMake(0, screenH + 20);
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    // 创建一个富文本对象
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    // 设置富文本对象的颜色
    attributes[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    UILabel *capionLable = [[UILabel alloc]init];
    capionLable.backgroundColor = [UIColor clearColor];
    capionLable.textColor = [UIColor redColor];
    capionLable.font = [UIFont systemFontOfSize:14];
    capionLable.textAlignment = NSTextAlignmentCenter;
    capionLable.numberOfLines = 3;
    capionLable.text = @"认证申请已提交，请等待审核";
    capionLable.width = screenW;
    capionLable.height = 52;
    capionLable.x = 0;
    capionLable.y = 5;
    self.capionLable = capionLable;
    [self.scrollView addSubview:capionLable];
    self.capionLable.hidden = YES;
    /*
    capionLable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:capionLable
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1
                                                           constant:20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:capionLable
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1
                                                           constant:-20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:capionLable
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:64]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:capionLable
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeHeight
                                                               multiplier:1
                                                                 constant:25]];
     */
    //设置占位文字和他的颜色
    UITextField *comNameText = [[UITextField alloc]init];
    comNameText.frame = CGRectMake(20, CGRectGetMaxY(capionLable.frame), screenW - 2 * 20, 30);
    comNameText.tintColor = [UIColor blackColor];
    comNameText.font = [UIFont systemFontOfSize:fontSize];
    comNameText.textColor = [UIColor blackColor];
    comNameText.delegate = self;
    //设置占位图片
    UIImageView *comPlaceholderImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"certification_1"]];
    CGSize placehoderSize = CGSizeMake(30, 30);
    comPlaceholderImage.size = placehoderSize;
    comPlaceholderImage.contentMode = UIViewContentModeCenter;
    comNameText.leftView = comPlaceholderImage;
    comNameText.leftViewMode = UITextFieldViewModeAlways;
    
    self.comNameText = comNameText;
    [self.scrollView addSubview:comNameText];
    UIImageView *comLine = [[UIImageView alloc]init];
    comLine.backgroundColor = JCColor(238, 238, 238);
    comLine.frame = CGRectMake(20, CGRectGetMaxY(comNameText.frame), screenW - 20, 1);
    [self.scrollView addSubview:comLine];
    self.comNameText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入公司名字" attributes:attributes];
    UITextField *addressText = [[UITextField alloc]init];
    addressText.tintColor = [UIColor blackColor];
    addressText.font = [UIFont systemFontOfSize:fontSize];
    addressText.textColor = [UIColor blackColor];
    addressText.frame = CGRectMake(20, CGRectGetMaxY(self.comNameText.frame)+ margin,screenW - 2 * 20, 30);
    addressText.delegate = self;
    
    //设置占位图片
    UIImageView *addressPlaceholderImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"certification_2"]];
    addressPlaceholderImage.size = placehoderSize;
    addressPlaceholderImage.contentMode = UIViewContentModeCenter;
    addressText.leftView = addressPlaceholderImage;
    addressText.leftViewMode = UITextFieldViewModeAlways;
    
    self.addressText = addressText;
    self.addressText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入公司地址" attributes:attributes];
    [scrollView addSubview:addressText];
    UIImageView *addLine = [[UIImageView alloc]init];
    addLine.backgroundColor = JCColor(238, 238, 238);
    addLine.frame = CGRectMake(20, CGRectGetMaxY(addressText.frame), screenW - 2 * 20, 1);
    [self.scrollView addSubview:addLine];
    
    UITextField *contactName = [[UITextField alloc]init];
    contactName.tintColor = [UIColor blackColor];
    contactName.font = [UIFont systemFontOfSize:fontSize];
    contactName.textColor = [UIColor blackColor];
    contactName.frame = CGRectMake(20, CGRectGetMaxY(self.addressText.frame)+ margin,screenW - 2 * 20, 30);
    contactName.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入联系人姓名" attributes:attributes];
    contactName.delegate = self;
    
    //设置占位图片
    UIImageView *contactPlaceholderImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"certification_3"]];
    contactPlaceholderImage.size = placehoderSize;
    contactPlaceholderImage.contentMode = UIViewContentModeCenter;
    contactName.leftView = contactPlaceholderImage;
    contactName.leftViewMode = UITextFieldViewModeAlways;
    
    self.contactName = contactName;
    [self.scrollView addSubview:self.contactName];
    UIImageView *contentLine = [[UIImageView alloc]init];
    contentLine.backgroundColor = JCColor(238, 238, 238);
    contentLine.frame = CGRectMake(20, CGRectGetMaxY(contactName.frame), screenW - 2* 20, 1);
    [self.scrollView addSubview:contentLine];
    
    
    UITextField *phoneNumText = [[UITextField alloc]init];
    phoneNumText.tintColor = [UIColor blackColor];
    phoneNumText.font = [UIFont systemFontOfSize:fontSize];
    phoneNumText.textColor = [UIColor blackColor];
    phoneNumText.frame = CGRectMake(20, CGRectGetMaxY(self.contactName.frame)+margin, screenW -2 *20, 30);
    phoneNumText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入手机号" attributes:attributes];
    phoneNumText.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumText.delegate = self;
    
    //设置占位图片
    UIImageView *phoneNumPlaceholderImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"certification_4"]];
    phoneNumPlaceholderImage.size = placehoderSize;
    phoneNumPlaceholderImage.contentMode = UIViewContentModeCenter;
    phoneNumText.leftView = phoneNumPlaceholderImage;
    phoneNumText.leftViewMode = UITextFieldViewModeAlways;
    
    self.phoneNumText = phoneNumText;
    [self.scrollView addSubview:phoneNumText];
    UIImageView *phoneLine = [[UIImageView alloc]init];
    phoneLine.backgroundColor = JCColor(238, 238, 238);
    phoneLine.frame = CGRectMake(20, CGRectGetMaxY(phoneNumText.frame), screenW - 2 * 20, 1);
    [self.scrollView addSubview:phoneLine];
    
    UITextField *telephoneText = [[UITextField alloc]init];
    telephoneText.tintColor = [UIColor blackColor];
    telephoneText.font = [UIFont systemFontOfSize:fontSize];
    telephoneText.textColor = [UIColor blackColor];
    telephoneText.frame = CGRectMake(20, CGRectGetMaxY(self.phoneNumText.frame) + margin, screenW - 2 * 20, 30);
    telephoneText.keyboardType = UIKeyboardTypeNumberPad;
    telephoneText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入公司电话" attributes:attributes];
    telephoneText.delegate = self;
    
    //设置占位图片
    UIImageView *telePhonePlaceholderImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"certification_5"]];
    telePhonePlaceholderImage.size = placehoderSize;
    telePhonePlaceholderImage.contentMode = UIViewContentModeCenter;
    telephoneText.leftView = telePhonePlaceholderImage;
    telephoneText.leftViewMode = UITextFieldViewModeAlways;
    
    self.telephoneText = telephoneText;
    [self.scrollView addSubview:telephoneText];
    UIImageView *telePhoneLine = [[UIImageView alloc]init];
    telePhoneLine.backgroundColor = JCColor(238, 238, 238);
    telePhoneLine.frame = CGRectMake(20, CGRectGetMaxY(telephoneText.frame), screenW -2 * 20, 1);
    [self.scrollView addSubview:telePhoneLine];
    //添加分隔线
    UIImageView *splitlineView = [[UIImageView alloc]init];
    splitlineView.backgroundColor = JCColor(238, 238, 238);
    splitlineView.x = 0;
    splitlineView.y = CGRectGetMaxY(telePhoneLine.frame)+ margin;
    splitlineView.width = screenW;
    splitlineView.height = 10;
    
    [self.scrollView addSubview:splitlineView];
    
    //添加照片
    /*
    UILabel *addPhotoLable = [[UILabel alloc]init];
    addPhotoLable.font = [UIFont systemFontOfSize:fontSize];
    addPhotoLable.backgroundColor = [UIColor clearColor];
    addPhotoLable.textColor = [UIColor blackColor];
    addPhotoLable.frame = CGRectMake(20, CGRectGetMaxY(self.telephoneText.frame) + margin, screenW - 2 * 20, 25);
    addPhotoLable.textAlignment = NSTextAlignmentLeft;
    addPhotoLable.text = @"请上传认证资料（营业执照、图片等）:";
    self.chooseLable = addPhotoLable;
    [self.scrollView addSubview:addPhotoLable];
    */
    
    UITextField *tipText = [[UITextField alloc]init];
    tipText.tintColor = [UIColor blackColor];
    tipText.font = [UIFont systemFontOfSize:fontSize];
    tipText.textColor = [UIColor blackColor];
    tipText.frame = CGRectMake(20, CGRectGetMaxY(splitlineView.frame) + margin, screenW - 2 * 20, 30);
    tipText.keyboardType = UIKeyboardTypeNumberPad;
    tipText.text = @"请上传认证资料（营业执照、图片等）:";
    tipText.enabled = NO;
    
    //设置占位图片
    UIImageView *tipPlaceholderImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"certification_6"]];
    tipPlaceholderImage.size = placehoderSize;
    tipPlaceholderImage.contentMode = UIViewContentModeCenter;
    tipText.leftView = tipPlaceholderImage;
    tipText.leftViewMode = UITextFieldViewModeAlways;
    self.tipText = tipText;
    [self.scrollView addSubview:tipText];
    
    //添加➕按钮
    UIButton *addPhotosBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat addBtnWH = (screenW - 2 * self.tipText.x - 2 * 10) / 3;

    addPhotosBtn.width = addBtnWH;
    addPhotosBtn.height = addBtnWH;
    
    [addPhotosBtn setBackgroundImage:[UIImage imageNamed:@"certification_7"] forState:UIControlStateNormal];
    [addPhotosBtn addTarget:self action:@selector(openAlertShow) forControlEvents:UIControlEventTouchUpInside];
    addPhotosBtn.x = tipText.x;
    addPhotosBtn.y = CGRectGetMaxY(self.tipText.frame) + 10;
    self.addPhotosBtn = addPhotosBtn;
    [self.scrollView addSubview:addPhotosBtn];

    
    //添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.comNameText];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.addressText];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.contactName];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.phoneNumText];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.telephoneText];
}

-(void)setupNav
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(login)];
    self.navigationItem.rightBarButtonItem  = rightItem;
}


/** 重写导航栏 */
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

#pragma mark - 相机相册操作
/** 弹出相册、相机选择控制器 */
-(void)openAlertShow
{
    UIAlertController *alertVC = [[UIAlertController alloc]init];
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(MaxNumber - self.photosViewArray.count) delegate:self];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"本地相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //        [self openAlbum];
        if ([self isHaveAlbumAuthority]) {
            
            
            [self presentViewController:imagePickerVc animated:YES completion:nil];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"请在iPhone的\"设置-隐私-相册\"中允许访问相册"];
            
        }
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

////打开相册
//-(void)openAlbum
//{
//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) return;
//    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
//    
//    ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    
//    ipc.delegate = self;
//    
//    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    
//    ipc.allowsEditing = YES;
//    [self presentViewController:ipc animated:YES completion:nil];
//    
//}
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
            ipc.allowsEditing = NO;
            self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:ipc animated:YES completion:nil];
            
        }
    }else{
        
        [SVProgressHUD showErrorWithStatus:@"请在iPhone的\"设置-隐私-相机\"中允许访问相机"];
        
    }
    
}

/** 跟新按钮的frame */
-(void)updateSubViewFrame
{
    NSInteger count = self.photosViewArray.count;
    if (count >= MaxNumber) {
        self.addPhotosBtn.hidden = YES;
    }else{
        self.addPhotosBtn.hidden = NO;
        
    }
    int maxCols = 3;
    CGFloat phtotoMargin = 10;
    CGFloat imageViewW = (screenW - 2 * self.tipText.x - 2 * phtotoMargin) / maxCols;
    CGFloat imageViewH = imageViewW;
    
    NSInteger maxRows = count / maxCols == 0 ? count / maxCols : count / maxCols + 1;
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.tipText.frame) + maxRows * (imageViewH + phtotoMargin) + 20);
    
    for (int i = 0 ; i < count; i++) {
        UIImageView *imageView = self.photosViewArray[i];
        imageView.tag = 1000 + i;
        NSInteger rows = i / maxCols ;
        imageView.y = rows * (imageViewH + phtotoMargin) + CGRectGetMaxY(self.tipText.frame) + phtotoMargin;
        NSInteger cols = i % maxCols ;
        imageView.x = cols * (imageViewW + phtotoMargin) + self.tipText.x;
        imageView.width = imageViewW;
        imageView.height = imageViewH;
        imageView.contentMode = UIViewContentModeScaleToFill;
        
        UIButton *button = self.deleteBtnArray[i];
        button.tag = 1100 + i;
        [button setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:imageView];
        
        button.width = 20;
        button.height = 20;
        button.x = imageView.x + imageViewW - button.width + phtotoMargin * 0.5;
        button.y = imageView.y - phtotoMargin * 0.5;
        
        [self.scrollView addSubview:button];
        
    }
    if (count % maxCols == 0) {
        self.addPhotosBtn.x = self.tipText.x + (count % maxCols) * (imageViewW + phtotoMargin);
        self.addPhotosBtn.y = CGRectGetMaxY(self.tipText.frame) + phtotoMargin + (count / maxCols) * (imageViewH + phtotoMargin);
    }else{
        
        self.addPhotosBtn.x = self.tipText.x + (count % maxCols) * (imageViewW + phtotoMargin);
        self.addPhotosBtn.y = CGRectGetMaxY(self.tipText.frame) + phtotoMargin + (count / maxCols) * (imageViewH + phtotoMargin);
    }
    CGFloat contentY = MAX(screenH + 20, CGRectGetMaxY(self.addPhotosBtn.frame)+20);
    self.scrollView.contentSize = CGSizeMake(0, contentY);
}

-(void)deletePhoto:(UIButton *)button
{
    [button removeFromSuperview];
    NSInteger deleteTag = button.tag - 1100;
    [self.photosViewArray[deleteTag] removeFromSuperview];
    [self.photosViewArray removeObjectAtIndex:(deleteTag)];
    [self.deleteBtnArray removeObjectAtIndex:deleteTag];
    [UIView animateWithDuration:0.3 animations:^{
        [self updateSubViewFrame];
        
    }];
}
#pragma mark - 选择相册控制器的代理
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
//    [self.photosViewArray removeAllObjects];
//    [self.imageArray removeAllObjects];
    
//    [self.imageArray addObjectsFromArray:photos];
    for (UIImage *image in photos) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.contentMode = UIViewContentModeCenter;
        [self.photosViewArray addObject:imageView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteBtnArray addObject:button];
        
    }
    [self updateSubViewFrame];
}

#pragma mark - 判断输入

/** 申请认证 */
-(void)login
{
    if ([self.comNameText.text isEqualToString:@""] ||[self.addressText.text isEqualToString:@""]||[self.comNameText.text isEqualToString:@""] || [self.phoneNumText.text isEqualToString:@""]|| [self.telephoneText.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"输入的内容不能为空"];
        return;
    }else if (![self isMobile:self.phoneNumText.text]){
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }else if(!self.photosViewArray.count){
        [SVProgressHUD showInfoWithStatus:@"请选择图片"];
        return;
    }else{
        
        [self applyAuth];
    }
    
    
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
    NSString * CT = @"^1((33|53|8[019]|7(0-9))[0-9]|349)\\d{7}$";
    
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

#pragma mark - 网络数据请求

/** 申请认证资料 */
-(void)applyAuth
{
    NSMutableString *applyUrl = [NSMutableString string];
    [applyUrl appendString:apiUrl];
    [applyUrl appendString:@"pcenter/newaudit"];
    
//    [self.paramsArray removeAllObjects];
//    self.paramsPic = [NSMutableString string];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"comp"] = self.comNameText.text;
    params[@"address"] = self.addressText.text;
    params[@"contact"] = self.contactName.text;
    params[@"tel"] = self.telephoneText.text;
    params[@"phone"] = self.phoneNumText.text;
    
//    params[@"pic"] = [self.resultArray mj_JSONString];
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    params[@"key"] = key;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    
    [params removeObjectForKey:@"key"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:applyUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"info:%@",responseObject);
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            
            [self updataImage];
            
        }else{
            [SVProgressHUD showSuccessWithStatus:responseObject[@"ErrorMessage"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"信息发送出错"];
    }];
}
/** 上传图片 */
-(void)updataImage
{
    /**
     上传类型
     E0721087-D232-47C6-9875-33C44EAD165D	认证申请
     35184E61-2895-402E-A166-D4E63ABBA6BA	会员头像
     */
    [SVProgressHUD showWithStatus:@"上传中"];
    NSMutableString *uploadURL = [NSMutableString string];
    NSString *uploadStr = [apiUrl substringToIndex:[apiUrl length] - 4];
    [uploadURL appendString:uploadStr];
    [uploadURL appendString:@"upload.ashx"];
//    NSString *uploadURL = @"http://112.64.131.222/mediaservice/upload.ashx";//mediaplanet_service
    
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager setSecurityPolicy:securityPolicy];
    
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"image/jpeg",@"text/json",@"application/json",@"text/javascript",@"text/html",@"text/plain", nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"category"] = @"E0721087-D232-47C6-9875-33C44EAD165D";
    
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

//        NSData *imageData1 = UIImageJPEGRepresentation(self.licenseView.image, 0.5);
//        NSData *imageData2 = UIImageJPEGRepresentation(self.callCardView.image, 0.5);
//        if (imageData1 != nil && imageData2 != nil) {
//            
//            [formData appendPartWithFileData:imageData1 name:@"filedata" fileName:@"license.jpg"mimeType:@"image/jpeg"]; //multipart/form-data
//            [formData appendPartWithFileData:imageData2 name:@"filedata" fileName:@"card.jpg"mimeType:@"image/jpeg"];
//        }
        for (int i = 0; i < self.photosViewArray.count; i++) {
            UIImageView *imageView = self.photosViewArray[i];
            NSData *imageData = UIImageJPEGRepresentation(imageView.image, 0.1);
            [formData appendPartWithFileData:imageData name:@"filedata" fileName:@"image.jpg"mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if (self.params != params) return ;
        NSLog(@"image:%@",responseObject);
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        if (IsSuccess) {
            [self.resultArray removeAllObjects];
            NSArray *array = responseObject[@"Results"];
            [self.resultArray addObjectsFromArray:array];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showSuccessWithStatus:responseObject[@"ErrorMessage"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (self.params != params) return ;
        NSLog(@"error = %@",error);
        [SVProgressHUD showErrorWithStatus:@"图片发送错误"];
    }];
}

/** 查询审核状态 */
-(void)selecteAuditState
{
    NSMutableString *applyUrl = [NSMutableString string];
    [applyUrl appendString:apiUrl];
    [applyUrl appendString:@"/pcenter/qaudit"];
    
    //    [self.paramsArray removeAllObjects];
    //    self.paramsPic = [NSMutableString string];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //    params[@"pic"] = [self.resultArray mj_JSONString];
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"ts"] = timeSp;
    params[@"key"] = key;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    
    [params removeObjectForKey:@"key"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    [manager POST:applyUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"info:%@",responseObject);
        BOOL IsSuccess = [responseObject[@"IsSuccess"] boolValue];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        if (IsSuccess) {
            /**
             1	审核不通过
             2	审核通过
             3	待审核
             返回其他的状态可以提交申请
             */
            certificationInfo *modle = [certificationInfo mj_objectWithKeyValues:responseObject[@"Results"]];
            self.certificationModle = modle;
            NSInteger resultsStatus = modle.RegSt;
            [SVProgressHUD showSuccessWithStatus:@"加载完成"];
//            resultsStatus = 2;
            [self.view setUserInteractionEnabled:YES];
            if (resultsStatus == 3) {
                self.capionLable.hidden = NO;
                self.navigationItem.rightBarButtonItem.enabled = NO;
            }else if (resultsStatus == 1){
                self.capionLable.text = @"审核不通过,请重新提交,原因如下:";
                self.capionLable.hidden = NO;
            }else if (resultsStatus == 2){
                self.capionLable.text = @"审核已通过";
                self.capionLable.hidden = NO;
                self.navigationItem.rightBarButtonItem.enabled = NO;
                [self.view setUserInteractionEnabled:NO];
            }else{
                self.capionLable.hidden = YES;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateCertificateView];
            
            });
        }else{
            self.navigationItem.rightBarButtonItem.enabled = YES;
            self.capionLable.hidden = YES;
            
            [SVProgressHUD showInfoWithStatus:@"请提交审核资料"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"信息发送出错"];
    }];
}
-(void)updateCertificateView
{
    self.comNameText.text = self.certificationModle.CompName;
    self.addressText.text = self.certificationModle.CompDetailAddress;
    self.phoneNumText.text = self.certificationModle.ContactPhone;
    self.telephoneText.text = self.certificationModle.ContactTel;
    self.contactName.text = self.certificationModle.Contact;
    if (self.certificationModle.RegSt == 1) {
        
        self.capionLable.text = [NSString stringWithFormat:@"审核不通过,请重新提交,原因如下:%@",self.certificationModle.AuditMemo];
        self.capionLable.numberOfLines = 0;
        
    }
    if (self.certificationModle.Pics.count > 0) {
        for (int i = 0; i < self.certificationModle.Pics.count; i++) {
            
            UIImageView *imageView = [[UIImageView alloc]init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.certificationModle.Pics[i]] placeholderImage:[UIImage imageNamed:@"pic_img"]];
            [self.photosViewArray addObject:imageView];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.deleteBtnArray addObject:button];
        }
        [self updateSubViewFrame];
    }
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    self.currentImageView.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self.photosViewArray addObject:imageView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteBtnArray addObject:button];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self updateSubViewFrame];
    }];
    
}

#pragma mark - ScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    NSLog(@"%s",__func__);
    [self.view endEditing:YES];
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
            if(toBeString.length > addressMaxLenth) {
                textField.text = [toBeString substringToIndex:addressMaxLenth];
                [SVProgressHUD showInfoWithStatus:@"最多50个字符，超出最大范围了"];
            }
        }
        //有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if(toBeString.length > addressMaxLenth) {
            textField.text= [toBeString substringToIndex:addressMaxLenth];
        }
    }
}
#pragma mark - textFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.comNameText == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > companyMaxLenth) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:companyMaxLenth];
            
            [SVProgressHUD showInfoWithStatus:@"最多50个字符，超出最大范围了"];
            return NO;
        }
    }else if (self.addressText == textField)
    {
        if ([toBeString length] > addressMaxLenth) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:addressMaxLenth];
            
            [SVProgressHUD showInfoWithStatus:@"最多50个字符，超出最大范围了"];
            return NO;
        }
    }else if (self.contactName == textField)
    {
        if ([toBeString length] > linkmanMaxLenth) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:linkmanMaxLenth];
            
            [SVProgressHUD showInfoWithStatus:@"最多15个字符，超出最大范围了"];
            return NO;
        }
    }else if (self.phoneNumText == textField)
    {
        if ([toBeString length] > phoneMaxLenth) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:phoneMaxLenth];
            
            [SVProgressHUD showInfoWithStatus:@"最多11个字符，超出最大范围了"];
            return NO;
        }
    }else if (self.telephoneText == textField)
    {
        if ([toBeString length] > telMaxLenth) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:telMaxLenth];
            
            [SVProgressHUD showInfoWithStatus:@"最多20个字符，超出最大范围了"];
            return NO;
        }
    }
    return YES;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
}
@end
