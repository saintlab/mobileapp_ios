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

- (PMKPromise *)getVisitor {
  
  OMNRestaurant *restaurant = self.restaurantMediator.visitor.restaurant;
  @weakify(self)
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    @strongify(self)
    [self selectMinutesWithCompletion:^(NSInteger minutes) {
      
      OMNPreorderVisitor *visitorWithDelay = [OMNPreorderVisitor visitorWithRestaurant:restaurant delivery:[OMNDelivery deliveryWithMinutes:minutes]];
      fulfill(visitorWithDelay);
      
    } cancel:^{
      
      reject([OMNError omnomErrorFromCode:kOMNErrorCancel]);
      
    }];
    
  }];
  
}

- (void)selectMinutesWithCompletion:(OMNSelectMinutesBlock)selectMinutesBlock cancel:(dispatch_block_t)cancelBlock {
  
  OMNSelectMinutesAlertVC *selectMinutesAlertVC = [[OMNSelectMinutesAlertVC alloc] init];
  @weakify(self)
  selectMinutesAlertVC.didCloseBlock = ^{
    
    @strongify(self)
    [self.rootVC dismissViewControllerAnimated:YES completion:cancelBlock];
    
  };
  
  selectMinutesAlertVC.didSelectMinutesBlock = ^(NSInteger minutes) {

    @strongify(self)
    [self.rootVC dismissViewControllerAnimated:YES completion:^{
      selectMinutesBlock(minutes);
    }];
    
  };
  [self.rootVC presentViewController:selectMinutesAlertVC animated:YES completion:nil];
  
}

- (PMKPromise *)processCreatedWishForVisitor:(OMNVisitor *)visitor {
  
  return [self payForVisitor:visitor].then(^(OMNTransactionPaymentVC *paymentVC, OMNBill *bill) {
  
    return [self paymentDoneForVisitor:paymentVC.visitor];
    
  });
  
}

- (PMKPromise *)paymentDoneForVisitor:(OMNVisitor *)visitor {
  
  @weakify(self)
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    @strongify(self)
    OMNPreorderPaymentDoneVC *wishSuccessVC = [[OMNPreorderPaymentDoneVC alloc] initWithVisitor:visitor];
    wishSuccessVC.didFinishBlock = ^{
      
      fulfill(nil);
      
    };
    wishSuccessVC.backgroundImage = self.restaurantMediator.restaurant.decoration.woodBackgroundImage;
    [self.rootVC.navigationController pushViewController:wishSuccessVC animated:YES];
    
  }];
  
}

- (NSString *)refreshOrdersTitle {
  return kOMN_WISH_RECOMMENDATIONS_LABEL_TEXT;
}

- (UIButton *)bottomButton {
  return nil;
}

@end
