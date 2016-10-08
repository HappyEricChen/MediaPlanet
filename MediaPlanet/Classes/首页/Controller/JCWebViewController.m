//
//  JCWebViewController.m
//  百思不得哥
//
//  Created by jamesczy on 16/5/3.
//  Copyright © 2016年 yingyi. All rights reserved.
//

#import "JCWebViewController.h"

@interface JCWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardItem;

@end

@implementation JCWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    [self.view setupGifBG];
}
- (IBAction)goback:(id)sender {
    [self.webView goBack];
}
- (IBAction)goforward:(id)sender {
    [self.webView goForward];
}
- (IBAction)refresh:(id)sender {
    [self.webView reload];
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.goBackItem.enabled = self.webView.canGoBack;
    self.goForwardItem.enabled = self.webView.canGoForward;
}

@end
