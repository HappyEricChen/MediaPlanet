//
//  INGadmentViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/8.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGadmentViewController.h"
#import "INGadMentButton.h"
#import "NSString+INGExtension.h"
#import "NSMutableDictionary+Extension.h"
#import "admentList.h"
#import "adMentCell.h"
//#import "INGadmentInfoViewController.h"
#import "INGadmentInfoView.h"
//#import "INGProductViewController.h"
#import "ProductListViewController.h"
#import "customLayout.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <FLAnimatedImage.h>
#import <UIImageView+WebCache.h>
#import <XZMRefresh.h>
#import "lineView.h"

@interface INGadmentViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *adIcon;
@property (weak, nonatomic) IBOutlet UILabel *adNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *adInfoLable;
//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//@property (weak, nonatomic) IBOutlet UIPageControl *pageView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *moreInfo;
/** 请求数据页数 */
@property (nonatomic, assign) NSInteger pageIndex;
/** 模型数据 */
@property (nonatomic, strong) NSMutableArray *listArray;
/** 广告商的总数 */
@property (nonatomic, assign) NSInteger Total;
/** 当前被选中的广告的序列号 */
@property (nonatomic, assign) NSInteger currentIndex;
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *params;
/** 广告商的编号 */
@property (nonatomic, strong) NSString *AdvertiserNo;

/** icon的高度 */
@property (nonatomic, assign) CGFloat iconHeiht;


@end
static NSString *const adMentID = @"adMentCell";
static NSInteger const pageSize = 16;
static CGFloat const tabBarH = 44;
@implementation INGadmentViewController

-(NSMutableArray *)listArray
{
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
-(NSMutableDictionary *)params
{
    if (_params == nil) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}
-(CGFloat)iconHeiht
{
    if (!_iconHeiht) {
        _iconHeiht = (screenW - 160) *  158 / 201;
    }
    return _iconHeiht;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.width = screenW;
    self.view.height = screenH;
    
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"personal_bg"]];
    bgView.frame = self.view.bounds;
    [self.view insertSubview:bgView atIndex:0];
    self.adIcon.layer.borderWidth = 5.0f;
    self.adIcon.layer.borderColor = JCColor(238, 238, 238).CGColor;
    [self.adIcon.layer setMasksToBounds:YES];

    [self.moreInfo setTitleColor: JCColor(112,176, 255) forState:UIControlStateNormal];

    [self.adNameLabel sizeToFit];
    self.adNameLabel.width += 10;
    self.adNameLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.adNameLabel.layer.borderWidth = 1.0f;
    [self.adNameLabel.layer setMasksToBounds:YES];
    
    self.moreInfo.hidden = YES;
    
//    [self.view setupGifBG];
    self.navigationItem.title = nil;
    
    [self setupCollcetionView];
    [self refresh];
    [self setupNav];
    [self imageViewAddTap];
    
//    lineView *line = [[lineView alloc]init];
//    line.backgroundColor = [UIColor clearColor];
//    line.frame = self.collectionView.frame;
//    [self.collectionView addSubview:line];
    
}

-(void)setupNav
{
    self.navigationItem.title = @"广告商";
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsCompact];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    self.navigationController.navigationBar.clipsToBounds = YES;
}
/** 给图片添加点击手势 */
-(void)imageViewAddTap
{
    self.adIcon.userInteractionEnabled = YES;
    [self.adIcon addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickadIcon:)]];
}
/** 图片的点击事件 */
-(void)clickadIcon:(UITapGestureRecognizer *)gestureRecoginzer
{
    ProductListViewController *productVC = [[ProductListViewController alloc]init];
    productVC.loadType = admentNameType;
    productVC.searchText = self.AdvertiserNo;
    
    [self.navigationController pushViewController:productVC animated:YES];
}

