//
//  OMNTableVisitor.m
//  omnom
//
//  Created by tea on 06.05.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNTableVisitor.h"
#import "OMNScanTableQRCodeVC.h"
#import "OMNNavigationController.h"
#import "OMNDemoVisitor.h"
#import "OMNRestaurantManager.h"

@interface OMNTableVisitor ()
<OMNScanTableQRCodeVCDelegate>

@end

@implementation OMNTableVisitor {
  
  PMKFulfiller fulfiller;
  PMKRejecter rejecter;
  
}

- (PMKPromise *)enter:(UIViewController *)rootVC {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    OMNScanTableQRCodeVC *scanTableQRCodeVC = [[OMNScanTableQRCodeVC alloc] init];
    scanTableQRCodeVC.delegate = self;
    self->fulfiller = fulfill;
    self->rejecter = reject;
    scanTableQRCodeVC.didCloseBlock = ^{
      
      [rootVC dismissViewControllerAnimated:YES completion:^{
        
        reject([OMNError omnomErrorFromCode:kOMNErrorCancel]);
        
      }];
      
    };
    [rootVC presentViewController:[OMNNavigationController controllerWithRootVC:scanTableQRCodeVC] animated:YES completion:nil];

  }];
  
}

#pragma mark - OMNScanTableQRCodeVCDelegate

- (void)scanTableQRCodeVC:(OMNScanTableQRCodeVC *)scanTableQRCodeVC didFindRestaurant:(OMNRestaurant *)restaurant {
  fulfiller([OMNTableVisitor visitorWithRestaurant:restaurant delivery:[OMNDelivery delivery]]);
}

- (void)scanTableQRCodeVCRequestDemoMode:(OMNScanTableQRCodeVC *)scanTableQRCodeVC {
  
  [OMNRestaurantManager demoRestaurantWithCompletion:^(NSArray *restaurants) {
  
    fulfiller([OMNDemoVisitor visitorWithRestaurant:[restaurants firstObject] delivery:[OMNDelivery delivery]]);
    
  } failureBlock:^(OMNError *error) {
    
    rejecter(error);
    
  }];
  
}

- (NSString *)tags {
  return kEntranceModeOnTable;
}
- (NSString *)restarantCardButtonTitle {
  return kOMN_RESTAURANT_MODE_TABLE_TITLE;
}
- (NSString *)restarantCardButtonIcon {
  return @"card_ic_table";
}

@end
