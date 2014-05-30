//
//  OMNGPBPayVC.m
//  restaurants
//
//  Created by tea on 28.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNGPBPayVC.h"
#import "OMNCardInfo.h"
#import "OMNOrder.h"
#import "OMNCardView.h"

@interface OMNGPBPayVC ()
<UIWebViewDelegate,
UIAlertViewDelegate>

@end

@implementation OMNGPBPayVC {
  OMNCardInfo *_cardInfo;
  OMNOrder *_order;
  
  __weak IBOutlet OMNCardView *_webView;
  UIBarButtonItem *_submitButton;
  BOOL _formLoaded;
}

- (void)dealloc {
  [_webView stopLoading];
  _webView.delegate = nil;
  _webView.webDelegate = nil;
  
}

- (instancetype)initWithCard:(OMNCardInfo *)cardInfo order:(OMNOrder *)order; {
  self = [super initWithNibName:@"OMNGPBPayVC" bundle:nil];
  if (self) {
    _cardInfo = cardInfo;
    _order = order;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _webView.webDelegate = self;
  _webView.userInteractionEnabled = NO;
  
  __weak typeof(self)weakSelf = self;
  [_order createAcquiringOrder:^(OMNOrder *order) {
    
    [weakSelf getPaymentURL];
    
  } failure:^(NSError *error) {
    
  }];
  
}

- (void)getPaymentURL {
  
  __weak typeof(self)weakSelf = self;
  [_order getPaymentURL:^(NSString *urlString) {
    
    [weakSelf processCardPayment:urlString];
    
  } failure:^(NSError *error) {
    
  }];

}

- (void)processCardPayment:(NSString *)requestString {
  NSURL *url = [NSURL URLWithString:requestString];
  //  NSDictionary *queryComponents = [url omn_queryComponents];
  //  NSLog(@"%@", queryComponents);
  
  _webView.scalesPageToFit = YES;
  _formLoaded = NO;
  [_webView loadRequest:[NSURLRequest requestWithURL:url]];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)fillForm {

  NSString *script = [_cardInfo fillFormScript];
  NSString *scriptResult = [_webView stringByEvaluatingJavaScriptFromString:script];
  NSLog(@"scriptResult>%@", scriptResult);
  
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  
  if (NO == _formLoaded) {
    _submitButton.enabled = YES;
    _formLoaded = YES;
    [self fillForm];
  }
  else {
  }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  NSLog(@"%@", request.URL);
  
  if ([request.URL.absoluteString hasPrefix:@"https://test.pps.gazprombank.ru/payment/payment-params.wsm?ws.id"]) {
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Счет успешно оплачен", nil) message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    
  }
  
  return YES;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  [self.delegate gpbVCDidPay:self];
}

@end
