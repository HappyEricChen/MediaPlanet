//
//  INGMapViewController.m
//  MediaPlanet
//
//  Created by jamesczy on 16/6/17.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGMapViewController.h"
#import "productInfo.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <CoreLocation/CoreLocation.h>

//高度APIKEY
#define LBSAPIKEY @"92153914f24d72b25053a653c1d66224"

@interface INGMapViewController ()<MAMapViewDelegate,AMapSearchDelegate>
{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
}
@property(nonatomic,strong)CLGeocoder *geocoder;
/** 经度 */
@property (nonatomic, assign) CLLocationDegrees latitude;
/** 纬度 */
@property (nonatomic, assign) CLLocationDegrees longitude;
///** 地图 */
//@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation INGMapViewController

-(void)initMapView
{
    [MAMapServices sharedServices].apiKey = LBSAPIKEY;
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 64, screenW, screenH - 64)];
    _mapView.delegate = self;
    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, 22);
    _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, 22);
    [self.view addSubview:_mapView];

}
-(void)initMapSearch
{
    //初始化检索对象
    [AMapSearchServices sharedServices].apiKey = LBSAPIKEY;
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //构造AMapGeocodeSearchRequest对象，address为必选项，city为可选项
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = self.infoModle.DetailProductLoc;
    
    //发起正向地理编码
    [_search AMapGeocodeSearch: geo];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = [UIScreen mainScreen].bounds;
    [self.view setupGifBG];
    self.navigationItem.title = @"定位地址";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"left"] style:UIBarButtonItemStyleDone target:self action:@selector(cancelClick)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [self initMapView];
    
    [self addressToLocation];
    
}
- (void)pointInMapView
{
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    pointAnnotation.title = self.infoModle.ProductName;
    pointAnnotation.subtitle = self.infoModle.DetailProductLoc;
    
    [_mapView addAnnotation:pointAnnotation];
}
/** 把地址转为经纬度 */
-(void)addressToLocation
{
    self.geocoder = [[CLGeocoder alloc]init];
    
    [self.geocoder geocodeAddressString:self.infoModle.DetailProductLoc completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
            
            CLPlacemark * placemark = [placemarks firstObject];
            self.latitude = placemark.location.coordinate.latitude;
            self.longitude = placemark.location.coordinate.longitude;
        }
        
        [self initMapSearch];
        [self pointInMapView];
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
        
    }];
}

-(void)cancelClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 高德T地图地址编码
/**
 *  地址编码，根据传入的地址，在地图上显示位置
 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorRed;
        return annotationView;
    }
    return nil;
}

/*
//实现正向地理编码的回调函数
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if(response.geocodes.count == 0)
    {
        return;
    }
    
    //通过AMapGeocodeSearchResponse对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld", (long)response.count];
    NSString *strGeocodes = @"";
    for (AMapTip *p in response.geocodes) {
        strGeocodes = [NSString stringWithFormat:@"%@\ngeocode: %@", strGeocodes, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@", strCount, strGeocodes];
    NSLog(@"Geocode: %@", result);
}

*/
@end