-(void)setupCollcetionView
{

    customLayout *layout = [[customLayout alloc]init];
    
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.backgroundColor = JCColor(238, 238, 238);
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = YES;
//    self.collectionView.showsVerticalScrollIndicator = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([adMentCell class]) bundle:nil] forCellWithReuseIdentifier:adMentID];
//    self.collectionView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
}
-(void)refresh
{

//    [self.collectionView xzm_addNormalHeaderWithTarget:self action:@selector(loadAdment)];
//    [self.collectionView.xzm_header beginRefreshing];

    [self.collectionView xzm_addNormalFooterWithTarget:self action:@selector(loadMoreAdment)];
    
    UIRefreshControl *control = [[UIRefreshControl alloc]init];
//    control.x = 10;
//    control.centerY = self.collectionView.centerY;
    [control addTarget:self action:@selector(loadAdment:) forControlEvents:UIControlEventValueChanged];
//    self.collectionView
    [self.collectionView addSubview:control];
    
    [control beginRefreshing];
    [self loadAdment:control];
    
    
}

#pragma mark - 网络请求数据

/** 加载广告商数据 */
-(void)loadAdment:(UIRefreshControl *)control
{
    [SVProgressHUD showWithStatus:@"加载中……"];
    NSMutableString *adUrl = [NSMutableString string];
    [adUrl appendString:apiUrl];
    [adUrl appendString:@"adcomp/details"];
    self.pageIndex = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageindex"] = @(self.pageIndex);
    params[@"pagesize"] = @(pageSize) ;
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"key"]=  key;//@"4DB03900-7322-4C9C-A5D5-94AD7E8A5703";
    params[@"ts"] = timeSp;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    self.params = params;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    
    [manager POST:adUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [self.collectionView.xzm_header endRefreshing];
        [control endRefreshing];
        [SVProgressHUD dismiss];
        if (self.params != params) return ;
//        NSLog(@"%@",responseObject[@"Results"]);
        BOOL IsSuccess = [responseObject[@"IsSuccess"]boolValue];
        if (IsSuccess) {
            self.collectionView.xzm_header.textColor = [UIColor clearColor];
            self.Total = [responseObject[@"Results"][@"Total"]integerValue];
            NSArray *array = [admentList mj_objectArrayWithKeyValuesArray:responseObject[@"Results"][@"List"]];
            [self.listArray removeAllObjects];
            [self.listArray addObjectsFromArray:array];
            [self.collectionView reloadData];
            if (self.Total < pageSize) {
                self.collectionView.xzm_footer.hidden = YES;
            }else{
                 self.collectionView.xzm_footer.hidden = NO;
            }

            self.pageIndex ++;
            admentList *firstModle = self.listArray[0];
            
            if (firstModle.CompDescH > screenH - (self.collectionView.height+tabBarH + 64 + self.iconHeiht + 10 + firstModle.CompNameH + 15 )) {
                [self.adInfoLable setNumberOfLines: MAX(1,(screenH - (self.collectionView.height+tabBarH  + 64 + self.iconHeiht + 10 + firstModle.CompNameH + 15 + 25)) / 16)];
                self.moreInfo.hidden = NO;
            }else{
                [self.adInfoLable setNumberOfLines: MAX(1,(screenH - (self.collectionView.height+tabBarH  + 64 + self.iconHeiht + 10 + firstModle.CompNameH + 15)) / 16)];
                self.moreInfo.hidden = YES;
            }
            
            [self.adIcon sd_setImageWithURL:[NSURL URLWithString:firstModle.Logo] placeholderImage:[UIImage imageNamed:@"partner_img1"]];
            self.adInfoLable.text = firstModle.CompDesc;
            self.adNameLabel.text = firstModle.CompName;
            self.AdvertiserNo = firstModle.AdvertiserNo;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self.collectionView.xzm_header endRefreshing];
        [SVProgressHUD dismiss];
        [control endRefreshing];
        self.adInfoLable.text = @"网络异常，请稍后重试";
    }];
    
    self.collectionView.xzm_header.updatedTimeHidden = YES;
}
/** 加载更多数据 */
-(void)loadMoreAdment{
    [SVProgressHUD showWithStatus:@"加载中……"];
    NSMutableString *adUrl = [NSMutableString string];
    [adUrl appendString:apiUrl];
    [adUrl appendString:@"adcomp/details"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageindex"] = @(self.pageIndex);
    params[@"pagesize"] = @(pageSize) ;
    //时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    params[@"key"]=  key;//@"4DB03900-7322-4C9C-A5D5-94AD7E8A5703";
    params[@"ts"] = timeSp;
    
    NSString *sign = [NSString sha1String:[params dictKeyAesSortGetValue]];
    params[@"sign"] = sign;
    [params removeObjectForKey:@"key"];
    self.params = params;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:[strStander getOutStandard] forHTTPHeaderField:@"UToken"];
    
    [manager POST:adUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.collectionView.xzm_header endRefreshing];
        [SVProgressHUD dismiss];
        if (self.params != params) return ;
        //        NSLog(@"%@",responseObject[@"Results"]);
        BOOL IsSuccess = [responseObject[@"IsSuccess"]boolValue];
        if (IsSuccess) {
            self.Total = [responseObject[@"Results"][@"Total"]integerValue];
            NSArray *array = [admentList mj_objectArrayWithKeyValuesArray:responseObject[@"Results"][@"List"]];
            [self.listArray addObjectsFromArray:array];
            [self.collectionView reloadData];
            if (self.Total < pageSize * self.pageIndex) {
                [self.collectionView.xzm_footer endRefreshing];
            }else{
                [self.collectionView.xzm_footer endRefreshing];
            }
            
            self.pageIndex ++;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.xzm_footer endRefreshing];
        [SVProgressHUD dismiss];
    }];

}


