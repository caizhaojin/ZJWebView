//
//  ViewController.m
//  ZJWebView
//
//  Created by Choi on 2017/4/20.
//  Copyright © 2017年 CZJ. All rights reserved.
//

#import "ViewController.h"
#import "UIWebViewController.h"
#import "WKWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"SelectWebView";
    
    CGFloat btnSize = 130;
    
    UIButton *uiBtn = [[UIButton alloc] init];
    uiBtn.frame = CGRectMake(0, self.view.frame.size.height/2 - btnSize - 20, btnSize, btnSize);
    uiBtn.center = CGPointMake(self.view.center.x, uiBtn.center.y);
    [uiBtn setTitle:@"UIWebView" forState:UIControlStateNormal];
    uiBtn.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.8];
    uiBtn.tag = 0;
    [uiBtn addTarget:self action:@selector(pushWebView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uiBtn];
    
    
    UIButton *wkBtn = [[UIButton alloc] init];
    wkBtn.frame = CGRectMake(0, self.view.frame.size.height/2 + 20, btnSize, btnSize);
    wkBtn.center = CGPointMake(self.view.center.x, wkBtn.center.y);
    [wkBtn setTitle:@"WKWebView" forState:UIControlStateNormal];
    wkBtn.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
    wkBtn.tag = 1;
    [wkBtn addTarget:self action:@selector(pushWebView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wkBtn];
}

- (void)pushWebView:(UIButton *)sender
{
    if (sender.tag == 0) {
        UIWebViewController *uiWebView = [[UIWebViewController alloc] init];
        uiWebView.hidesBottomBarWhenPushed = YES;
        uiWebView.isPush = YES;
        [self.navigationController pushViewController:uiWebView animated:YES];
    } else {
        WKWebViewController *wkWebView = [[WKWebViewController alloc] init];
        wkWebView.hidesBottomBarWhenPushed = YES;
        wkWebView.isPush = YES;
        [self.navigationController pushViewController:wkWebView animated:YES];
    }
    
}


@end
