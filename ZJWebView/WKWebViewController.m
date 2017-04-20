//
//  WKWebViewController.m
//  ZJWebView
//
//  Created by Choi on 2017/4/20.
//  Copyright © 2017年 CZJ. All rights reserved.
//

#import "WKWebViewController.h"
#import "ZJWebView.h"

@interface WKWebViewController ()

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"WKWebView";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat y = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat bottom = self.tabBarController.tabBar.frame.size.height;
    if (_isPush) {
        bottom = 0;
    }
    
    ZJWebView *webView = [[ZJWebView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - y - bottom)];
    // 展示工具栏
    //webView.showToolBar = YES;
    // 工具栏上下动画
    //webView.animateToolBar = YES;
    // 展示进度条
    webView.showProgressView = YES;
    // 进度条颜色
    webView.progressView.tintColor = [UIColor redColor];
    // 进度条高度
    webView.progressViewHeight = 10;
    
    NSURL *url = [NSURL URLWithString:@"https://www.tmall.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
}


@end