#pragma mark collcetionView dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;

}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    adMentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:adMentID forIndexPath:indexPath];
    cell.listModle = self.listArray[indexPath.row];
    return cell;
}
#pragma mark -colletionview代理

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    admentList *modle = self.listArray[indexPath.row];
    self.currentIndex = indexPath.row;
    
    if (modle.CompDescH > screenH - (self.collectionView.height +tabBarH  + 64 + self.iconHeiht + 10 + modle.CompNameH + 15 )) {
        [self.adInfoLable setNumberOfLines: MAX(1,(screenH - (self.collectionView.height+tabBarH  + 64 + self.iconHeiht + 10 + modle.CompNameH + 15 + 25)) / 16)];
        self.moreInfo.hidden = NO;
    }else{
        [self.adInfoLable setNumberOfLines: MAX(1,(screenH - (self.collectionView.height+tabBarH  + 64 + self.iconHeiht + 10 + modle.CompNameH + 15)) / 16)];
        self.moreInfo.hidden = YES;
    }
    self.adInfoLable.text = modle.CompDesc;
    self.adNameLabel.text = modle.CompName;
    self.AdvertiserNo = modle.AdvertiserNo;
    [self.adIcon sd_setImageWithURL:[NSURL URLWithString:modle.Logo] placeholderImage:[UIImage imageNamed:@"partner_img1"]];
}
- (IBAction)moreInfoClick:(id)sender {
    INGadmentInfoView *admentInfoView =  [INGadmentInfoView admentInfoView];
    admentInfoView.admentModle = self.listArray[self.currentIndex];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    admentInfoView.frame = window.bounds;
    
    [window addSubview:admentInfoView];

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%s",__func__);
//    CGFloat offsetX = scrollView.contentOffset.x;
//    CGFloat judgeOffsetX = self.collectionView.contentSize.width + self.collectionView.contentInset.right -self.collectionView.width;
//
//    if (offsetX >= judgeOffsetX) {
//        NSLog(@"my love before");
//        [self loadAdment:nil];
//    }

}


@end
