//
//  OMNGPBPayVC.m
//  restaurants
//
//  Created by tea on 28.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNGPBPayVC.h"
#import "OMNOrder+network.h"
#import "OMNCardView.h"
#import "OMNBankCardInfo.h"

@interface OMNGPBPayVC ()
<UIWebViewDelegate>

@end

@implementation OMNGPBPayVC {
  OMNBankCardInfo *_bankCardInfo;
  OMNOrder *_order;
  OMNBill *_bill;
  
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

- (instancetype)initWithCard:(OMNBankCardInfo *)bankCardInfo order:(OMNOrder *)order; {
  self = [super initWithNibName:@"OMNGPBPayVC" bundle:nil];
  if (self) {
    _bankCardInfo = bankCardInfo;
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

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self createAcquiringOrder];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  self.navigationItem.prompt = nil;
  
}

- (void)createAcquiringOrder {
  
  [_spinner startAnimating];
  
  [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_spinner] animated:YES];
  self.navigationItem.prompt = NSLocalizedString(@"Создаем платеж...", nil);

  if (_bill) {

    [self getLinkForBill:_bill];
    
  }
  else {
    
    __weak typeof(self)weakSelf = self;
    [_order createBill:^(OMNBill *bill) {
      
      [weakSelf getLinkForBill:bill];
      
    } failure:^(NSError *error) {
      
      [weakSelf processFailCreateAcquiringOrder];
      
    }];
    
  }
  
}

- (void)getLinkForBill:(OMNBill *)bill {

  _bill = bill;
  __weak typeof(self)weakSelf = self;
  [bill linkForAmount:_order.totaAmountWithTips tip:_order.tipAmount completion:^(NSString *url) {

    if (url.length) {
      [weakSelf processCardPayment:url];
    }
    else {
      [weakSelf processFailCreateAcquiringOrder];
    }
    
  }];
  
}

- (void)processFailCreateAcquiringOrder {
  
  self.navigationItem.prompt = NSLocalizedString(@"Ошибка при создании платежа", nil);
  UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Повторить", nil) style:UIBarButtonItemStylePlain target:self action:@selector(createAcquiringOrder)];
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

  NSString *script = [self fillFormScript];
  NSString *scriptResult = [_webView stringByEvaluatingJavaScriptFromString:script];
  NSLog(@"scriptResult>%@", scriptResult);
  
}

- (NSString *)fillFormScript {
  
  NSString *path = [[NSBundle mainBundle] pathForResource:@"fill-form" ofType:nil];
  NSString *qFormat = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
  NSString *cardNumber = @"9000000000000000001";
  NSString *month = @"01";
  NSString *year = @"15";
  NSString *cvv = @"123";
  
  return [NSString stringWithFormat:qFormat, @"Test", cardNumber, month, year, cvv];
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
  
  if ([request.URL.absoluteString hasPrefix:@"https://test.pps.gazprombank.ru/payment/payment-params.wsm?ws.id"]) {
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Завершить", nil) style:UIBarButtonItemStylePlain target:self action:@selector(finishPayment)];
    [self.navigationItem setRightBarButtonItem:button animated:YES];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    self.navigationItem.prompt = NSLocalizedString(@"Счет успешно оплачен", nil);
    
  }
  
  return YES;
}

- (void)finishPayment {
  
  [self.delegate gpbVCDidPay:self withOrder:_order];
  
}

@end
