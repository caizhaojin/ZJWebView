//
//  ZJWebViewProgressView.h
//  ZJWebView
//
//  Created by Choi on 2017/4/20.
//  Copyright © 2017年 CZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJWebViewProgressView : UIProgressView

@property (nonatomic) CGFloat height;

@end

#pragma mark - UIWebView进度代理
@class ZJUIWebViewProgress;
@protocol ZJUIWebViewProgressDelegate <NSObject>

- (void)zjUIWebViewProgress:(ZJUIWebViewProgress *)uiWebViewProgress updateProgress:(float)progress;

@end

typedef void (^ZJUIWebViewProgressBlock)(float progress);

@interface ZJUIWebViewProgress : NSObject <UIWebViewDelegate>

@property (weak, nonatomic) id <ZJUIWebViewProgressDelegate>uiWebViewProgressDelegate;
@property (weak, nonatomic) id <UIWebViewDelegate>uiWebViewProxyDelegate;
@property (copy, nonatomic) ZJUIWebViewProgressBlock progressBlock;
@property (readonly, nonatomic) float progress; // 0.0..1.0

- (void)reset;

@end
