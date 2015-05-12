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

- (PMKPromise *)createWishForVisitor:(OMNVisitor *)visitor {
  
  if (!visitor.restaurant.settings.has_bar_tips) {
    return [visitor createWish:self.selectedWishItems];
  }
  
  NSMutableArray *selectedWishItems = [self.selectedWishItems mutableCopy];
  return [self selectTips].then(^(NSNumber *tipsAmount) {
  
    NSInteger amount = round(tipsAmount.doubleValue/100.0);
    if (amount > 0) {

      [selectedWishItems addObject:
       @{
         @"id" : @"omnom-tips",
         @"quantity" : @(amount),
         }];

    }
    return [visitor createWish:selectedWishItems];
    
  });
  
}

- (PMKPromise *)selectTips {
  
  OMNSelectTipsAlertVC *selectMinutesAlertVC = [[OMNSelectTipsAlertVC alloc] initWithTotalAmount:self.restaurantMediator.menu.preorderedItemsTotal];
  @weakify(self)
  PMKPromise *promise = [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    selectMinutesAlertVC.didCloseBlock = ^{
      
      @strongify(self)
      [self.rootVC dismissViewControllerAnimated:YES completion:^{
        reject([OMNError omnomErrorFromCode:kOMNErrorCancel]);
      }];
      
    };

    selectMinutesAlertVC.didSelectTipsBlock = ^(NSInteger amount) {
      
      @strongify(self)
      [self.rootVC dismissViewControllerAnimated:YES completion:^{
        fulfill(@(amount));
      }];
      
    };
    
  }];
  [self.rootVC presentViewController:selectMinutesAlertVC animated:YES completion:nil];
  return promise;
  
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
