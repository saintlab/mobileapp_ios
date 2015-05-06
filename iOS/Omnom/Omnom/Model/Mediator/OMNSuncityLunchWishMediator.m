//
//  OMNSuncityLunchPreorderMediator.m
//  omnom
//
//  Created by tea on 01.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNSuncityLunchWishMediator.h"
#import "OMNRestaurantAddressSelectionVC.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNSuncityPreorderDoneVC.h"
#import "OMNLunchVisitor.h"

@implementation OMNSuncityLunchWishMediator


- (PMKPromise *)getVisitor {
  
  @weakify(self)
  OMNRestaurant *restaurant = self.restaurantMediator.visitor.restaurant;
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    @strongify(self)
    [self selectAddressWithCompletion:^(OMNRestaurantAddress *restaurantAddress) {
      
      OMNLunchVisitor *lunchVisitor = [OMNLunchVisitor visitorWithRestaurant:restaurant delivery:[OMNDelivery deliveryWithAddress:restaurantAddress date:nil]];
      fulfill(lunchVisitor);
      
    } cancel:^{
      
      reject([OMNError omnomErrorFromCode:kOMNErrorCancel]);
      
    }];    

  }];
  
}

- (void)selectAddressWithCompletion:(OMNRestaurantAddressBlock)restaurantAddressBlock cancel:(dispatch_block_t)cancelBlock {
  
  OMNRestaurantAddressSelectionVC *restaurantAddressSelectionVC = [[OMNRestaurantAddressSelectionVC alloc] initWithRestaurant:self.restaurantMediator.restaurant];
  @weakify(self)
  restaurantAddressSelectionVC.didCloseBlock = ^{
    
    @strongify(self)
    [self.rootVC dismissViewControllerAnimated:YES completion:cancelBlock];
    
  };
  
  @weakify(restaurantAddressSelectionVC)
  UIBarButtonItem *nextItem = [UIBarButtonItem omn_barButtonWithTitle:kOMN_NEXT_BUTTON_TITLE color:[UIColor blackColor] actionBlock:^{
    
    [restaurantAddressSelectionVC.navigationItem setRightBarButtonItem:[UIBarButtonItem omn_loadingItem] animated:YES];
    @strongify(restaurantAddressSelectionVC)
    @strongify(self)
    [self.rootVC dismissViewControllerAnimated:YES completion:^{
      
      restaurantAddressBlock(restaurantAddressSelectionVC.selectedAddress);
      
    }];
    
  }];
  nextItem.enabled = NO;
  
  restaurantAddressSelectionVC.didSelectRestaurantAddressBlock = ^(OMNRestaurantAddress *address) {
    
    nextItem.enabled = YES;
    
  };
  restaurantAddressSelectionVC.navigationItem.rightBarButtonItem = nextItem;
  
  [self.rootVC presentViewController:[[UINavigationController alloc] initWithRootViewController:restaurantAddressSelectionVC] animated:YES completion:nil];
  
}

- (PMKPromise *)processCreatedWishForVisitor:(OMNVisitor *)visitor {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    OMNSuncityPreorderDoneVC *preorderDoneVC = [[OMNSuncityPreorderDoneVC alloc] initWithWish:visitor.wish didCloseBlock:^{
      
      fulfill(nil);
      
    }];
    [self.rootVC presentViewController:preorderDoneVC animated:YES completion:nil];
    
  }];
  
}

@end
