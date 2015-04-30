//
//  OMNPaidPreorderMediator.m
//  omnom
//
//  Created by tea on 02.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNPaidWishMediator.h"
#import "OMNRestaurant+omn_payment.h"
#import "OMNScrollContentVC.h"

@implementation OMNPaidWishMediator

- (NSString *)refreshOrdersTitle {
  return kOMN_WISH_RECOMMENDATIONS_LABEL_TEXT;
}

- (PMKPromise *)processCreatedWishForVisitor:(OMNVisitor *)visitor {

  return [self payForVisitor:visitor].then(^(OMNTransactionPaymentVC *paymentVC, OMNBill *bill) {
    
    return [self paymentDone];
    
  });
  
}

- (PMKPromise *)payForVisitor:(OMNVisitor *)visitor {
  
  OMNRestaurant *restaurant = self.restaurantMediator.restaurant;
  OMNAcquiringTransaction *transaction = [[restaurant paymentFactory] transactionForWish:visitor.wish];
  OMNTransactionPaymentVC *transactionPaymentVC = [[OMNTransactionPaymentVC alloc] initWithVisitor:visitor transaction:transaction];
  return [transactionPaymentVC pay:self.rootVC];
  
}

- (PMKPromise *)paymentDone {

  @weakify(self)
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    @strongify(self)
    OMNScrollContentVC *wishSuccessVC = [[OMNScrollContentVC alloc] init];
    wishSuccessVC.didFinishBlock = ^{
      
      fulfill(nil);
      
    };
    wishSuccessVC.backgroundImage = self.restaurantMediator.restaurant.decoration.woodBackgroundImage;
    [self.rootVC.navigationController pushViewController:wishSuccessVC animated:YES];
    
  }];
  
}

@end
