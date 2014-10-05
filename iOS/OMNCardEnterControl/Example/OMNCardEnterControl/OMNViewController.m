//
//  OMNViewController.m
//  OMNCardEnterControl
//
//  Created by teanet on 07/08/2014.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import "OMNViewController.h"
#import <OMNCardEnterControl.h>
#import <OMNStyler.h>
#import "OMNPaymentAlertVC.h"

@interface OMNViewController ()
<OMNCardEnterControlDelegate>

@end

@implementation OMNViewController {
  OMNCardEnterControl *_cardEnterControl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
  b.backgroundColor = [UIColor redColor];
  [b addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
  [b setTitle:@"tap" forState:UIControlStateNormal];
  [self.view addSubview:b];
  
  
  return;
  _cardEnterControl = [[OMNCardEnterControl alloc] init];
  _cardEnterControl.translatesAutoresizingMaskIntoConstraints = NO;
  _cardEnterControl.delegate = self;
  [self.view addSubview:_cardEnterControl];
  self.view.backgroundColor = [UIColor whiteColor];
  NSDictionary *views =
  @{
    @"cardEnterControl" : _cardEnterControl,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [[OMNStyler styler] leftOffset],
    };
  
  NSArray *panH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[cardEnterControl]-|" options:0 metrics:metrics views:views];
  [self.view addConstraints:panH];

  NSArray *panV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[cardEnterControl]" options:0 metrics:nil views:views];
  [self.view addConstraints:panV];
  
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)tap {
  
  OMNPaymentAlertVC *paVC = [[OMNPaymentAlertVC alloc] initWithText:@"Вероятно, SMS-уведомления не подключены. Нужно посмотреть последнее списание в банковской выписке и узнать сумму." detailedText:@"Если посмотреть сумму списания сейчас возможности нет, вы можете однократно оплатить сумму без привязки карты." amount:100500];
  __weak typeof(self)weakSelf = self;
  
  paVC.didCloseBlock = ^{
    [weakSelf dismissViewControllerAnimated:YES completion:^{
      NSLog(@"dismissViewControllerAnimated");
    }];
  };
  
  [self presentViewController:paVC animated:YES completion:nil];
  
}

#pragma mark - OMNCardEnterControlDelegate

- (void)cardEnterControl:(OMNCardEnterControl *)control didEnterCardData:(NSDictionary *)cardData {
  [control endEditing:YES];
}

- (void)cardEnterControlDidRequestScan:(OMNCardEnterControl *)control {
  
}

- (void)cardEnterControlDidEnterFailCardData:(OMNCardEnterControl *)control {
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
