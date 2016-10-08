//
//  INGTabBarController.m
//  媒体星球
//
//  Created by jamesczy on 16/5/30.
//  Copyright © 2016年 jamesczy. All rights reserved.
//

#import "INGTabBarController.h"
#import "INGNavigationController.h"
#import "INGHomeController.h"
//#import "INGMeTableViewController.h"
#import "INGPersonalViewController.h"
#import "INGProductViewController.h"
#import "ProductListViewController.h"
#import "INGadmentViewController.h"
#import "INGLoginViewController.h"

#import "INGTabBar.h"


@interface INGTabBarController ()

@end

@implementation INGTabBarController

+(void)initialize{
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    NSMutableDictionary *selecetedAttrs = [NSMutableDictionary dictionary];
    selecetedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selecetedAttrs[NSForegroundColorAttributeName] = JCColor(112,176, 255);
    //通过appearance统一设置tabbarItem 的文字属性
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selecetedAttrs forState:UIControlStateSelected];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加自控制器
    [self setUpChildVc:[[INGHomeController alloc]init] title:@"首页" image:@"tab_home" selectedImage:@"tab_home_click"];
//    INGProductViewController *productVC = [[INGProductViewController alloc]init];
    ProductListViewController *productVC = [[ProductListViewController alloc]init];
    productVC.loadType = NormalProductType;
    [self setUpChildVc:productVC title:@"产品" image:@"tab_product" selectedImage:@"tab_product_click"];
    [self setUpChildVc:[[INGadmentViewController alloc]init] title:@"广告商" image:@"tab_partner" selectedImage:@"tab_partner_click"];
 
    [self setUpChildVc:[[INGPersonalViewController alloc]init] title:@"我的" image:@"tab_personal" selectedImage:@"tab_personal_click"];
    
    //替换系统的UItabBar
    [self setValue:[[INGTabBar alloc]init] forKey:@"tabBar"];
    //设置tabBar为透明背景
    UIImage *barBackgroundImage = [UIImage imageNamed:@"tab_bg"];
    self.tabBar.backgroundImage = [self imageCompressForWidth:barBackgroundImage targetWidth:screenW];
    
    
    self.tabBar.shadowImage = [[UIImage alloc] init];
}

-(void)setupBgView
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextClipToRect(context, rect);
//    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
    
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tab_bg"]];

}

-(void)setUpChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.navigationItem.title = title;
    
    vc.tabBarItem.title = title;
//    vc.title = title;
    
    CGFloat currentVersion = [[[UIDevice currentDevice]systemVersion]floatValue];
    if (currentVersion >= 8.0) {
        vc.tabBarItem.image = [UIImage imageNamed:image];
    }else
    {
        vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
//    vc.view.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0];
    INGNavigationController *nav = [[INGNavigationController alloc]initWithRootViewController:vc];
    
    [self addChildViewController:nav];
}
/** 指定宽度按比例缩放 */
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
//    NSLog(@"%@",item.title);
    if ([item.title isEqualToString:@"我的"]) {
        if (![NSString isMemberLogin]) {
            INGLoginViewController *loginVC = [[INGLoginViewController alloc]init];
            INGNavigationController *nav = [[INGNavigationController alloc]initWithRootViewController:loginVC];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
        }
    }
}


@end
