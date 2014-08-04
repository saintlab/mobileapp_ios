//
//  OMNViewController.m
//  OMNMailRuAcquiring
//
//  Created by teanet on 07/08/2014.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import "OMNViewController.h"
#import <OMNMailRuAcquiring.h>

static NSString * const kOMNMailRu_cvv = @"123";

@interface OMNViewController ()

@end

@implementation OMNViewController {
  NSString *_cardId;
  NSDictionary *_cardInfo;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
//  _cardId = @"30002847034833862453";
//  _cardInfo =
//  @{
//    @"pan" : @"4111111111111111",
//    @"exp_date" : @"12.2015",
//    @"cvv" : kOMNMailRu_cvv,
//    };
  
  _cardId = @"30004501610923294711";
  _cardInfo =
  @{
    @"pan" : @"6011000000000004",
    @"exp_date" : @"12.2015",
    @"cvv" : kOMNMailRu_cvv,
    };
  
//  _cardId = @"30001197651493912571";
//  _cardInfo =
//  @{
//    @"pan" : @"639002000000000003",
//    @"exp_date" : @"12.2015",
//    @"cvv" : kOMNMailRu_cvv,
//    };
  
}

- (IBAction)payAndRegisterTap:(id)sender {
  
  [[OMNMailRuAcquiring acquiring] payWithCardInfo:_cardInfo addCard:YES];
  
}

- (IBAction)registerTap:(id)sender {
  [[OMNMailRuAcquiring acquiring] registerCard:_cardInfo completion:nil];
}

- (IBAction)verifyTap:(id)sender {
  [[OMNMailRuAcquiring acquiring] cardVerify:1.04 card_id:_cardId];
}

- (IBAction)deleteCard:(id)sender {
  [[OMNMailRuAcquiring acquiring] cardDelete:_cardId];
}
- (IBAction)payWithCardID:(id)sender {
  
  NSDictionary *cardInfo =
  @{
    @"card_id" : _cardId,
    @"cvv" : kOMNMailRu_cvv,
    };
  
  [[OMNMailRuAcquiring acquiring] payWithCardInfo:cardInfo addCard:NO];
  
}

- (IBAction)payWithNewCard:(id)sender {
  
  [[OMNMailRuAcquiring acquiring] payWithCardInfo:_cardInfo addCard:NO];
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
