//
//  OMNPaidPreorderMediator.m
//  omnom
//
//  Created by tea on 02.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNPaidPreorderMediator.h"
#import "OMNSelectMinutesAlertVC.h"

@implementation OMNPaidPreorderMediator

- (void)createWish:(NSArray *)wishItems completionBlock:(OMNWishBlock)completionBlock wrongIDsBlock:(OMNWrongIDsBlock)wrongIDsBlock failureBlock:(void(^)(OMNError *error))failureBlock {

  OMNSelectMinutesAlertVC *selectMinutesAlertVC = [[OMNSelectMinutesAlertVC alloc] init];
  @weakify(self)
  selectMinutesAlertVC.didCloseBlock = ^{
    
    @strongify(self)
    [self.rootVC dismissViewControllerAnimated:YES completion:nil];
    
  };
  [self.rootVC presentViewController:selectMinutesAlertVC animated:YES completion:nil];
  
#warning 123
  /*
  OMNRestaurantAddressSelectionVC *restaurantAddressSelectionVC = [[OMNRestaurantAddressSelectionVC alloc] initWithRestaurant:self.restaurantMediator.restaurant];
  @weakify(self)
  restaurantAddressSelectionVC.didCloseBlock = ^{
    
    @strongify(self)
    [self.rootVC dismissViewControllerAnimated:YES completion:nil];
    
  };
  
  OMNRestaurant *restaurant = self.restaurantMediator.visitor.restaurant;
  @weakify(restaurantAddressSelectionVC)
  
  UIBarButtonItem *nextItem = [UIBarButtonItem omn_barButtonWithTitle:kOMN_NEXT_BUTTON_TITLE color:[UIColor blackColor] actionBlock:^{
    
    @strongify(restaurantAddressSelectionVC)
    OMNRestaurant *deliveryRestaurant = [restaurant restaurantWithDelivery:[OMNRestaurantDelivery deliveryWithAddress:restaurantAddressSelectionVC.selectedAddress date:nil]];
    [deliveryRestaurant createWishForTable:nil products:wishItems completionBlock:^(OMNWish *wish) {
      
      @strongify(self)
      [self.rootVC dismissViewControllerAnimated:YES completion:nil];
      completionBlock(wish);
      
    } wrongIDsBlock:wrongIDsBlock failureBlock:failureBlock];
    
  }];
  nextItem.enabled = NO;
  
  restaurantAddressSelectionVC.didSelectRestaurantAddressBlock = ^(OMNRestaurantAddress *address) {
    
    nextItem.enabled = YES;
    
  };
  restaurantAddressSelectionVC.navigationItem.rightBarButtonItem = nextItem;
  
  [self.rootVC presentViewController:[[UINavigationController alloc] initWithRootViewController:restaurantAddressSelectionVC] animated:YES completion:nil];
*/
}

@end
