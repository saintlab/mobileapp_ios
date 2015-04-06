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

- (void)createWish:(NSArray *)wishItems completionBlock:(OMNVisitorWishBlock)completionBlock wrongIDsBlock:(OMNWrongIDsBlock)wrongIDsBlock failureBlock:(void(^)(OMNError *error))failureBlock {

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
    [restaurantAddressSelectionVC.navigationItem setRightBarButtonItem:[UIBarButtonItem omn_loadingItem] animated:YES];
    
    OMNLunchVisitor *lunchVisitor = [OMNLunchVisitor visitorWithRestaurant:restaurant delivery:[OMNDelivery deliveryWithAddress:restaurantAddressSelectionVC.selectedAddress date:nil]];
    [lunchVisitor createWish:wishItems completionBlock:^(OMNVisitor *visitor) {
      
      @strongify(self)
      [self.rootVC dismissViewControllerAnimated:YES completion:nil];
      completionBlock(visitor);

    } wrongIDsBlock:^(NSArray *wrongIDs) {
      
      @strongify(self)
      [self.rootVC dismissViewControllerAnimated:YES completion:nil];
      wrongIDsBlock(wrongIDs);
      
    } failureBlock:^(OMNError *error) {
      
      @strongify(self)
      [self.rootVC dismissViewControllerAnimated:YES completion:nil];
      failureBlock(error);

    }];
    
  }];
  nextItem.enabled = NO;
  
  restaurantAddressSelectionVC.didSelectRestaurantAddressBlock = ^(OMNRestaurantAddress *address) {
    
    nextItem.enabled = YES;
    
  };
  restaurantAddressSelectionVC.navigationItem.rightBarButtonItem = nextItem;
  
  [self.rootVC presentViewController:[[UINavigationController alloc] initWithRootViewController:restaurantAddressSelectionVC] animated:YES completion:nil];
  
}

- (void)processCreatedWishForVisitor:(OMNVisitor *)visitor {
  
  @weakify(self)
  OMNSuncityPreorderDoneVC *preorderDoneVC = [[OMNSuncityPreorderDoneVC alloc] initWithWish:visitor.wish didCloseBlock:^{
    
    @strongify(self)
    [self didFinishWish];
    
  }];
  [self.rootVC presentViewController:preorderDoneVC animated:YES completion:nil];
  
}

@end
