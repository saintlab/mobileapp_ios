//
//  OMNPaidPreorderMediator.m
//  omnom
//
//  Created by tea on 02.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNPaidWishMediator.h"
#import "OMNSelectMinutesAlertVC.h"
#import "OMNRestaurant+omn_payment.h"
#import "OMNTransactionPaymentVC.h"
#import "OMNNavigationController.h"
#import "OMNNavigationControllerDelegate.h"
#import "OMNWishSuccessVC.h"

@interface OMNPaidWishMediator ()
<OMNTransactionPaymentVCDelegate>

@end

@implementation OMNPaidWishMediator {
  
  OMNWish *_wish;
  
}

- (void)createWish:(NSArray *)wishItems completionBlock:(OMNWishBlock)completionBlock wrongIDsBlock:(OMNWrongIDsBlock)wrongIDsBlock failureBlock:(void(^)(OMNError *error))failureBlock {

  OMNSelectMinutesAlertVC *selectMinutesAlertVC = [[OMNSelectMinutesAlertVC alloc] init];
  @weakify(self)
  selectMinutesAlertVC.didCloseBlock = ^{
    
    @strongify(self)
    [self.rootVC dismissViewControllerAnimated:YES completion:nil];
    
  };
  
  OMNRestaurant *restaurant = self.restaurantMediator.visitor.restaurant;
  selectMinutesAlertVC.didSelectMinutesBlock = ^(NSInteger minutes) {
    
    OMNRestaurant *deliveryRestaurant = [restaurant restaurantWithDelivery:[OMNRestaurantDelivery deliveryWithMinutes:minutes]];
    [deliveryRestaurant createWishForTable:nil products:wishItems completionBlock:^(OMNWish *wish) {
      
      @strongify(self)
      [self.rootVC dismissViewControllerAnimated:YES completion:nil];
      completionBlock(wish);
      
    } wrongIDsBlock:wrongIDsBlock failureBlock:failureBlock];
    
  };
  [self.rootVC presentViewController:selectMinutesAlertVC animated:YES completion:nil];
  
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
  
  OMNWishSuccessVC *wishSuccessVC = [[OMNWishSuccessVC alloc] initWithWish:_wish paymentOrdersURL:self.restaurantMediator.restaurant.orders_paid_url];
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

@end
