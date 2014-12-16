//
//  OMNWebVC.m
//  omnom
//
//  Created by tea on 08.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNChangePhoneWebVC.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNUser+network.h"
#import "NSURL+omn_query.h"

@interface OMNChangePhoneWebVC ()
<UIWebViewDelegate>

@end

@implementation OMNChangePhoneWebVC {
  
  UIWebView *_webView;
  OMNUser *_user;
  
}

- (instancetype)initWithUser:(OMNUser *)user {
  self = [super init];
  if (self) {
    
    _user = user;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self omn_setup];
  [self reloadPage];
  
}

- (void)reloadPage {
  
  __weak typeof(self)weakSelf = self;
  [self setLoading:YES];
  [_user recoverWithCompletion:^(NSURL *url) {
    
    [weakSelf showURL:url];
    
  } failure:^(NSError *error) {
    
    [weakSelf setLoading:NO];
    
  }];
  
}

- (void)showURL:(NSURL *)url {
  
  [_webView loadRequest:[NSURLRequest requestWithURL:url]];
  
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

- (void)setLoading:(BOOL)loading {
  
  if (loading) {
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem omn_loadingItem];
    
  }
  else {
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"ico-refresh"] color:[UIColor blackColor] target:self action:@selector(reloadPage)];
    
  }
  
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  
  NSDictionary *query = [request.URL omn_query];
  
  if ([query[@"status"] isEqualToString:@"success"]) {

    [self.delegate changePhoneWebVCDidChangePhone:self];
    return NO;
    
  }
  else {
    
    return YES;
    
  }
  
}

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
