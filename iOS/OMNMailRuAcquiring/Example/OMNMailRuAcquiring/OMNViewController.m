//
//  OMNViewController.m
//  OMNMailRuAcquiring
//
//  Created by teanet on 07/08/2014.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import "OMNViewController.h"
#import <OMNMailRuAcquiring.h>


@interface OMNViewController ()

@end

@implementation OMNViewController {
  NSString *_cardId;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  _cardId = @"30002847034833862453";
}

- (IBAction)payAndRegisterTap:(id)sender {
  
//  NSDictionary *cardInfo =
//  @{
//    @"pan" : @"4111111111111111",
//    @"exp_date" : @"12.2015",
//    @"cvv" : @"123",
//    };

  NSDictionary *cardInfo =
  @{
    @"pan" : @"6011000000000004",
    @"exp_date" : @"12.2015",
    @"cvv" : @"123",
    };

//  NSDictionary *cardInfo =
//  @{
//    @"pan" : @"639002000000000003",
//    @"exp_date" : @"12.2015",
//    @"cvv" : @"123",
//    };
  
  [[OMNMailRuAcquiring acquiring] payWithCardInfo:cardInfo addCard:YES];
  
}
- (IBAction)registerTap:(id)sender {
  [[OMNMailRuAcquiring acquiring] registerCard:nil expDate:nil cvv:nil];
}
- (IBAction)verifyTap:(id)sender {
  [[OMNMailRuAcquiring acquiring] cardVerify:1.04 card_id:_cardId];
}

- (IBAction)payWithCardID:(id)sender {
  
  NSDictionary *cardInfo =
  @{
    @"card_id" : _cardId,
    };
  
  [[OMNMailRuAcquiring acquiring] payWithCardInfo:cardInfo addCard:NO];
  
}

- (IBAction)payWithNewCard:(id)sender {
  
  
  
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
