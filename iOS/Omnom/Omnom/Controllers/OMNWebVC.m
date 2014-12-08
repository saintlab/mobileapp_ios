//
//  OMNWebVC.m
//  omnom
//
//  Created by tea on 08.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNWebVC.h"
#import "UIBarButtonItem+omn_custom.h"

@interface OMNWebVC ()
<UIWebViewDelegate>

@end

@implementation OMNWebVC {
  
  UIWebView *_webView;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self omn_setup];
  [self reloadPage];
  
}

- (void)omn_setup {
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  _webView = [[UIWebView alloc] init];
  _webView.translatesAutoresizingMaskIntoConstraints = NO;
  _webView.delegate = self;
  [self.view addSubview:_webView];

  NSDictionary *views =
  @{
    @"webView" : _webView,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[webView]|" options:kNilOptions metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webView]|" options:kNilOptions metrics:nil views:views]];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  self.navigationController.navigationBar.shadowImage = nil;
  [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
  
}

- (void)reloadPage {
  
  [_webView loadRequest:[NSURLRequest requestWithURL:self.url]];
  
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  
  NSLog(@"shouldStartLoadWithRequest>%@", request);
  return YES;
  
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Повторить", nil) style:UIBarButtonItemStylePlain target:self action:@selector(reloadPage)];
  
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
  
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem omn_loadingItem];
  
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  
  self.navigationItem.rightBarButtonItem = nil;
  
}

@end
