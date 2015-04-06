//
//  OMNBarPreorderMediator.m
//  omnom
//
//  Created by tea on 06.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNBarWishMediator.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNBarPaymentDoneVC.h"
#import "OMNLaunchHandler.h"

@implementation OMNBarWishMediator

#pragma mark - OMNTransactionPaymentVCDelegate

- (void)transactionPaymentVCDidFinish:(OMNTransactionPaymentVC *)transactionPaymentVC withBill:(OMNBill *)bill {
  
  [transactionPaymentVC.presentingViewController dismissViewControllerAnimated:YES completion:nil];
  
  OMNBarPaymentDoneVC *wishSuccessVC = [[OMNBarPaymentDoneVC alloc] initWithWish:self.wish paymentOrdersURL:self.restaurantMediator.restaurant.orders_paid_url];
  @weakify(self)
  wishSuccessVC.didFinishBlock = ^{
    
    @strongify(self)
    [self didFinishWish];
    
  };
  wishSuccessVC.backgroundImage = self.restaurantMediator.restaurant.decoration.woodBackgroundImage;
  [self.rootVC.navigationController pushViewController:wishSuccessVC animated:YES];
  
}

- (UIButton *)bottomButton {
  
  UIButton *bottomButton = nil;
  if (self.restaurantMediator.restaurant.orders_paid_url) {
    
    bottomButton = [UIButton omn_barButtonWithTitle:kOMN_BAR_BUTTON_COMPLETE_ORDERS_TEXT color:[UIColor blackColor] target:self action:@selector(completeOrdresCall)];;
    
  }
  return bottomButton;
  
}

- (void)completeOrdresCall {
  [[OMNLaunchHandler sharedHandler] openURL:self.restaurantMediator.restaurant.orders_paid_url];
}

@end
