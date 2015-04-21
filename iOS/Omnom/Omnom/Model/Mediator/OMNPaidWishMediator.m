//
//  OMNPaidPreorderMediator.m
//  omnom
//
//  Created by tea on 02.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNPaidWishMediator.h"
#import "OMNRestaurant+omn_payment.h"
#import "OMNNavigationController.h"
#import "OMNPaymentDoneVC.h"

@implementation OMNPaidWishMediator

- (NSString *)refreshOrdersTitle {
  return kOMN_WISH_RECOMMENDATIONS_LABEL_TEXT;
}

- (void)processCreatedWishForVisitor:(OMNVisitor *)visitor {
  
  self.wish = visitor.wish;
  OMNRestaurant *restaurant = self.restaurantMediator.restaurant;
  OMNAcquiringTransaction *transaction = [[restaurant paymentFactory] transactionForWish:self.wish];
  OMNTransactionPaymentVC *transactionPaymentVC = [[OMNTransactionPaymentVC alloc] initWithVisitor:visitor transaction:transaction];
  transactionPaymentVC.delegate = self;
  [self.rootVC presentViewController:[OMNNavigationController controllerWithRootVC:transactionPaymentVC] animated:YES completion:nil];
  
}

#pragma mark - OMNTransactionPaymentVCDelegate

- (void)transactionPaymentVCDidFinish:(OMNTransactionPaymentVC *)transactionPaymentVC withBill:(OMNBill *)bill {
  
  [transactionPaymentVC.presentingViewController dismissViewControllerAnimated:YES completion:nil];
  
  OMNPaymentDoneVC *wishSuccessVC = [[OMNPaymentDoneVC alloc] init];
  @weakify(self)
  wishSuccessVC.didFinishBlock = ^{
    
    @strongify(self)
    [self didFinishWish];
    
  };
  
  wishSuccessVC.backgroundImage = self.restaurantMediator.restaurant.decoration.woodBackgroundImage;
  [self.rootVC.navigationController pushViewController:wishSuccessVC animated:YES];
  
}

- (void)transactionPaymentVCDidCancel:(OMNTransactionPaymentVC *)transactionPaymentVC {
  [self.rootVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)transactionPaymentVCDidFail:(OMNTransactionPaymentVC *)transactionPaymentVC {
  [self closeTap];
}

@end
