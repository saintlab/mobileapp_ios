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
<UIWebViewDelegate>

@end

@implementation OMNGPBPayVC {
  OMNCardInfo *_cardInfo;
  OMNOrder *_order;
  
  UIActivityIndicatorView *_spinner;
  
  __weak IBOutlet OMNCardView *_webView;
  UIBarButtonItem *_submitButton;
  BOOL _formLoaded;
}

- (void)dealloc {
  
  _webView.delegate = nil;
  [_webView stopLoading];
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
  
  _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  _spinner.hidesWhenStopped = YES;
  
  _webView.webDelegate = self;
  _webView.userInteractionEnabled = NO;
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self createAcquiringOrder];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  self.navigationItem.prompt = nil;
  
}

- (void)createAcquiringOrder {
  
  __weak typeof(self)weakSelf = self;
  [_spinner startAnimating];
  
  [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_spinner] animated:YES];
  self.navigationItem.prompt = NSLocalizedString(@"Создаем платеж...", nil);
  [_order createAcquiringOrder:^(OMNOrder *order) {
    
    [weakSelf getPaymentURL];
    
  } failure:^(NSError *error) {
    
    [weakSelf processFailCreateAcquiringOrder];
    
  }];
  
}

- (void)processFailCreateAcquiringOrder {
  
  self.navigationItem.prompt = NSLocalizedString(@"Ошибка при создании платежа", nil);
  UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Повторить", nil) style:UIBarButtonItemStylePlain target:self action:@selector(createAcquiringOrder)];
  [self.navigationItem setRightBarButtonItem:button animated:YES];
  
}

- (void)getPaymentURL {
  
  __weak typeof(self)weakSelf = self;
  self.navigationItem.prompt = NSLocalizedString(@"Получаем данные о платеже...", nil);
  UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:_spinner];
  [self.navigationItem setRightBarButtonItem:button animated:YES];
  
  [_order getPaymentURL:^(NSString *urlString) {
    
    [weakSelf processCardPayment:urlString];
    
  } failure:^(NSError *error) {
    
    [weakSelf processFailGetPaymentURL];
    
  }];

}

- (void)processFailGetPaymentURL {
  
  self.navigationItem.prompt = NSLocalizedString(@"Ошибка получении данныех о платеже", nil);
  UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Повторить", nil) style:UIBarButtonItemStylePlain target:self action:@selector(getPaymentURL)];
  [self.navigationItem setRightBarButtonItem:button animated:YES];
  
}

- (void)processCardPayment:(NSString *)requestString {
  
  _webView.scalesPageToFit = YES;
  _formLoaded = NO;
  NSURL *url = [NSURL URLWithString:requestString];
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
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Завершить", nil) style:UIBarButtonItemStylePlain target:self action:@selector(finishPayment)];
    [self.navigationItem setRightBarButtonItem:button animated:YES];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    self.navigationItem.prompt = NSLocalizedString(@"Счет успешно оплачен", nil);
    
  }
  
  return YES;
}

- (void)finishPayment {
  [self.delegate gpbVCDidPay:self];
}

@end
