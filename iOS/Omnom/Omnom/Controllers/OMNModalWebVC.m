//
//  OMNModalWebVC.m
//  omnom
//
//  Created by tea on 16.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNModalWebVC.h"
#import "UIView+omn_autolayout.h"
#import "UIBarButtonItem+omn_custom.h"

@interface OMNModalWebVC ()
<UIWebViewDelegate>

@end

@implementation OMNModalWebVC {
  
  UIWebView *_webView;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self omn_setup];
  
  self.navigationItem.titleView = self.navigationItem.titleView = [UIBarButtonItem omn_buttonWithImage:[UIImage imageNamed:@"cross_icon_black"] color:[UIColor blackColor] target:self action:@selector(closeTap)];
  
}

- (void)viewDidAppear:(BOOL)animated {
  
  [super viewDidAppear:animated];
  [_webView loadRequest:[NSURLRequest requestWithURL:self.url]];
  
}

- (void)closeTap {
  
  if (self.didCloseBlock) {
    
    self.didCloseBlock();
    
  }
  
}

- (void)omn_setup {
  
  _webView = [UIWebView omn_autolayoutView];
  _webView.delegate = self;
  [self.view addSubview:_webView];
  
  NSDictionary *views =
  @{
    @"webView" : _webView,
    };
  
  NSDictionary *metrics =
  @{
    
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[webView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webView]|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)setLoading:(BOOL)loading {
  
  self.navigationItem.rightBarButtonItem = (loading) ? ([UIBarButtonItem omn_loadingItem]) : (nil);
  
}

#pragma mark - UIWebViewDelegate


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  
  [self setLoading:NO];
  
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
  
  [self setLoading:YES];
  
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  
  [self setLoading:NO];
  
}

@end
