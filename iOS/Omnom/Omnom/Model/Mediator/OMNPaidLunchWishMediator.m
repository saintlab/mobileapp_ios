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

- (PMKPromise *)processCreatedWishForVisitor:(OMNVisitor *)visitor {
  
  return [self payForVisitor:visitor].then(^(OMNTransactionPaymentVC *paymentVC, OMNBill *bill) {
    
    return [self paymentDoneForVisitor:visitor];
    
  });
  
}

- (PMKPromise *)paymentDoneForVisitor:(OMNVisitor *)visitor {
  
  @weakify(self)
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    @strongify(self)
    OMNLunchPaymentDoneVC *wishSuccessVC = [[OMNLunchPaymentDoneVC alloc] initWithVisitor:visitor];
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

- (NSString *)wishHintText {
  
  OMNDelivery *delivery = self.restaurantMediator.visitor.delivery;
  return [NSString stringWithFormat:kOMN_LUNCH_DELIVERY_HINT_FORMAT, [delivery.date omn_localizedDate], delivery.address.text];
  
}

@end
