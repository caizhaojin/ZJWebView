//
//  ZJWebView.h
//  ZJWebView
//
//  Created by Choi on 2017/4/18.
//  Copyright © 2017年 CZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class ZJWebView;
@protocol ZJWebViewDelegate <NSObject>
@optional

- (void)zjWebViewDidStartLoad:(ZJWebView *)webView;
- (void)zjWebViewDidFinishLoad:(ZJWebView *)webView;
- (void)zjWebView:(ZJWebView *)webView didFailLoadWithError:(NSError *)error;
- (BOOL)zjWebView:(ZJWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)zjWebViewUpdateProgress:(float)progress;

@end

@interface ZJWebView : UIView

@property (weak, nonatomic) id <ZJWebViewDelegate>delegate;

@property (copy, nonatomic) NSString *title;
/** 是否根据视图大小来缩放页面  默认为YES */
@property (nonatomic) BOOL scalesPageToFit;
/** 网页加载进度 */
@property (nonatomic) double estimatedProgress;
/** 网页内容可浏览总高 */
@property (nonatomic) CGFloat offsetHeight;
/** 是否可以返回 */
@property (nonatomic) BOOL canGoBack;
/** 是否可以向前 */
@property (nonatomic) BOOL canGoForward;
/** 是否在加载 */
@property (nonatomic) BOOL isLoading;
/** 层数 */
@property (nonatomic) NSInteger countOfHistory;
/** 是否禁止滚动 */
@property (nonatomic) BOOL scrollEnabled;
/** 是否边界反弹 */
@property (nonatomic) BOOL bounces;


/** 是否展示工具栏，默认为NO */
@property (nonatomic) BOOL showToolBar;
/** 是否上下动画工具栏，默认为NO*/
@property (nonatomic) BOOL animateToolBar;

/** 是否展示进度条 */
@property (nonatomic) BOOL showProgressView;
@property (strong, nonatomic) UIProgressView *progressView;
/** 进度条高度 */
@property (nonatomic) CGFloat progressViewHeight;

/** 默认 useUIWebView = NO */
- (instancetype)initWithFrame:(CGRect)frame useUIWebView:(BOOL)userUIWebView;
/** 加载网络请求 */
- (id)loadRequest:(NSURLRequest *)request;
/** 加载HTML */
- (id)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;

/** 前一页 */
- (id)goForward;
/** 后一页 */
- (id)goBack;
/** 刷新 */
- (id)reload;
/** 刷新原始页 */
- (id)reloadFromOrigin;
/** 暂停加载 */
- (void)stopLoading;
/** 后退到第几层 */
- (void)gobackWithStep:(NSInteger)step;


/**
 *  添加js代码
 */
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler;
/**
 *  添加js回调oc通知方式，适用于 iOS8 之后
 */
- (void)addScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name;
/**
 *  注销 注册过的js回调oc通知方式，适用于 iOS8 之后
 */
- (void)removeScriptMessageHandlerForName:(NSString *)name;



@end
