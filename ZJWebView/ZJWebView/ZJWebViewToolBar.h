//
//  ZJWebViewToolBar.h
//  ZJWebView
//
//  Created by Choi on 2017/4/19.
//  Copyright © 2017年 CZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZJWebViewToolBarDelegate <NSObject>
@optional

- (void)toolBarHome;
- (void)toolBarGoBack;
- (void)toolBarGoForward;
- (void)toolBarRefresh;
- (void)toolBarStopLoading;

@end

@interface ZJWebViewToolBar : UIView

@property (weak, nonatomic) id <ZJWebViewToolBarDelegate>delegate;

@property (nonatomic) double estimatedProgress;

@property (nonatomic) BOOL canGoBack;

@property (nonatomic) BOOL canGoForward;

@end
