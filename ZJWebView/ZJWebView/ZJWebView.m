//
//  ZJWebView.m
//  ZJWebView
//
//  Created by Choi on 2017/4/18.
//  Copyright © 2017年 CZJ. All rights reserved.
//

#import "ZJWebView.h"
#import "ZJWebViewToolBar.h"
#import "ZJWebViewProgressView.h"

@interface ZJWebView ()<WKUIDelegate,WKNavigationDelegate,UIWebViewDelegate,ZJWebViewToolBarDelegate,ZJUIWebViewProgressDelegate>

@property (nonatomic) BOOL isUseUIWebView;
@property (strong, nonatomic) UIWebView *uiWebView;
@property (strong, nonatomic) WKWebView *wkWebView;

@property (strong, nonatomic) NSURLRequest *originRequest;

@property (strong, nonatomic) ZJWebViewToolBar *toolBar;
@property (nonatomic) CGRect originToolBarFrame;
@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) ZJUIWebViewProgress *uiWebViewProgress;

@end

@implementation ZJWebView

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame useUIWebView:NO];
}
- (instancetype)initWithFrame:(CGRect)frame useUIWebView:(BOOL)userUIWebView
{
    self = [super initWithFrame:frame];
    if (self) {
        // 防止外部控制器因scollview的问题，自动偏下移64。
        [self addSubview:[[UIView alloc] init]];
        
        _isUseUIWebView = userUIWebView;
        // 如果小于8.0系统版本。强制使用 UIWebView
        if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
            _isUseUIWebView = YES;
        }
        [self setupWebView];
    }
    return self;
}

- (void)setupWebView
{
    if (_isUseUIWebView) {
        [self initUIWebView];
    } else {
        [self initWKWebView];
    }
    
    self.scalesPageToFit = YES;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
}
#pragma mark - ****** UIWebView ******
- (void)initUIWebView
{
    UIWebView *uiWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    uiWebView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:uiWebView];
    _uiWebView = uiWebView;
    
    ZJUIWebViewProgress *uiWebViewProgress = [[ZJUIWebViewProgress alloc] init];
    uiWebView.delegate = uiWebViewProgress;
    uiWebViewProgress.uiWebViewProxyDelegate = self;
    uiWebViewProgress.uiWebViewProgressDelegate = self;
    _uiWebViewProgress = uiWebViewProgress;
    
}
#pragma mark UIWebViewProgress
- (void)zjUIWebViewProgress:(ZJUIWebViewProgress *)uiWebViewProgress updateProgress:(float)progress
{
    self.estimatedProgress = progress;
}
#pragma mark - ****** WKWebView ******
- (void)initWKWebView
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    // 允许视频播放
    configuration.allowsAirPlayForMediaPlayback = YES;
    // 允许在线播放
    configuration.allowsInlineMediaPlayback = YES;
    // 允许可以与网页交互，选择视图
    configuration.selectionGranularity = YES;
    
    
    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) configuration:configuration];
    wkWebView.opaque = NO;
    // 允许右滑返回上一页
    wkWebView.allowsBackForwardNavigationGestures = YES;
    wkWebView.UIDelegate = self;
    wkWebView.navigationDelegate = self;
    [wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    wkWebView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:wkWebView];
    _wkWebView = wkWebView;
}
#pragma mark WKWebViewProgress
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.estimatedProgress = [change[NSKeyValueChangeNewKey] doubleValue];
    } else if([keyPath isEqualToString:@"title"]) {
        _title = change[NSKeyValueChangeNewKey];
    }
}

