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

#pragma mark - OMNTransactionPaymentVCDelegate

- (void)transactionPaymentVCDidFinish:(OMNTransactionPaymentVC *)transactionPaymentVC withBill:(OMNBill *)bill {
  
  [transactionPaymentVC.presentingViewController dismissViewControllerAnimated:YES completion:nil];
  
  OMNRestaurantInPaymentDoneVC *wishSuccessVC = [[OMNRestaurantInPaymentDoneVC alloc] initWithVisitor:transactionPaymentVC.visitor wish:self.wish];
  @weakify(self)
  wishSuccessVC.didFinishBlock = ^{
    
    @strongify(self)
    [self didFinishWish];
    
  };
  
  wishSuccessVC.backgroundImage = self.restaurantMediator.restaurant.decoration.woodBackgroundImage;
  [self.rootVC.navigationController pushViewController:wishSuccessVC animated:YES];
  
}

@end
