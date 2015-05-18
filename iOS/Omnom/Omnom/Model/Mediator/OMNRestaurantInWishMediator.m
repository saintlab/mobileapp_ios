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

- (PMKPromise *)processCreatedWish:(OMNWish *)wish {
  
  return [self payForWish:wish].then(^(OMNTransactionPaymentVC *paymentVC, OMNBill *bill) {
    
    return [self paymentDoneForWish:wish];
    
  });
  
}

- (PMKPromise *)paymentDoneForWish:(OMNWish *)wish {
  
  @weakify(self)
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    @strongify(self)
    OMNRestaurantInPaymentDoneVC *wishSuccessVC = [[OMNRestaurantInPaymentDoneVC alloc] initWithWish:wish];
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