#pragma mark - load
- (id)loadRequest:(NSURLRequest *)request
{
    _originRequest = request;
    if (_isUseUIWebView) {
        [_uiWebView loadRequest:request];
        return nil;
    } else {
        return [_wkWebView loadRequest:request];
    }
}
- (id)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
    if (_isUseUIWebView) {
        [_uiWebView loadHTMLString:string baseURL:baseURL];
        return nil;
    } else {
        return [_wkWebView loadHTMLString:string baseURL:baseURL];
    }
}
#pragma mark 前一页
- (id)goForward
{
    if (_isUseUIWebView) {
        [_uiWebView goForward];
        return nil;
    } else {
        return [_wkWebView goForward];
    }
}
#pragma mark 后一页
- (id)goBack
{
    if (_isUseUIWebView) {
        [_uiWebView goBack];
        return nil;
    } else {
        return [_wkWebView goBack];
    }
}
#pragma mark 刷新
- (id)reload
{
    if (_isUseUIWebView) {
        [_uiWebView reload];
        return nil;
    } else {
        return [_wkWebView reload];
    }
}
#pragma mark 刷新原始页
- (id)reloadFromOrigin
{
    if(_isUseUIWebView) {
        if (_originRequest) {
            [self evaluateJavaScript:[NSString stringWithFormat:@"window.location.replace('%@')",self.originRequest.URL.absoluteString] completionHandler:nil];
        }
        return nil;
    } else {
        return [_wkWebView reloadFromOrigin];
    }
}
#pragma mark 暂停加载
- (void)stopLoading
{
    [_uiWebView stopLoading];
    [_wkWebView stopLoading];
}
#pragma mark 后退到第几层
- (void)gobackWithStep:(NSInteger)step
{
    if (self.canGoBack == NO)
        return;
    
    if (step > 0) {
        NSInteger historyCount = self.countOfHistory;
        if(step >= historyCount) {
            step = historyCount - 1;
        }
        
        if (_isUseUIWebView) {
            [_uiWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.history.go(-%ld)", (long) step]];
        } else {
            WKBackForwardListItem* backItem = _wkWebView.backForwardList.backList[step];
            [_wkWebView goToBackForwardListItem:backItem];
        }
    } else {
        [self goBack];
    }

}

#pragma mark - JavaScript / ScriptMessage
#pragma mark 写入JavaScript
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler
{
    if(_isUseUIWebView) {
        NSString* result = [_uiWebView stringByEvaluatingJavaScriptFromString:javaScriptString];
        if(completionHandler) {
            completionHandler(result,nil);
        }
    } else {
        return [_wkWebView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
    }
}
#pragma mark 添加js回调oc通知方式，适用于 iOS8 之后
- (void)addScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name
{
    if (_wkWebView) {
        [[_wkWebView configuration].userContentController addScriptMessageHandler:scriptMessageHandler name:name];
    }
}
#pragma mark 注销 注册过的js回调oc通知方式，适用于 iOS8 之后
- (void)removeScriptMessageHandlerForName:(NSString *)name
{
    if (_wkWebView) {
        [[_wkWebView configuration].userContentController removeScriptMessageHandlerForName:name];
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _offsetHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
    _title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    [self delegate_webViewDidFinishLoad];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self delegate_webViewDidStartLoad];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self delegate_webViewDidFailLoadWithError:error];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    BOOL resultBOOL = [self delegate_webViewShouldStartLoadWithRequest:request navigationType:navigationType];
    return resultBOOL;
}

#pragma mark - WKNavigationDelegate
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    BOOL resultBOOL = [self delegate_webViewShouldStartLoadWithRequest:navigationAction.request navigationType:navigationAction.navigationType];
    if (resultBOOL) {
        //navigationAction.request;
        if(navigationAction.targetFrame == nil) {
            [webView loadRequest:navigationAction.request];
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self delegate_webViewDidStartLoad];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
//    __weak typeof(self) weakSelf = self;
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        _offsetHeight = [result floatValue];
    }];
    
    [self delegate_webViewDidFinishLoad];
    
}
- (void)webView:(WKWebView *) webView didFailProvisionalNavigation: (WKNavigation *) navigation withError: (NSError *) error
{
    [self delegate_webViewDidFailLoadWithError:error];
}
- (void)webView: (WKWebView *)webView didFailNavigation:(WKNavigation *) navigation withError: (NSError *) error
{
    [self delegate_webViewDidFailLoadWithError:error];
}
#pragma mark - ZJWebViewDelegate
- (void)delegate_webViewDidFinishLoad
{
    [self setToolBarButtonAction];
    if ([self.delegate respondsToSelector:@selector(zjWebViewDidFinishLoad:)]) {
        [self.delegate zjWebViewDidFinishLoad:self];
    }
}
- (void)delegate_webViewDidStartLoad
{
    if ([self.delegate respondsToSelector:@selector(zjWebViewDidStartLoad:)]) {
        [self.delegate zjWebViewDidStartLoad:self];
    }
}
- (void)delegate_webViewDidFailLoadWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(zjWebView:didFailLoadWithError:)]) {
        [self.delegate zjWebView:self didFailLoadWithError:error];
    }
}
- (BOOL)delegate_webViewShouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(NSInteger)navigationType
{
    [self setToolBarButtonAction];
    
    BOOL resultBOOL = YES;
    if ([self.delegate respondsToSelector:@selector(zjWebView:shouldStartLoadWithRequest:navigationType:)]) {
        if(navigationType == -1) {
            navigationType = UIWebViewNavigationTypeOther;
        }
        resultBOOL = [self.delegate zjWebView:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return resultBOOL;
}
- (void)delegate_webViewUpdateProgress:(float)progress
{
    if ([self.delegate respondsToSelector:@selector(zjWebViewUpdateProgress:)]) {
        [self.delegate zjWebViewUpdateProgress:progress];
    }
    
    _progressView.progress = progress;
    _progressView.alpha = 1;
    if (_progressView.progress == 1) {
        [UIView animateWithDuration:0.25 animations:^{
            _progressView.alpha = 0;
        }];
    }
    
}
#pragma mark - ZJWebViewToolBarDelegate
- (void)toolBarHome
{
    [self loadRequest:_originRequest];
}
- (void)toolBarGoBack
{
    [self goBack];
    [self setToolBarButtonAction];
}
- (void)toolBarGoForward
{
    [self goForward];
    [self setToolBarButtonAction];
}
- (void)toolBarRefresh
{
    [self reload];
}
- (void)toolBarStopLoading
{
    [self stopLoading];
}

#pragma mark - Set Method
- (void)setScalesPageToFit:(BOOL)scalesPageToFit
{
    if (_scalesPageToFit == scalesPageToFit) {
        return;
    }
    _scalesPageToFit = scalesPageToFit;
    
    if (_isUseUIWebView) {
        _uiWebView.scalesPageToFit = scalesPageToFit;
    } else {
        NSString *jScript = @"var meta = document.createElement('meta'); \
        meta.name = 'viewport'; \
        meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; \
        var head = document.getElementsByTagName('head')[0];\
        head.appendChild(meta);";

        if (scalesPageToFit) {
            WKUserScript *wkUScript = [[NSClassFromString(@"WKUserScript") alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
            [_wkWebView.configuration.userContentController addUserScript:wkUScript];
        } else {
            
            NSMutableArray* array = [NSMutableArray arrayWithArray:_wkWebView.configuration.userContentController.userScripts];
            for (WKUserScript *wkUScript in array) {
                if([wkUScript.source isEqual:jScript]) {
                    [array removeObject:wkUScript];
                    break;
                }
            }
            for (WKUserScript *wkUScript in array) {
                [_wkWebView.configuration.userContentController addUserScript:wkUScript];
            }
        }
    }
}
- (void)setEstimatedProgress:(double)estimatedProgress
{
    _estimatedProgress = estimatedProgress;
    if (_toolBar) {
        _toolBar.estimatedProgress = estimatedProgress;
        [self setToolBarButtonAction];
    }
    
    if (_progressView) {
        [self delegate_webViewUpdateProgress:estimatedProgress];
    }
}
- (void)setShowProgressView:(BOOL)showProgressView
{
    _showProgressView = showProgressView;
    
    if (showProgressView && !_progressView) {
        ZJWebViewProgressView *progressView = [[ZJWebViewProgressView alloc] init];
        progressView.frame = CGRectMake(0, 0, self.frame.size.width, 0);
        if (_progressViewHeight <= 0) {
            progressView.height = 3;
        }
        progressView.trackTintColor = [UIColor clearColor];
        progressView.progress = 0.15;
        [self addSubview:progressView];

        _progressView = progressView;
        
        progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
}
- (void)setProgressViewHeight:(CGFloat)progressViewHeight
{
    _progressViewHeight = progressViewHeight;
    
    if (_progressView) {
        ZJWebViewProgressView *v = (ZJWebViewProgressView *)_progressView;
        v.height = progressViewHeight;
    }
}
- (void)setShowToolBar:(BOOL)showToolBar
{
    _showToolBar = showToolBar;
    if (showToolBar && !_toolBar) {
        
        ZJWebViewToolBar *toolBar = [[ZJWebViewToolBar alloc] init];
        toolBar.delegate = self;
        CGRect frame = toolBar.frame;
        frame.origin.y = self.frame.size.height - frame.size.height;
        toolBar.frame = frame;
        [self addSubview:toolBar];
        _toolBar = toolBar;
        _originToolBarFrame = frame;
        
        if (_isUseUIWebView) {
            [_uiWebView.scrollView.panGestureRecognizer addTarget:self action:@selector(panGestureRecognizer:)];
            frame = _uiWebView.frame;
            frame.size.height -= _toolBar.frame.size.height;
            _uiWebView.frame = frame;
        } else {
            [_wkWebView.scrollView.panGestureRecognizer addTarget:self action:@selector(panGestureRecognizer:)];
            frame = _wkWebView.frame;
            frame.size.height -= _toolBar.frame.size.height;
            _wkWebView.frame = frame;
        }
        
    } else {
        [_toolBar removeFromSuperview];
        _toolBar = nil;
    }
}

- (void)setToolBarButtonAction
{
    if (_toolBar) {
        _toolBar.canGoBack = self.canGoBack;
        _toolBar.canGoForward = self.canGoForward;
        
        
        if (self.superview && !_timer) {
            // 创建定时器
            _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(setToolBarButtonAction) userInfo:nil repeats:YES];
        }
        if (!self.superview && [_timer isValid]) {
            // 销毁定时器
            [_timer invalidate];
            _timer = nil;
        }
    }
    
}
- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollEnabled = scrollEnabled;
    _uiWebView.scrollView.scrollEnabled = scrollEnabled;
    _wkWebView.scrollView.scrollEnabled = scrollEnabled;
}
- (void)setBounces:(BOOL)bounces
{
    _bounces = bounces;
    _uiWebView.scrollView.scrollEnabled = bounces;
    _wkWebView.scrollView.scrollEnabled = bounces;
}
#pragma mark - Get Method
- (BOOL)canGoBack
{
    if (_isUseUIWebView) {
        return [_uiWebView canGoBack];
    } else {
        return [_wkWebView canGoBack];
    }
}
- (BOOL)canGoForward
{
    if (_isUseUIWebView) {
        return [_uiWebView canGoForward];
    } else {
        return [_wkWebView canGoForward];
    }
}
- (BOOL)isLoading
{
    if (_isUseUIWebView) {
        return [_uiWebView isLoading];
    } else {
        return [_wkWebView isLoading];
    }
}
- (NSInteger)countOfHistory
{
    if (_isUseUIWebView) {
        int count = [[_uiWebView stringByEvaluatingJavaScriptFromString:@"window.history.length"] intValue];
        if (count) {
            return count;
        } else {
            return 1;
        }
    } else {
        return _wkWebView.backForwardList.backList.count;
    }

}
#pragma mark - panGestureRecognizer
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)sender {
    
    if (!_animateToolBar) {
        return;
    }
    CGPoint point = [sender translationInView:_wkWebView];
    if (_isUseUIWebView) {
        point = [sender translationInView:_uiWebView];
    }
    CGFloat offset_x = point.x;
    CGFloat offset_y = point.y;
    
    if ((ABS(offset_x) < ABS(offset_y))) {
        
        if (offset_y > 0) {
            // NSLog(@"手指向下滑 显示");
            if (_toolBar.frame.origin.y == _originToolBarFrame.origin.y || !_toolBar) {
                return;
            }
            [UIView animateWithDuration:0.25 animations:^{
                _toolBar.frame = _originToolBarFrame;
                
                if (_isUseUIWebView) {
                    CGRect webFrame = _uiWebView.frame;
                    webFrame.size.height += _toolBar.frame.size.height;
                    _uiWebView.frame = webFrame;
                } else {
                    CGRect webFrame = _wkWebView.frame;
                    webFrame.size.height -= _toolBar.frame.size.height;
                    _wkWebView.frame = webFrame;
                }
            }];
            
        } else if (offset_y < 0) {
            // NSLog(@"手指向上滑 隐藏");
            if (_toolBar.frame.origin.y == _originToolBarFrame.origin.y + _originToolBarFrame.size.height) {
                return;
            }
            [UIView animateWithDuration:0.25 animations:^{
                CGRect frame = _toolBar.frame;
                frame.origin.y = _originToolBarFrame.origin.y + _originToolBarFrame.size.height;
                _toolBar.frame = frame;
                
                if (_isUseUIWebView) {
                    CGRect webFrame = _uiWebView.frame;
                    webFrame.size.height += _toolBar.frame.size.height;
                    _uiWebView.frame = webFrame;
                } else {
                    CGRect webFrame = _wkWebView.frame;
                    webFrame.size.height += _toolBar.frame.size.height;
                    _wkWebView.frame = webFrame;
                }
            }];
        }
        
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark - 清理、销毁
- (void)dealloc
{
    [self stopLoading];
    
    if(_isUseUIWebView) {
        //清除缓存，通常的UIWebView默认是具有缓存功能的。
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        NSURLCache * cache = [NSURLCache sharedURLCache];
        [cache removeAllCachedResponses];
        [cache setDiskCapacity:0];
        [cache setMemoryCapacity:0];
        
        _uiWebViewProgress.uiWebViewProgressDelegate = nil;
        _uiWebViewProgress.uiWebViewProxyDelegate = nil;
        _uiWebViewProgress = nil;
        
        _uiWebView.delegate = nil;
        [_uiWebView removeFromSuperview];
        _uiWebView = nil;
        
    } else {
        _wkWebView.UIDelegate = nil;
        _wkWebView.navigationDelegate = nil;
        
        [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
        [_wkWebView removeObserver:self forKeyPath:@"title"];
        [_wkWebView removeFromSuperview];
        _wkWebView = nil;
    }
    
    NSLog(@"dealloc ZJWebView");
    
}

@end
