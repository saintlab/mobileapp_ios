//
//  OMNBarPreorderMediator.m
//  omnom
//
//  Created by tea on 06.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNBarPreorderMediator.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNModalWebVC.h"
#import "OMNRestaurant+omn_payment.h"
#import "OMNTransactionPaymentVC.h"
#import "OMNNavigationController.h"
#import "OMNNavigationControllerDelegate.h"
#import "OMNWishSuccessVC.h"

@interface OMNBarPreorderMediator ()
<OMNTransactionPaymentVCDelegate>

@end

@implementation OMNBarPreorderMediator {
  
  OMNWish *_wish;
  
}

- (NSString *)refreshOrdersTitle {
  return kOMN_WISH_RECOMMENDATIONS_LABEL_TEXT;
}

- (void)processCreatedWish:(OMNWish *)wish {
  
  _wish = wish;

  OMNRestaurant *restaurant = self.restaurantMediator.restaurant;
  OMNAcquiringTransaction *transaction = [[restaurant paymentFactory] transactionForWish:wish];
  OMNTransactionPaymentVC *transactionPaymentVC = [[OMNTransactionPaymentVC alloc] initWithRestaurant:restaurant transaction:transaction];
  transactionPaymentVC.delegate = self;
  UINavigationController *navigationController = [[OMNNavigationController alloc] initWithRootViewController:transactionPaymentVC];
  navigationController.delegate = [OMNNavigationControllerDelegate sharedDelegate];
  [self.rootVC presentViewController:navigationController animated:YES completion:nil];
  
}

#pragma mark - OMNTransactionPaymentVCDelegate

- (void)transactionPaymentVCDidFinish:(OMNTransactionPaymentVC *)transactionPaymentVC withBill:(OMNBill *)bill {
  
  [self.rootVC dismissViewControllerAnimated:YES completion:nil];
  
  OMNWishSuccessVC *wishSuccessVC = [[OMNWishSuccessVC alloc] initWithWish:_wish];
  @weakify(self)
  wishSuccessVC.didFinishBlock = ^{
    
    @strongify(self)
    [self didFinishWish];
    
  };
  wishSuccessVC.backgroundImage = self.restaurantMediator.restaurant.decoration.woodBackgroundImage;
  [self.rootVC.navigationController pushViewController:wishSuccessVC animated:NO];
  
}

- (void)transactionPaymentVCDidCancel:(OMNTransactionPaymentVC *)transactionPaymentVC {
  [self.rootVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)transactionPaymentVCDidFail:(OMNTransactionPaymentVC *)transactionPaymentVC {
  self.rootVC.didFinishBlock();
}

- (UIButton *)bottomButton {
  
  UIButton *bottomButton = nil;
  
  if (self.restaurantMediator.restaurant.orders_paid_url) {
    
    bottomButton = [UIButton omn_barButtonWithTitle:kOMN_BAR_BUTTON_COMPLETE_ORDERS_TEXT color:[UIColor blackColor] target:self action:@selector(completeOrdresCall)];;
    
  }
  return bottomButton;
  
}

- (void)completeOrdresCall {
  
  OMNModalWebVC *modalWebVC = [[OMNModalWebVC alloc] init];
  modalWebVC.url = self.restaurantMediator.restaurant.orders_paid_url;
  @weakify(self)
  modalWebVC.didCloseBlock = ^{
    
    @strongify(self)
    [self.rootVC dismissViewControllerAnimated:YES completion:nil];
    
  };
  [self.rootVC presentViewController:[[UINavigationController alloc] initWithRootViewController:modalWebVC] animated:YES completion:nil];
  
}

@end
