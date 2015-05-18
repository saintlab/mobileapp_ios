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
#import "OMNAuthorization.h"

@implementation OMNPaidWishMediator

- (NSString *)refreshOrdersTitle {
  return kOMN_WISH_RECOMMENDATIONS_LABEL_TEXT;
}

- (PMKPromise *)processCreatedWish:(OMNWish *)wish {

  return [self payForWish:wish].then(^(OMNTransactionPaymentVC *paymentVC, OMNBill *bill) {
    
    return [self paymentDone];
    
  });
  
}

- (PMKPromise *)payForWish:(OMNWish *)wish {
  
  OMNVisitor *visitor = self.restaurantMediator.visitor;
  OMNAcquiringTransaction *transaction = [[visitor.restaurant paymentFactory] transactionForUser:[OMNAuthorization authorization].user wish:wish];
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
