//
//  OMNMailRu3DSConfirmVC.m
//  Pods
//
//  Created by tea on 18.04.15.
//
//

#import "OMNMailRu3DSConfirmVC.h"
#import "OMNMailRuAcquiring.h"

@interface OMNMailRu3DSConfirmVC ()
<UIWebViewDelegate>
@end

@implementation OMNMailRu3DSConfirmVC {
  
  UIWebView *_webView;
  OMNMailRuPoll *_pollResponse;
  
}

- (instancetype)initWithPollResponse:(OMNMailRuPoll *)pollResponse {
  self = [super init];
  if (self) {
  
    _pollResponse = pollResponse;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self omn_setup];
  [self reloadPage];
  
}

- (void)reloadPage {
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_pollResponse.request3dsURL];
  request.timeoutInterval = 10.0;
  [_webView loadRequest:request];
  
}

- (void)omn_setup {
  
  UIButton *closeButton = [[UIButton alloc] init];
  [closeButton setImage:[UIImage imageNamed:@"mail_cross_icon_black"] forState:UIControlStateNormal];
  [closeButton addTarget:self action:@selector(closeTap) forControlEvents:UIControlEventTouchUpInside];
  [closeButton sizeToFit];
  self.navigationItem.titleView = closeButton;
  
  _webView = [[UIWebView alloc] init];
  _webView.translatesAutoresizingMaskIntoConstraints = NO;
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

- (void)closeTap {
  if (self.didFinishBlock) {
    self.didFinishBlock(nil, [NSError errorWithDomain:OMNMailRuErrorDomain code:kOMNMailRuErrorCodeCancel userInfo:nil]);
  }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [spinner startAnimating];
  [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:spinner] animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [self.navigationItem setRightBarButtonItem:nil animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  
  if ([request.URL.path isEqualToString:@"/api/page/result"]) {
    
    NSDictionary *parameters = [self paramsFromQueryString:request.URL.query];
    if ([parameters[@"Success"] isEqualToString:@"True"]) {
      self.didFinishBlock(parameters, nil);
    }
    else {
      self.didFinishBlock(nil, [OMNMailRuError errorWithDomain:OMNMailRuErrorDomain code:kOMNMailRuErrorCodeUnknown userInfo:[self userInfoFromParameters:parameters]]);
    }
    return NO;
    
  }
  return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadPage)];
  self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
  
}

- (NSDictionary *)userInfoFromParameters:(NSDictionary *)parameters {
  
  NSMutableDictionary *userInfo = [parameters mutableCopy];
  if (parameters[@"descr"]) {
    userInfo[NSLocalizedDescriptionKey] = [parameters[@"descr"] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
  }
  return userInfo;
  
}

- (NSDictionary *)paramsFromQueryString:(NSString *)queryString {
  
  NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:queryComponents.count];
  [queryComponents enumerateObjectsUsingBlock:^(NSString *component, NSUInteger idx, BOOL *stop) {
    
    NSArray *keyValue = [component componentsSeparatedByString:@"="];
    if (2 == keyValue.count) {
      params[keyValue[0]] = [keyValue[1] stringByRemovingPercentEncoding];
    }
    
  }];
  return params;
  
}

@end
