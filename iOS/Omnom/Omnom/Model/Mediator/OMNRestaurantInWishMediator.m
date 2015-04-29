//
//  OMNRestaurantInWishMediator.m
//  omnom
//
//  Created by tea on 13.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurantInWishMediator.h"
#import "OMNRestaurantInPaymentDoneVC.h"

@implementation OMNRestaurantInWishMediator

- (PMKPromise *)processCreatedWishForVisitor:(OMNVisitor *)visitor {
  
  return [self payForVisitor:visitor].then(^(OMNTransactionPaymentVC *paymentVC, OMNBill *bill) {
    
    return [self paymentDoneForVisitor:visitor];
    
  });
  
}

- (PMKPromise *)paymentDoneForVisitor:(OMNVisitor *)visitor {
  
  @weakify(self)
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    @strongify(self)
    OMNRestaurantInPaymentDoneVC *wishSuccessVC = [[OMNRestaurantInPaymentDoneVC alloc] initWithVisitor:visitor];
    wishSuccessVC.didFinishBlock = ^{
      
      fulfill(nil);
      
    };
    wishSuccessVC.backgroundImage = self.restaurantMediator.restaurant.decoration.woodBackgroundImage;
    [self.rootVC.navigationController pushViewController:wishSuccessVC animated:YES];
    
  }];
  
}

- (UIButton *)bottomButton {
  return nil;
}

@end
