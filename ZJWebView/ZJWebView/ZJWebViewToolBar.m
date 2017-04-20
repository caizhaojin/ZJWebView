//
//  ZJWebViewToolBar.m
//  ZJWebView
//
//  Created by Choi on 2017/4/19.
//  Copyright © 2017年 CZJ. All rights reserved.
//

#import "ZJWebViewToolBar.h"

@interface ZJWebViewToolBar ()

@property (strong, nonatomic) NSMutableArray *btns;

@end
@implementation ZJWebViewToolBar

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 49)];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupToolBar];
    }
    return self;
}

- (void)setupToolBar
{
    self.backgroundColor = [UIColor whiteColor];
    
    // 线
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
    line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    [self addSubview:line];
    
    // 图片自定义更换，现在图片尚丑
    NSArray *arr = @[@"home",@"back",@"next",@"refresh"];
    
    CGFloat contentWidth = self.frame.size.width - 20*2;
    contentWidth = contentWidth - (arr.count - 1)*10;
    CGFloat btnWidth = contentWidth/arr.count;
    
    NSMutableArray *btns = [NSMutableArray array];
    for (NSInteger i = 0; i < arr.count; i++) {
        
        UIButton *btn = [[UIButton alloc] init];
        NSString *imageName = [NSString stringWithFormat:@"ZJWebViewTooBar_%@",arr[i]];
        UIImage *btnImage = [UIImage imageNamed:imageName];
        [btn setImage:btnImage forState:UIControlStateNormal];
        NSString *str = arr[i];
        if ([str isEqualToString:@"refresh"]) {
            UIImage *selBtnImage = [UIImage imageNamed:@"ZJWebViewTooBar_stop"];
            [btn setImage:selBtnImage forState:UIControlStateSelected];
        } else if ([str isEqualToString:@"back"]) {
            btn.enabled = self.canGoBack;
        } else if ([str isEqualToString:@"next"]) {
            btn.enabled = self.canGoForward;
        }
        btn.tag = i;
        [btn addTarget:self action:@selector(clickToolBarButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
       
        CGRect frame = btn.frame;
        frame.origin.y = 0;
        frame.size.width = btnWidth;
        frame.size.height = self.frame.size.height;
        
        frame.origin.x = 20;
        if (i != 0) {
            UIButton *lastBtn = btns[i-1];
            frame.origin.x = CGRectGetMaxX(lastBtn.frame) + 10;
        }
        btn.frame = frame;
        
        btn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [btns addObject:btn];
    }
    _btns = btns;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin  | UIViewAutoresizingFlexibleBottomMargin;
    
    line.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
}

- (void)clickToolBarButton:(UIButton *)sender
{
    if (sender.tag == 0) {
        if ([self.delegate respondsToSelector:@selector(toolBarHome)]) {
            [self.delegate toolBarHome];
        }
    } else if (sender.tag == 1) {
        if ([self.delegate respondsToSelector:@selector(toolBarGoBack)]) {
            [self.delegate toolBarGoBack];
        }
    } else if (sender.tag == 2) {
        if ([self.delegate respondsToSelector:@selector(toolBarGoForward)]) {
            [self.delegate toolBarGoForward];
        }
    } else if (sender.tag == 3) {
        if (sender.isSelected) {
            if ([self.delegate respondsToSelector:@selector(toolBarStopLoading)]) {
                [self.delegate toolBarStopLoading];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(toolBarRefresh)]) {
                [self.delegate toolBarRefresh];
            }
        }
    }
}
#pragma mark - Set Method
- (void)setEstimatedProgress:(double)estimatedProgress
{
    UIButton *btn = _btns.lastObject;
    if (estimatedProgress >= 1.0) {
        if (btn.isSelected) {
            btn.selected = !btn.selected;
        }
    } else {
        if (!btn.isSelected) {
            btn.selected = !btn.selected;
        }
    }
}
- (void)setCanGoBack:(BOOL)canGoBack
{
    UIButton *btn = _btns[1];
    btn.enabled = canGoBack;
    
    _canGoBack = canGoBack;
}

- (void)setCanGoForward:(BOOL)canGoForward
{
    UIButton *btn = _btns[2];
    btn.enabled = canGoForward;
    
    _canGoForward = canGoForward;
}
@end
