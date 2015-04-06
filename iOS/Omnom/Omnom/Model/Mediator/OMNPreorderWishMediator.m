//
//  OMNPreorderWishMediator.m
//  omnom
//
//  Created by tea on 03.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNPreorderWishMediator.h"
#import "OMNPreorderPaymentDoneVC.h"
#import "OMNSelectMinutesAlertVC.h"
#import "OMNPreorderVisitor.h"

@implementation OMNPreorderWishMediator

#pragma mark - OMNTransactionPaymentVCDelegate

- (void)createWish:(NSArray *)wishItems completionBlock:(OMNVisitorWishBlock)completionBlock wrongIDsBlock:(OMNWrongIDsBlock)wrongIDsBlock failureBlock:(void(^)(OMNError *error))failureBlock {
  
  OMNSelectMinutesAlertVC *selectMinutesAlertVC = [[OMNSelectMinutesAlertVC alloc] init];
  @weakify(self)
  selectMinutesAlertVC.didCloseBlock = ^{
    
    @strongify(self)
    [self.rootVC dismissViewControllerAnimated:YES completion:nil];
    
  };
  
  OMNRestaurant *restaurant = self.restaurantMediator.visitor.restaurant;
  selectMinutesAlertVC.didSelectMinutesBlock = ^(NSInteger minutes) {
    
    [[OMNPreorderVisitor visitorWithRestaurant:restaurant delivery:[OMNDelivery deliveryWithMinutes:minutes]] createWish:wishItems completionBlock:^(OMNVisitor *visitor) {
      
      @strongify(self)
      [self.rootVC dismissViewControllerAnimated:YES completion:nil];
      completionBlock(visitor);
      
    } wrongIDsBlock:wrongIDsBlock failureBlock:failureBlock];
    
  };
  [self.rootVC presentViewController:selectMinutesAlertVC animated:YES completion:nil];
  
}

- (NSString *)refreshOrdersTitle {
  return kOMN_WISH_RECOMMENDATIONS_LABEL_TEXT;
}

- (void)transactionPaymentVCDidFinish:(OMNTransactionPaymentVC *)transactionPaymentVC withBill:(OMNBill *)bill {
  
  [transactionPaymentVC.presentingViewController dismissViewControllerAnimated:YES completion:nil];
  
  OMNPreorderPaymentDoneVC *wishSuccessVC = [[OMNPreorderPaymentDoneVC alloc] initWithVisitor:transactionPaymentVC.visitor wish:self.wish];
  @weakify(self)
  wishSuccessVC.didFinishBlock = ^{
    
    @strongify(self)
    [self didFinishWish];
    
  };
  wishSuccessVC.backgroundImage = self.restaurantMediator.restaurant.decoration.woodBackgroundImage;
  [self.rootVC.navigationController pushViewController:wishSuccessVC animated:YES];
  
}

- (UIButton *)bottomButton {
  return nil;
}

@end
