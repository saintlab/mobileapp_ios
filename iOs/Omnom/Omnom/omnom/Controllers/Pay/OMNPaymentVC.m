//
//  OMNPaymentVC.m
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNPaymentVC.h"
#import "OMNBankCard.h"
#import "OMNOrder.h"

@interface OMNPaymentVC ()

@end

@implementation OMNPaymentVC {
  OMNBankCard *_bankCard;
  OMNOrder *_order;
}

- (instancetype)initWithCard:(OMNBankCard *)bankCard order:(OMNOrder *)order {
  self = [super init];
  if (self) {
    _order = order;
    _bankCard = bankCard;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
}

- (IBAction)didPayTap:(id)sender {
  [self.delegate paymentVCDidFinish:self];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
