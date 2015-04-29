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

- (PMKPromise *)processCreatedWishForVisitor:(OMNVisitor *)visitor {
  
  return [self payForVisitor:visitor].then(^(OMNTransactionPaymentVC *paymentVC, OMNBill *bill) {
    
    return [self paymentDoneForVisitor:visitor];
    
  });
  
}

- (PMKPromise *)paymentDoneForVisitor:(OMNVisitor *)visitor {
  
  @weakify(self)
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    @strongify(self)
    OMNBarPaymentDoneVC *wishSuccessVC = [[OMNBarPaymentDoneVC alloc] initWithWish:visitor.wish paymentOrdersURL:self.restaurantMediator.restaurant.orders_paid_url];
    wishSuccessVC.didFinishBlock = ^{
      
      fulfill(nil);
      
    };
    wishSuccessVC.backgroundImage = self.restaurantMediator.restaurant.decoration.woodBackgroundImage;
    [self.rootVC.navigationController pushViewController:wishSuccessVC animated:YES];
    
  }];
  
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
