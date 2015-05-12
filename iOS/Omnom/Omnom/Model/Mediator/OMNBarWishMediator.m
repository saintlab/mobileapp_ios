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
#import "OMNBarVisitor.h"
#import "OMNSelectTipsAlertVC.h"

@implementation OMNBarWishMediator

- (PMKPromise *)getVisitor {
  
  OMNRestaurant *restaurant = self.restaurantMediator.visitor.restaurant;
  @weakify(self)
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    @strongify(self)
    [self selectTipsWithCompletion:^(NSInteger amount) {
      
      OMNBarVisitor *barVisitor = [OMNBarVisitor visitorWithRestaurant:restaurant delivery:[OMNDelivery delivery]];
      fulfill(barVisitor);
      
    } cancel:^{
      
      reject([OMNError omnomErrorFromCode:kOMNErrorCancel]);
      
    }];
    
  }];
  
}

- (void)selectTipsWithCompletion:(OMNSelectTipsBlock)selectTipsBlock cancel:(dispatch_block_t)cancelBlock {
  
  OMNSelectTipsAlertVC *selectMinutesAlertVC = [[OMNSelectTipsAlertVC alloc] initWithTotalAmount:self.restaurantMediator.menu.preorderedItemsTotal];
  @weakify(self)
  selectMinutesAlertVC.didCloseBlock = ^{
    
    @strongify(self)
    [self.rootVC dismissViewControllerAnimated:YES completion:cancelBlock];
    
  };
  
  selectMinutesAlertVC.didSelectTipsBlock = ^(NSInteger amount) {
    
    @strongify(self)
    [self.rootVC dismissViewControllerAnimated:YES completion:^{
      selectTipsBlock(amount);
    }];
    
  };
  [self.rootVC presentViewController:selectMinutesAlertVC animated:YES completion:nil];
  
}

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
  [[OMNLaunchHandler sharedHandler] showModalControllerWithURL:self.restaurantMediator.restaurant.orders_paid_url];
}

@end
