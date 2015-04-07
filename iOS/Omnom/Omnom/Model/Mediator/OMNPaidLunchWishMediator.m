//
//  OMNPaidLunchWishMediator.m
//  omnom
//
//  Created by tea on 06.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNPaidLunchWishMediator.h"
#import "OMNLunchPaymentDoneVC.h"
#import "NSString+omn_date.h"

@implementation OMNPaidLunchWishMediator

- (void)transactionPaymentVCDidFinish:(OMNTransactionPaymentVC *)transactionPaymentVC withBill:(OMNBill *)bill {
  
  [transactionPaymentVC.presentingViewController dismissViewControllerAnimated:YES completion:nil];
  
  OMNLunchPaymentDoneVC *wishSuccessVC = [[OMNLunchPaymentDoneVC alloc] initWithVisitor:transactionPaymentVC.visitor wish:self.wish];
  @weakify(self)
  wishSuccessVC.didFinishBlock = ^{
    
    @strongify(self)
    [self didFinishWish];
    
  };
  wishSuccessVC.backgroundImage = self.restaurantMediator.restaurant.decoration.woodBackgroundImage;
  [self.rootVC.navigationController pushViewController:wishSuccessVC animated:YES];
  
}

- (UIButton *)bottomButton {
  return nil;
}

- (NSString *)wishHintText {
  
  OMNDelivery *delivery = self.restaurantMediator.visitor.delivery;
  return [NSString stringWithFormat:kOMN_LUNCH_DELIVERY_HINT_FORMAT, [delivery.date omn_localizedDate], delivery.address.text];
  
}

@end
